//
//  tweet.swift
//  Twitter2
//
//  Created by adolfo portilla on 2/20/16.
//  Copyright © 2016 Adolfo Portilla. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var timestamp: NSDate?
    var likeCount: Int = 0
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var isRetweeted: Bool?
    var isLiked: Bool?
    var id: String?
    
    
    
    init(dictionary:NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        likeCount = dictionary["favorite_count"] as? Int ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        isRetweeted = dictionary["retweeted"] as? Bool
        isLiked = dictionary["favorited"] as? Bool
        id = String(dictionary["id"]!)
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm::ss Z y"   //to get the date from the dictionary, it is weird how it is written
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }

}
