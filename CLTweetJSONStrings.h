
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