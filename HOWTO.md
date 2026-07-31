# How to scrape TripAdvisor reviews — step by step

A six-step walkthrough from picking places to running the actor on a schedule and calling it from code. It works
the same for **hotels**, **restaurants** and **attractions**.

## 1. Choose what to scrape (URLs, IDs or a search)

There are three ways to target places — use any one, or mix them:

- **Paste TripAdvisor URLs** into **🔗 TripAdvisor URLs** (`startUrls`). Copy the detail-page URL straight from
  your browser, e.g.
  `https://www.tripadvisor.com/Hotel_Review-g187497-d1465497-Reviews-W_Barcelona-Barcelona_Catalonia.html`.
  `Hotel_Review`, `Restaurant_Review` and `Attraction_Review` URLs all work. A stale or merged URL still
  works — the actor follows the merge to the current place automatically.
- **Enter Location IDs** in **🆔 …or Location IDs** (`locationIds`) — the `d`-number from a URL (e.g. `1465497`
  from `…-d1465497-…`), one per line.
- **Search a city or place name** in **🔍 …or search a city / place** (`searchTerms`), e.g. `Barcelona`. Pick the
  **place types** to include (`placeTypes`: hotels / restaurants / attractions) and cap how many per term with
  **max places per term** (`maxPlaces`).

You need at least one of these three.

## 2. Set your review filters

Narrow down which reviews you keep:

- **Max reviews per place** (`maxReviews`) — cap per place, newest-first. Use a large number (e.g. `100000`) to
  get *all* reviews; keep it small (e.g. `50`) for a fast, cheap first run.
- **Review languages** (`reviewLanguages`) — `All languages`, or specific ones like English/Spanish.
- **Minimum / maximum rating** (`minRating` / `maxRating`, `1`–`5`) — set both to the same value for a single
  band (e.g. both `1` for complaint analysis).
- **Reviews from / to** (`fromDate` / `toDate`, `YYYY-MM-DD`) — pull a specific window, or set only **from** so a
  recurring run grabs just what's new since last time.
- **Also get property details** (`includePropertyDetails`, on by default) — emits one extra **property record**
  per place with ranking, price range, amenities, official category subratings and the AI review summary. Turn
  it off for reviews only.

## 3. Run it

Open the actor's **Input** tab, fill in the fields above (or paste
[`examples/input.json`](examples/input.json) into the JSON editor), and click **Start**. The run streams rows
into the datasets as it goes — you can watch them arrive in the **Output** tab.

## 4. Export the data

When the run finishes, open the **Output** / **Storage** tab:

- **Reviews** live in the default dataset (one row per review).
- **Places** live in the `properties` dataset (one record per place), when property details are on.

Download either dataset as **JSON, CSV, Excel, HTML or RSS**, or pull it via the API (see step 6). Each row also
has a `markdownContent` field — a ready-to-ingest Markdown version for LLM/RAG pipelines. See
[`examples/`](examples/) for what the output looks like and [`FIELDS.md`](FIELDS.md) for every field.

## 5. Schedule recurring runs

To keep a dataset fresh, add a **Schedule** in the Apify Console (e.g. daily or weekly) and attach this actor
with your saved input. Pair a rolling **Reviews from** date (`fromDate`) with a high `maxReviews` so each run only
pulls reviews newer than your window — an efficient incremental refresh. You can also wire run-finished
notifications or webhooks to push new data into your own systems.

## 6. Run it from the API or an AI agent

Call the actor programmatically with the Apify API or a client library — see the ready-to-run snippets in
[`snippets/`](snippets/): [`run_actor.py`](snippets/run_actor.py) (Python, `apify-client`),
[`run_actor.js`](snippets/run_actor.js) (Node.js, `apify-client`) and [`run_actor.sh`](snippets/run_actor.sh)
(curl). Because it takes plain JSON input and returns structured JSON, it also plugs into AI agents and MCP-based
tool use for on-demand review retrieval.
