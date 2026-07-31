/**
 * Run the TripAdvisor Hotel Reviews API actor from Node.js.
 *
 * Actor: https://apify.com/factden/tripadvisor-hotel-reviews-api
 * Docs:  https://github.com/factden/tripadvisor-hotel-reviews-api
 *
 * Install the client:  npm install apify-client
 * Then set your token: export APIFY_TOKEN="apify_api_..."   (https://console.apify.com/account/integrations)
 */

import { ApifyClient } from 'apify-client';

const client = new ApifyClient({ token: process.env.APIFY_TOKEN });

const input = {
    startUrls: [
        { url: 'https://www.tripadvisor.com/Hotel_Review-g187497-d1465497-Reviews-W_Barcelona-Barcelona_Catalonia.html' },
    ],
    maxReviews: 50,
    reviewLanguages: ['all'],
    minRating: 1,
    maxRating: 5,
    includePropertyDetails: true,
    proxyConfiguration: { useApifyProxy: true },
};

// Start the run and wait for it to finish.
const run = await client.actor('factden/tripadvisor-hotel-reviews-api').call(input);

// The default dataset holds one row per review.
const { items } = await client.dataset(run.defaultDatasetId).listItems();
for (const review of items) {
    console.log(review.rating, review.title, '-', review.placeName);
}
