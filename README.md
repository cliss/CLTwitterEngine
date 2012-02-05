CLTwitterEngine
===============

A simple, ARC and blocks-based Twitter engine for Cocoa and CocoaTouch.

Requirements
============
Requires [GTMHttpFetcher][fetcher].

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

