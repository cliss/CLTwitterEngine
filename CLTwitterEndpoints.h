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
#define CLTWITTER_POST_TWEET_WITH_MEDIA_ENDPOINT @"https://upload.twitter.com/1/statuses/update_with_media.json"

#pragma mark -
#pragma mark Direct Messages
#define CLTWITTER_GET_DIRECT_MESSAGES_RECEIVED_ENDPOINT @"https://api.twitter.com/1/direct_messages.json?include_entities=true"
#define CLTWITTER_GET_DIRECT_MESSAGES_SENT_ENDPOINT @"https://api.twitter.com/1/direct_messages/sent.json?include_entities=true"
#define CLTWITTER_GET_DIRECT_MESSAGE_BY_ID_ENDPOINT_FORMAT @"https://api.twitter.com/1/direct_messages/show/%@.json?include_entities=true"

#pragma mark -
#pragma mark Users
#define CLTWITTER_GET_FOLLOWERS_ENDPOINT_FORMAT @"https://api.twitter.com/1/followers/ids.json?cursor=%@&screen_name=%@"
#define CLTWITTER_GET_FOLLOWING_ENDPOINT_FORMAT @"https://api.twitter.com/1/friends/ids.json?cursor=%@&screen_name=%@"
#define CLTWITTER_GET_USER_BY_SCREEN_NAME_ENDPOINT_FORMAT @"http://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true"
#define CLTWITTER_GET_USER_BY_ID_ENDPOINT_FORMAT @"http://api.twitter.com/1/users/show.json?user_id=%@&include_entities=true"
#define CLTWITTER_GET_USERS_BY_IDS_ENDPOINT_FORMAT @"https://api.twitter.com/1/users/lookup.json?user_id=%@&include_entities=true"

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

#pragma mark -
#pragma mark Tweet Marker
#define CLTWEETMARKER_GET_LAST_READ_FORMAT @"https://api.tweetmarker.net/v1/lastread?username=%@&collection=%@&api_key=%@"
#define CLTWEETMARKER_MARK_LAST_READ_FORMAT CLTWEETMARKER_GET_LAST_READ_FORMAT