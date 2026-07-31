"""
Run the TripAdvisor Hotel Reviews API actor from Python.

Actor: https://apify.com/factden/tripadvisor-hotel-reviews-api
Docs:  https://github.com/factden/tripadvisor-hotel-reviews-api

Install the client:  pip install apify-client
Then set your token: export APIFY_TOKEN="apify_api_..."   (https://console.apify.com/account/integrations)
"""

import os

from apify_client import ApifyClient

client = ApifyClient(os.environ["APIFY_TOKEN"])

run_input = {
    "startUrls": [
        {"url": "https://www.tripadvisor.com/Hotel_Review-g187497-d1465497-Reviews-W_Barcelona-Barcelona_Catalonia.html"}
    ],
    "maxReviews": 50,
    "reviewLanguages": ["all"],
    "minRating": 1,
    "maxRating": 5,
    "includePropertyDetails": True,
    "proxyConfiguration": {"useApifyProxy": True},
}

# Start the run and wait for it to finish.
run = client.actor("factden/tripadvisor-hotel-reviews-api").call(run_input=run_input)

# The default dataset holds one row per review.
for review in client.dataset(run["defaultDatasetId"]).iterate_items():
    print(review["rating"], review["title"], "-", review["placeName"])

# Property details land in the named "properties" dataset.
# See run["...] / the Console "Storage" tab to fetch that dataset by name if you need it.
