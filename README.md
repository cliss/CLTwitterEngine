CLTwitterEngine
===============

A simple, ARC and blocks-based Twitter engine for Cocoa and CocoaTouch.  Currently, it is assumed that all picture uploads will be performed using Twitter's image upload service.

Basics
======

`CLTwitterEngine` is designed with the following tenets:

* Calls to and from Twitter should be asynchronous.
* Callbacks will favor blocks, rather than protocols and delegates.
* Clients of the library should be able to provide their own means of signing requests with OAuth information.
* Clients of the library should be able to provide a JSON parser of their choice.  This is to allow use on older versions of Mac OS X and iOS, which do not have [NSJSONSerialization][JSON].
* Objects should know how to get or post themselves, whenever possible.  For example, the `CLTweet` class is capable of getting a tweet or posting one. 
* The API should be as simple as possible.

Requirements
============
Requires [GTMHttpFetcher][fetcher].

Initialization
==============

To initialize: 

* You must specify a way to convert JSON data to Foundation objects; the assumed way of doing so is using [NSJSONSerialization][JSON], though presumably any framework will do.
* You must specify a way to add OAuth authorization to a `NSMutableURLRequest`.  `CLTwitterEngine` was written to work with [GTMOauthAuthentication][OAuth], though again, any framework should work.

Example:
    
    [[CLTwitterEngine sharedEngine] setAuthorizer:^(NSMutableURLRequest *request)
    {
        // Your authorizing code here
    }];
    [[CLTwitterEngine sharedEngine] setConverter:^(NSData *data)
    {
        // Your code here
    }];
    
Note that because you are providing `CLTwitterEngine` with simply a block of code that will sign OAuth requests, to sign into Twitter using OAuth is entirely your responsibility.
    
Use
===
    
Subsequent to initialization above, the engine is ready to use.  You can get the timeline by:

    [[CLTwitterEngine sharedEngine] getTimeLineWithCompletionHandler:^(NSArray *timeline, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        else
        {
            // The timeline is ready for use.  It is a NSArray of CLTweet objects.
        }
    }];
    
You can post a text-only tweet:

    [CLTweet postTweet:@"Look at me; I'm tweeting!" completionHandler:^(CLTweet *tweet, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        else
        {
            // Your tweet has been posted; the result is provided for convenience.
        }
    }];
    
You can post a tweet with an image:

    [CLTweet postTweet:@"This is yet another test upload." withImage:image completionHandler:^(CLTweet *tweet, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        else
        {
            // The tweet and image have been posted; the result is provided for convenience.
        }
    }];
    
You can get recent direct messages (both sent and received are in this same array):

    [[CLTwitterEngine sharedEngine] getRecentDirectMessagesWithCompletionHandler:^(NSArray *messages, NSError *innerError) {
        if (innerError != nil)
        {
            // Hanlde the error.
        }
        else
        {
            // The direct messages (sent and received) are ready for use.
            // It is a NSArray of CLDirectMessage objects.
        }
    }];
    
Or perhaps just an individual direct message:

    [CLDirectMessage getDirectMessageWithId:[NSNumber numberWithLongLong:123456789012341234] 
                          completionHandler:^(CLDirectMessage *message, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        else
        {
            // The direct messages is provided.
        }
    }];

You can get a user by handle/screen name:

    [CLTwitterUser getUserWithScreenName:@"SedgeApp" completionHandler:^(CLTwitterUser *user, NSError *error) {
        if (error != nil)
        {
            // Handle error.
        }
        else
        {
            // The user is provided.
        }
    }
    
...or by ID:

    [CLTwitterUser getUserWithId:[NSNumber numberWithLongLong:123456789012341234 completionHandler:^(CLTwitterUser *user, NSError *error) {
                if (error != nil)
                {
                    // Handle error.
                }
                else
                {
                    // The user is provided.
                }
    }];




[fetcher]: http://code.google.com/p/gtm-http-fetcher/
[JSON]: https://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html
[OAuth]: http://code.google.com/p/gtm-oauth/