
#pragma mark Tweets
#define CLTWITTER_TWEET_TIMESTAMP @"created_at"
#define CLTWITTER_TWEET_IN_REPLY_TO_ID @"in_reply_to_status_id"
#define CLTWITTER_TWEET_USER @"user"
#define CLTWITTER_TWEET_BODY @"text"
#define CLTWITTER_TWEET_ID @"id"
#define CLTWITTER_TWEET_UPDATE_STATUS @"status"
#define CLTWITTER_TWEET_MEDIA_HASHTAGS @"hashtags"
#define CLTWITTER_TWEET_MEDIA_URLS @"urls"
#define CLTWITTER_TWEET_MEDIA_MENTIONS @"user_mentions"
#define CLTWITTER_TWEET_MEDIA_DISPLAY_URL @"display_url"
#define CLTWITTER_TWEET_MEDIA_URL_URL @"url"
#define CLTWITTER_TWEET_MEDIA @"entities"
#define CLTWITTER_TWEET_RETWEETED_TWEET @"retweeted_status"
#define CLTWITTER_TWEET_NEW_MEDIA @"media[]"

#pragma mark -
#pragma mark Users
#define CLTWITTER_USER_REAL_NAME @"name"
#define CLTWITTER_USER_SCREEN_NAME @"screen_name"
#define CLTWITTER_USER_PROFILE_IMAGE_URL @"profile_image_url_https"
#define CLTWITTER_USER_PROFILE_IS_VERIFIED @"verified"
#define CLTWITTER_USER_LOCATION @"location"
#define CLTWITTER_USER_PERSONAL_URL CLTWITTER_TWEET_MEDIA_URL_URL
#define CLTWITTER_USER_TWEET_COUNT @"statuses_count"
#define CLTWITTER_USER_LISTED_COUNT @"listed_count"
#define CLTWITTER_USER_FOLLOWERS_COUNT @"followers_count"
#define CLTWITTER_USER_FOLLWING_COUNT @"friends_count"
#define CLTWITTER_USER_LIST_IDS @"ids"
#define CLTWITTER_USER_NEXT_CURSOR @"next_cursor"

#pragma mark -
#pragma mark Direct Messages
#define CLTWITTER_DM_SENDER @"sender"
#define CLTWITTER_DM_RECIPIENT @"recipient"
#define CLTWITTER_DM_TIMESTAMP CLTWITTER_TWEET_TIMESTAMP
#define CLTWITTER_DM_TEXT CLTWITTER_TWEET_BODY
#define CLTWITTER_DM_ID CLTWITTER_TWEET_ID
#define CLTWITTER_DM_MEDIA CLTWITTER_TWEET_MEDIA

#pragma mark -
#pragma mark Search
#define CLTWITTER_SEARCH_ID CLTWITTER_TWEET_ID
#define CLTWITTER_SEARCH_NEXT_PAGE_QUERY_STRING @"next_page"
#define CLTWITTER_SEARCH_REFRESH_QUERY_STRING @"refresh_url"
#define CLTWITTER_SEARCH_RESULTS @"results"
#define CLTWITTER_SEARCH_TIMESTAMP CLTWITTER_TWEET_TIMESTAMP
#define CLTWITTER_SEARCH_POSITION @"position"
#define CLTWITTER_SEARCH_QUERY @"query"
#define CLTWITTER_SEARCH_NAME @"name"

#pragma mark -
#pragma mark Photo Size
#define CLTWITTER_PHOTO_SIZE_WIDTH @"w"
#define CLTWITTER_PHOTO_SIZE_HEIGHT @"h"
#define CLTWITTER_PHOTO_SIZE_RESIZE_KIND @"resize"

#pragma mark -
#pragma mark Miscellaneous
#define CLTWITTER_CONFIGURATION_MEDIA_SHORT_URL_LENGTH @"characters_reserved_per_media"
#define CLTWITTER_CONFIGURATION_NON_USERNAME_PATHS @"non_username_paths"
#define CLTWITTER_CONFIGURATION_MAX_MEDIA_PER_UPLOAD @"max_media_per_upload"
#define CLTWITTER_CONFIGURATION_PHOTO_SIZE_LIMIT @"photo_size_limit"
#define CLTWITTER_CONFIGURATION_PHOTO_SIZES @"photo_sizes"
#define CLTWITTER_CONFIGURATION_INSECURE_SHORT_URL_LENGTH @"short_url_length"
#define CLTWITTER_CONFIGURATION_SECURE_SHORT_URL_LENGTH @"short_url_length_https"