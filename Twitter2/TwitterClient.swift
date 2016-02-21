//
//  TwitterClient.swift
//  Twitter2
//
//  Created by adolfo portilla on 2/20/16.
//  Copyright © 2016 Adolfo Portilla. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "lGq9JlTSma98u8xLoZg8PR04P", consumerSecret: "JZzBdBE9hxVDQYk3NTfniz5qD0mJWV07GYn7GTRIJKeYWRnbTl")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login (success: ()->(), failure: (NSError)-> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter2://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            //print("I got a token!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
                
        }
    }
    
    func logout() {
        
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
    
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    
    
    func hometimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
    
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("account: \(response)")
            let userDictionary = response as? NSDictionary
            //print("name: \(user)")     //-> this is to print all the information (dictionary) of the user in twitter
            let user = User(dictionary: userDictionary!)
            
            
            success(user)
            
            //print("name: \(user.name)")
            //print("screenname: \(user.screenname)")
            //print("profile url  : \(user.profileUrl)")
            //print("description: \(user.tagline)")
            
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
                
        })
    
    }
    
    
    
    

}
