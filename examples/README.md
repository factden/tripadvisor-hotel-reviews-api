# Examples

Sample input and output for the **TripAdvisor Hotel Reviews API** actor. All output samples are built from a real
run against **W Barcelona** (place ID `1465497`) and show the exact shape you get back.

| File | What it is |
|---|---|
| `input.json` | A ready-to-run input: one hotel URL with `maxReviews` 50 (Reviews mode; each place also yields a property record). Paste it into the actor's **Input** tab (JSON editor) or pass it to the API. |
| `reviews.sample.json` | Three review objects from the **reviews** dataset (the default output), one plain 5-star review, one with per-review subratings, and one 2-star review with an owner response. |
| `places.sample.json` | One record from the **properties** dataset ("Places"), full property details including the official category subratings, ranking, price range, amenities, room tips, popular mentions and the AI review summary. |
| `reviews-sample.csv` | The same reviews exported as CSV (a subset of columns), showing what a spreadsheet export looks like. |

The **reviews** dataset holds one row per review; the **properties** dataset holds one record per place (always
emitted). You can download either dataset from the Apify Console or API as JSON, CSV, Excel, HTML or RSS.

Each row also carries a `markdownContent` field, a compact, LLM-ready Markdown rendering of that review or place -
so you can feed the output straight into a RAG pipeline or summarizer.
