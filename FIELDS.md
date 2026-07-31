# Field reference

The actor writes to two datasets. **Reviews** is the default dataset, one row per review. **Places** (the
`properties` dataset) holds one record per place, always emitted alongside reviews in Reviews mode, and the sole
output in Discover mode.

Every row also carries a `markdownContent` field: a compact, LLM-ready Markdown rendering of that record, listed
last in each table below.

## Reviews dataset

One row per TripAdvisor review.

| Field | Type | Description |
|---|---|---|
| `placeId` | integer | TripAdvisor location ID of the place the review belongs to (e.g. `1465497`). |
| `placeType` | string | Place category key: `hotel`, `restaurant` or `attraction`. |
| `placeName` | string \| null | Name of the place. |
| `placeLocationString` | string \| null | Human-readable place location, e.g. `Barcelona, Catalonia`. |
| `reviewId` | string | Unique TripAdvisor review ID. |
| `url` | string \| null | Direct link to the review on TripAdvisor. |
| `lang` | string \| null | Two-letter language code of the review text (e.g. `en`, `es`). |
| `isMachineTranslated` | boolean | `true` if the text shown is a machine translation. |
| `title` | string \| null | Review title / headline. |
| `text` | string \| null | Full review body. |
| `rating` | integer \| null | Star rating the reviewer gave, `1`-`5`. |
| `publishedDate` | string \| null | When the review was published (ISO 8601). |
| `travelDate` | string \| null | Month the reviewer stayed/visited, e.g. `2026-07`. |
| `publishedPlatform` | string \| null | Platform the review was posted from, e.g. `Desktop`, `Mobile`. |
| `helpfulVotes` | integer | Number of "helpful" votes the review received. |
| `subratings` | array of objects | Per-review category scores. Each item: `name` (string, e.g. `Rooms`, `Service`) and `value` (integer, `1`-`5`). Empty when the reviewer left none. |
| `ownerResponse` | object \| null | The management reply, if any: `responder` (string), `title` (string), `text` (string), `publishedDate` (string). |
| `user` | object \| null | Reviewer profile: `userId` (string), `memberId` (string), `username` (string), `name` (string), `userLocation` (string), `contributions` (integer, total reviews written), `avatar` (string, image URL), `reviewerType` (string). |
| `scrapedAt` | string | UTC timestamp when the actor collected this row (ISO 8601). |
| `markdownContent` | string | LLM-ready Markdown rendering of the review (title, stars, dates, text, subratings and owner response). |

## Places dataset

One record per place, full property details, always emitted (one billable record per place). Works for hotels,
restaurants and attractions; type-specific fields such as `amenities`, `cuisine` or `hours` populate only when
relevant.

| Field | Type | Description |
|---|---|---|
| `placeId` | integer | TripAdvisor location ID. |
| `placeType` | string | Place category key: `hotel`, `restaurant` or `attraction`. |
| `name` | string \| null | Place name. |
| `category` | string \| null | Display category label, e.g. `Hotel`. |
| `description` | string \| null | TripAdvisor's descriptive blurb for the place. |
| `rating` | number \| null | Overall average rating (e.g. `4.2`). |
| `numReviews` | integer \| null | Total number of reviews on TripAdvisor. |
| `ratingHistogram` | object \| null | Review counts by star: `count1` … `count5` (integers). |
| `rank` | integer \| null | The place's rank within its category/area (e.g. `309`). |
| `rankOutOf` | integer \| null | Total places in that ranking (e.g. `594`). |
| `rankCategory` | string \| null | Category the ranking is measured in, e.g. `hotels`. |
| `rankGeo` | string \| null | Area the ranking is measured in, e.g. `Barcelona`. |
| `priceRange` | string \| null | Nightly/price range, e.g. `$459 - $822`. |
| `priceLevel` | string \| null | Price tier symbol, e.g. `$$$$`. |
| `hotelClass` | number \| null | Star classification of the property (e.g. `5.0`). |
| `address` | string \| null | Full formatted address. |
| `addressObj` | object \| null | Structured address: `street1`, `street2`, `city`, `state`, `country`, `postalcode`. |
| `latitude` | number \| null | Latitude. |
| `longitude` | number \| null | Longitude. |
| `locationString` | string \| null | Human-readable location, e.g. `Barcelona, Catalonia`. |
| `amenities` | array of strings | Amenity names (hotels), e.g. `Spa`, `Swimming Pool`. |
| `cuisine` | array of strings | Cuisine types (restaurants). |
| `dietaryRestrictions` | array of strings | Dietary options (restaurants), e.g. `Vegetarian friendly`. |
| `establishmentTypes` | array of strings | Establishment types (restaurants/attractions). |
| `hours` | object \| null | Opening hours, when published. |
| `subratings` | object \| null | Official TripAdvisor category subratings: `cleanliness`, `service`, `value`, `location`, `rooms`, `sleepQuality` (numbers, `1`-`5`). |
| `reviewTags` | array of objects | Popular mentions / keywords. Each: `text` (string) and `reviewCount` (integer). |
| `roomTips` | array of objects | Traveller room tips. Each: `text` (string) and `rating` (integer). |
| `photos` | array of objects | Place photos. Each: `url` (string), `width` (integer), `height` (integer), `caption` (string). |
| `aiReviewSummary` | object \| null | TripAdvisor's AI review summary: `title` (string), `text` (string), and `chips` (array of `{ attribute, opinion }`). Best-effort. |
| `phone` | string \| null | Contact phone number. |
| `email` | string \| null | Contact email. |
| `website` | string \| null | The place's own website URL. |
| `webUrl` | string \| null | The place's TripAdvisor page URL. |
| `writeReviewUrl` | string \| null | The TripAdvisor "write a review" URL for the place. |
| `awards` | array of strings | TripAdvisor awards the place holds, e.g. `Travelers' Choice`. |
| `scrapedAt` | string | UTC timestamp when the actor collected this record (ISO 8601). |
| `markdownContent` | string | LLM-ready Markdown rendering of the place (name, rating, ranking, price, address, subratings, amenities, popular mentions, description). |
