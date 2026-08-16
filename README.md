# TripAdvisor Hotel Reviews API

[![Run on Apify](https://apify.com/actor-badge?actor=factden/tripadvisor-hotel-reviews-api)](https://apify.com/factden/tripadvisor-hotel-reviews-api?fpr=factden)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Scrape **all reviews and full property details from any TripAdvisor hotel, restaurant or attraction**, as
structured JSON, CSV or Excel. Two modes: **Reviews** (give it a TripAdvisor URL or location ID) returns every
review, with reviewer profile, per-review subratings and owner responses, plus a rich property record (ranking,
price range, amenities, official category subratings and TripAdvisor's AI review summary). **Discover** (give it a
city name) returns a list of that city's places with the same property details.

This repository is the **public documentation** for the actor. The actor itself runs on Apify:
👉 **[apify.com/factden/tripadvisor-hotel-reviews-api](https://apify.com/factden/tripadvisor-hotel-reviews-api?fpr=factden)**

**Watch the 80-second walkthrough:**

[![How to Scrape TripAdvisor Reviews to CSV (No Code)](https://img.youtube.com/vi/SBJPKMIv_o8/maxresdefault.jpg)](https://www.youtube.com/watch?v=SBJPKMIv_o8)

- **Actor ID:** `jDQ2qpF4iRYLbUM0c` · **slug:** `tripadvisor-hotel-reviews-api`
- Works for **hotels**, **restaurants** and **attractions**, identical output shape, type-specific fields fill
  in conditionally.
- Two datasets: **reviews** (default, one row per review) and **properties** ("Places", one record per place).

## What it extracts

**Per review** (default `reviews` dataset, one row each):

- Rating (1-5), title, full text, language and machine-translation flag
- Published date, travel/stay month, platform and helpful-vote count
- Per-review **subratings** (Rooms, Service, Cleanliness, Value, Location, Sleep quality)
- **Owner response** (responder, text, date) when the business replied
- **Reviewer profile**, username, display name, location, total contributions, avatar
- `markdownContent`, an LLM-ready Markdown rendering of the review

**Per place** (`properties` dataset, one record each, always emitted):

- Name, category, description, overall rating, review count and star histogram
- **City ranking** (`#309 of 594 hotels in Barcelona`), price range and price level, hotel class
- Address (structured + formatted), latitude/longitude, phone, email, website
- Amenities / cuisine / dietary options, opening hours, awards
- Official TripAdvisor **category subratings** + **AI review summary**; photos (opt-in)
- TripAdvisor's **AI review summary**, plus `markdownContent`

See **[FIELDS.md](FIELDS.md)** for the full data dictionary and **[HOWTO.md](HOWTO.md)** for a step-by-step guide.

## Quick start

Run it from the Apify Console (paste [`examples/input.json`](examples/input.json) into the Input tab), or call it
from the API / a client library. Get an API token at
[console.apify.com/account/integrations](https://console.apify.com/account/integrations).

**CLI** (with the [Apify CLI](https://docs.apify.com/cli)):

```bash
apify call factden/tripadvisor-hotel-reviews-api --input-file examples/input.json
```

**curl**, start a run and download the reviews in one call:

```bash
curl -s -X POST \
  "https://api.apify.com/v2/acts/factden~tripadvisor-hotel-reviews-api/run-sync-get-dataset-items?token=$APIFY_TOKEN" \
  -H 'Content-Type: application/json' \
  -d @examples/input.json
```

**Python** (`pip install apify-client`):

```python
import os
from apify_client import ApifyClient

client = ApifyClient(os.environ["APIFY_TOKEN"])

run = client.actor("factden/tripadvisor-hotel-reviews-api").call(run_input={
    "startUrls": [{"url": "https://www.tripadvisor.com/Hotel_Review-g187497-d1465497-Reviews-W_Barcelona-Barcelona_Catalonia.html"}],
    "maxReviews": 50,
})

for review in client.dataset(run["defaultDatasetId"]).iterate_items():
    print(review["rating"], review["title"], review["placeName"])
```

More runnable snippets (Python, Node.js, curl) live in **[snippets/](snippets/)**.

### Input at a glance

| Field | What it does |
|---|---|
| `mode` | **Reviews** (default) = scrape reviews for the places you name below; **Discover** = search a city or keyword and list places |
| `startUrls` | (Reviews) TripAdvisor `Hotel_Review` / `Restaurant_Review` / `Attraction_Review` / `Airline_Review` URLs |
| `locationIds` | (Reviews) TripAdvisor location IDs (the `d`-number), instead of/alongside URLs |
| `searchKeywords` + `placeTypes` + `maxPlaces` | (Discover) search a property name/brand/keyword (e.g. `Hilton`) and get the matching places directly |
| `searchLocation` | (Discover) optional city or country to filter keyword results to (e.g. `Hilton` + `Belgium`); a city can also be listed on its own, a country must be paired with a keyword |

Keyword search matches by **whole words** in the property name (accent-insensitive), so type the full brand or venue word: `Hilton`, `W Barcelona`, `Ritz Carlton`, `Meliá` all work. A trailing partial word is fine (`Hilton Gard` finds "Hilton Garden Inn"), but a standalone fragment like `Hil` will not match. Sub-brands with a different name (e.g. `Conrad`, `Waldorf Astoria`) are not returned by the parent brand, search them by their own name.
| `maxReviews` | Cap reviews per place (newest-first; large number = all) |
| `reviewLanguages` | Keep only reviews in these languages (or all) |
| `minRating` / `maxRating` | Star band, 1-5 (set equal for a single rating) |
| `fromDate` / `toDate` | Review date window (`YYYY-MM-DD`), great for incremental refreshes |
| `proxyConfiguration` | Proxy settings (Apify Proxy datacenter is the default and is plenty) |

## Output

Every review becomes one row in the default **reviews** dataset; every place becomes one record in the
**properties** dataset. Download as JSON, CSV, Excel, HTML or RSS, or pull via the API.

Real sample output (built from a live run against W Barcelona) is in **[examples/](examples/)**:
[`reviews.sample.json`](examples/reviews.sample.json), [`places.sample.json`](examples/places.sample.json) and
[`reviews-sample.csv`](examples/reviews-sample.csv).

## Use cases

- **Reputation & guest-experience monitoring**, track new reviews, ratings and owner-response coverage across a
  portfolio of properties.
- **Competitive benchmarking**, compare rankings, price levels and subratings against rivals.
- **Voice-of-customer & LLM analysis**, feed `markdownContent` straight into RAG, summarization or sentiment
  pipelines.
- **Market research**, pull every hotel/restaurant/attraction in a city with discovery mode.
- **Lead lists & enrichment**, collect names, addresses, phone, website and category for places in a geography.

## Cost

**No start fee.** Pay only for what you collect:

- **Reviews:** ~**$0.45 per 1,000 reviews** on the Free plan, dropping to **$0.38 per 1,000** on Gold.
- **Property records:** **$2.00 per 1,000** (Free) → **$1.40 per 1,000** (Gold), one per place (always emitted;
  in Discover mode this is the only charge).

New Apify accounts include **free monthly usage credit**, so you can pull thousands of reviews before paying
anything. A first run of 50 reviews with property details costs a fraction of a cent, well within the free tier.

## FAQ

**Does it work for restaurants and attractions, not just hotels?**
Yes. Paste any `Hotel_Review`, `Restaurant_Review` or `Attraction_Review` URL (or search a city and pick the
place types). The output shape is identical; type-specific fields like amenities, cuisine or opening hours fill in
when relevant.

**Does it work for airlines?**
Yes, in Reviews mode. Paste an `Airline_Review` URL (or the airline's location ID) and you get every review as
usual. Airlines have no official subratings or AI review summary, and are not covered by Discover keyword search.

**Can I get every review for a place?**
Yes, set `maxReviews` to a large number (e.g. `100000`). Reviews are paginated newest-first, so a smaller cap
keeps a first run fast and cheap, and a rolling `fromDate` makes recurring runs pull only what's new.

**Do I have to provide URLs?**
No. You can pass location IDs instead. Or switch to **Discover** mode and enter a city or country in `searchLocation`
to get a list of that place's places (details only), then feed those location IDs back into **Reviews**
mode for their reviews. A stale or merged URL/ID still works, it self-heals to the current place.

**Is web scraping legal?**
The actor collects **publicly available** information. You are responsible for using the data in line with
applicable laws, TripAdvisor's terms and privacy regulations (e.g. GDPR). It does not access anything behind a
login. Questions or a bug? Open an issue on this repo or use the actor's **Issues** tab.

## Other FactDen scrapers

Building a review or travel dataset? These pair well with this actor:

- [MCA India Company & Director Data Scraper](https://apify.com/factden/mca-company-director-scraper?fpr=factden) - India MCA company master + directors' personal email & phone ([docs](https://github.com/factden/mca-company-director-scraper))
- [Google Hotels Scraper](https://apify.com/factden/google-hotels-scraper?fpr=factden) ([docs](https://github.com/factden/google-hotels-scraper))
- [Expedia Hotel Reviews Scraper](https://apify.com/factden/expedia-hotel-reviews-scraper?fpr=factden) ([docs](https://github.com/factden/expedia-hotel-reviews-scraper))
- [Hotels.com Reviews Scraper](https://apify.com/factden/hotels-com-reviews-scraper?fpr=factden) ([docs](https://github.com/factden/hotels-com-reviews-scraper))
- [G2 Reviews Scraper](https://apify.com/factden/g2-reviews-scraper?fpr=factden) ([docs](https://github.com/factden/g2-reviews-scraper))

- [Airbnb Data Scraper](https://apify.com/factden/airbnb-data-scraper?fpr=factden) ([docs](https://github.com/factden/airbnb-data-scraper)) - Airbnb listings, prices, availability, occupancy, ADR/RevPAR & reviews; a pay-per-use AirDNA alternative.
- [Agoda Hotel Reviews Scraper](https://apify.com/factden/agoda-hotel-reviews-scraper?fpr=factden) ([docs](https://github.com/factden/agoda-hotel-reviews-scraper))
[All FactDen actors →](https://apify.com/factden?fpr=factden)

## License

[MIT](LICENSE) © 2026 FactDen
