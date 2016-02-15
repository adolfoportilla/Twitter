//
//  TwitterClient.swift
//  Twitter
//
//  Created by adolfo portilla on 2/14/16.
//  Copyright © 2016 Adolfo Portilla. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "lGq9JlTSma98u8xLoZg8PR04P"
let twitterConsumerSecret = "JZzBdBE9hxVDQYk3NTfniz5qD0mJWV07GYn7GTRIJKeYWRnbTl"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

}
