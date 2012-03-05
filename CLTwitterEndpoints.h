//
//  CLTwitterEndpoints.h
//  Sedge
//
//  Created by Casey Liss on 6/2/12.
//  Copyright (c) 2012 Casey Liss. All rights reserved.
//

#pragma mark Tweets
#define CLTWITTER_DELETE_TWEET_ENDPOINT_FORMAT @"http://api.twitter.com/1/statuses/destroy/%@.json"
#define CLTWITTER_GET_TWEET_BY_ID_ENDPOINT_FORMAT @"https://api.twitter.com/1/statuses/show.json?id=%@&include_entities=true"
#define CLTWITTER_POST_TWEET_ENDPOINT @"http://api.twitter.com/1/statuses/update.json"
#define CLTWITTER_GET_TIMELINE_ENDPOINT @"http://api.twitter.com/1/statuses/home_timeline.json"
#define CLTWITTER_GET_MENTIONS_ENDPOINT @"https://api.twitter.com/1/statuses/mentions.json?include_entities=true"
#define CLTWITTER_GET_RETWEETS_OF_ME_ENDPOINT @"https://api.twitter.com/1/statuses/retweets_of_me.json?include_entities=true"
#define CLTWITTER_POST_TWEET_WITH_MEDIA_ENDPOINT @"https://upload.twitter.com/1/statuses/update_with_media.json"
#define CLTWITTER_GET_USER_TIMELINE_ENDPOINT_FORMAT @"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=%@"
#define CLTWITTER_POST_RETWEET_ENDPOINT_FORMAT @"https://api.twitter.com/1/statuses/retweet/%@.json"
#define CLTWITTER_GET_RETWEETERS_OF_TWEET_ENDPOINT_FORMAT @"https://api.twitter.com/1/statuses/%@/retweeted_by.json"
#define CLTWITTER_GET_RETWEETS_OF_TWEET_ENDPOINT_FORMAT @"https://api.twitter.com/1/statuses/retweets/21947795900469248.json?include_entities=true"
#define CLTWITTER_POST_NEW_FAVORITE_ENDPOINT_FORMAT @"https://api.twitter.com/1/favorites/create/%@.json?include_entities=true"
#define CLTWITTER_POST_REMOVE_FAVORITE_ENDPOINT_FORMAT @"https://api.twitter.com/1/favorites/destroy/%@.json"

#pragma mark -
#pragma mark Direct Messages
#define CLTWITTER_GET_DIRECT_MESSAGES_RECEIVED_ENDPOINT @"https://api.twitter.com/1/direct_messages.json?include_entities=true"
#define CLTWITTER_GET_DIRECT_MESSAGES_SENT_ENDPOINT @"https://api.twitter.com/1/direct_messages/sent.json?include_entities=true"
#define CLTWITTER_GET_DIRECT_MESSAGE_BY_ID_ENDPOINT_FORMAT @"https://api.twitter.com/1/direct_messages/show/%@.json?include_entities=true"
#define CLTWITTER_POST_DELETE_DIRECT_MESSAGE_ENDPOINT_FORMAT @"https://api.twitter.com/1/direct_messages/destroy/%@.json"
#define CLTWITTER_POST_DIRECT_MESSAGE_ENDPOINT @"https://api.twitter.com/1/direct_messages/new.json"

#pragma mark -
#pragma mark Users
#define CLTWITTER_GET_FOLLOWERS_ENDPOINT_FORMAT @"https://api.twitter.com/1/followers/ids.json?cursor=%@&screen_name=%@"
#define CLTWITTER_GET_FOLLOWING_ENDPOINT_FORMAT @"https://api.twitter.com/1/friends/ids.json?cursor=%@&screen_name=%@"
#define CLTWITTER_GET_USER_BY_SCREEN_NAME_ENDPOINT_FORMAT @"http://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true"
#define CLTWITTER_GET_USER_BY_ID_ENDPOINT_FORMAT @"http://api.twitter.com/1/users/show.json?user_id=%@&include_entities=true"
#define CLTWITTER_GET_USERS_BY_IDS_ENDPOINT_FORMAT @"https://api.twitter.com/1/users/lookup.json?user_id=%@&include_entities=true"
#define CLTWITTER_GET_PENDING_FOLLOW_REQUESTS_OF_ME_ENDPOINT @"https://api.twitter.com/1/friendships/incoming.json"
#define CLTWITTER_GET_MY_PENDING_FOLLOW_REQUESTS_ENDPOINT @"https://api.twitter.com/1/friendships/outgoing.json"
#define CLTWITTER_POST_START_FOLLOWING_USER_ENDPOINT @"https://api.twitter.com/1/friendships/create.json"
#define CLTWITTER_POST_STOP_FOLLOWING_USER_ENDPOINT @"http://api.twitter.com/1/friendships/destroy.json"
#define CLTWITTER_GET_USER_PROFILE_IMAGE_ENDPOINT_FORMAT @"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=%@"
#define CLTWITTER_GET_USER_SEARCH_RESULTS_ENDPOINT_FORMAT @"https://api.twitter.com/1/users/search.json?q=%@&page=%@"
#define CLTWITTER_GET_USER_FAVORITES_ENDPOINT_FORMAT @"https://api.twitter.com/1/favorites/%@.json?page=%@"
#define CLTWITTER_GET_MY_FAVORITES_ENDPOINT_FORMAT @"https://api.twitter.com/1/favorites.json?page=%@"
#define CLTWITTER_POST_REPORT_SPAM_ENDPOINT_FORMAT @"http://api.twitter.com/1/report_spam.json?screen_name=%@"
#define CLTWITTER_GET_BLOCKED_USER_IDS_ENDPOINT @"https://api.twitter.com/1/blocks/blocking/ids.json"
#define CLTWITTER_POST_BLOCK_USER_ENDPOINT @"https://api.twitter.com/1/blocks/create.json"
#define CLTWITTER_GET_IS_USER_BLOCKED_ENDPOINT_FORMAT @"https://api.twitter.com/1/blocks/exists.json?screen_name=%@"
#define CLTWITTER_DELETE_BLOCK_USER_ENDPOINT_FORMAT @"https://api.twitter.com/1/blocks/destroy.json?screen_name=%@&include_entities=true"
#define CLTWITTER_GET_USER_TOTALS_ENDPOINT @"https://api.twitter.com/1/account/totals.json"

#pragma mark -
#pragma mark Lists
#define CLTWITTER_GET_ALL_LISTS_ENDPOINT @"https://api.twitter.com/1/lists/all.json"
#define CLTWITTER_GET_USER_LISTS_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/all.json?screen_name=%@"
#define CLTWITTER_GET_LIST_TIMELINE_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/statuses.json?list_id=%@&page=%ul&per_page=%ul&include_entities=true"
#define CLTWITTER_GET_LIST_BY_ID_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/show.json?list_id=%@"
#define CLTWITTER_GET_LIST_MEMBERS_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/members.json?list_id=%@&cursor=-1"
#define CLTWITTER_POST_LIST_SUBSCRIBE_ENDPOINT @"https://api.twitter.com/1/lists/subscribers/create.json"
#define CLTWITTER_POST_LIST_UNSUBSCRIBE_ENDPOINT @"https://api.twitter.com/1/lists/subscribers/destroy.json"
#define CLTWITTER_GET_LIST_SUBSCRIBERS_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/subscribers.json?include_entities=true&skip_status=true&list_id=%@"
#define CLTWITTER_POST_LIST_CREATE_ENDPOINT @"https://api.twitter.com/1/lists/create.json"
#define CLTWITTER_POST_LIST_UPDATE_ENDPOINT @"https://api.twitter.com/1/lists/update.json"
#define CLTWITTER_POST_LIST_REMOVE_ENDPOINT @"https://api.twitter.com/1/lists/destroy.json"
#define CLTWITTER_POST_LIST_ADD_MEMBER_ENDPOINT @"https://api.twitter.com/1/lists/members/create.json"
#define CLTWITTER_POST_LIST_REMOVE_MEMBER_ENDPOINT @"https://api.twitter.com/1/lists/members/destroy.json"
#define CLTWITTER_GET_LIST_SUBSCRIBED_TO_BY_USER_ENDPOINT_FORMAT @"https://api.twitter.com/1/lists/subscriptions.json?screen_name=%@&cursor=%@&count=%@"

#pragma mark -
#pragma mark Search
#define CLTWITTER_GET_SEARCH_BASE_ENDPOINT @"http://search.twitter.com/search.json"
#define CLTWITTER_GET_SEARCH_ENDPOINT_FORMAT @"%@?q=%@&include_entities=true&result_type=recent&rpp=100"
#define CLTWITTER_GET_SAVED_SEARCHES_ENDPOINT @"https://api.twitter.com/1/saved_searches.json"
#define CLTWITTER_GET_SAVED_SEARCH_ENDPOINT_FORMAT @"https://api.twitter.com/1/saved_searches/show/%@.json"
#define CLTWITTER_DELETE_SEARCH_ENDPOINT_FORMAT @"https://api.twitter.com/1/saved_searches/destroy/%@.json"
#define CLTWITTER_CREATE_SAVED_SEARCH_ENDPOINT @"https://api.twitter.com/1/saved_searches/create.json"

#pragma mark -
#pragma mark General
#define CLTWITTER_VERIFY_CREDENTIALS @"https://api.twitter.com/1/account/verify_credentials.json"
#define CLTWITTER_GET_CONFIGURATION @"https://api.twitter.com/1/help/configuration.json"
#define CLTWITTER_GET_RATE_LIMIT @"https://api.twitter.com/1/account/rate_limit_status.json"
#define CLTWITTER_POST_PROFILE_UPDATE_ENDPOINT @"https://api.twitter.com/1/account/update_profile.json"
#define CLTWITTER_POST_PROFILE_IMAGE_UPDATE_ENDPOINT @"http://api.twitter.com/1/account/update_profile_image.json"

#pragma mark -
#pragma mark Tweet Marker
#define CLTWEETMARKER_GET_LAST_READ_FORMAT @"https://api.tweetmarker.net/v1/lastread?username=%@&collection=%@&api_key=%@"
#define CLTWEETMARKER_MARK_LAST_READ_FORMAT CLTWEETMARKER_GET_LAST_READ_FORMAT