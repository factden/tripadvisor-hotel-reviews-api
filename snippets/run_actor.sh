#!/usr/bin/env bash
#
# Run the TripAdvisor Hotel Reviews API actor with curl.
#
# Actor: https://apify.com/factden/tripadvisor-hotel-reviews-api
# Docs:  https://github.com/factden/tripadvisor-hotel-reviews-api
#
# Get your token at https://console.apify.com/account/integrations and export it:
#   export APIFY_TOKEN="apify_api_..."
#
# This starts the run and blocks until it finishes (waitForFinish=120s), then prints the run object.
# The run's "defaultDatasetId" holds the reviews; fetch it with the second call below.

set -euo pipefail

curl -s -X POST \
  "https://api.apify.com/v2/acts/factden~tripadvisor-hotel-reviews-api/runs?token=${APIFY_TOKEN}&waitForFinish=120" \
  -H 'Content-Type: application/json' \
  -d '{
    "startUrls": [
      { "url": "https://www.tripadvisor.com/Hotel_Review-g187497-d1465497-Reviews-W_Barcelona-Barcelona_Catalonia.html" }
    ],
    "maxReviews": 50,
    "reviewLanguages": ["all"],
    "minRating": 1,
    "maxRating": 5,
    "proxyConfiguration": { "useApifyProxy": true }
  }'

# Fetch the reviews once the run has finished (replace DATASET_ID with the run's defaultDatasetId):
#   curl -s "https://api.apify.com/v2/datasets/DATASET_ID/items?format=json&token=${APIFY_TOKEN}"
#
# Or run and download in one shot with the run-sync endpoint:
#   curl -s -X POST \
#     "https://api.apify.com/v2/acts/factden~tripadvisor-hotel-reviews-api/run-sync-get-dataset-items?token=${APIFY_TOKEN}" \
#     -H 'Content-Type: application/json' \
#     -d @../examples/input.json
