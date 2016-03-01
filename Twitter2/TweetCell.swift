//
//  TweetCell.swift
//  Twitter2
//
//  Created by adolfo portilla on 2/20/16.
//  Copyright © 2016 Adolfo Portilla. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UITextField!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            imageProfile.setImageWithURL((tweet.user?.profileUrl!)!)
            usernameLabel.text = tweet.user!.name
            
            tweetLabel.text = tweet.text
            
            userLabel.text = "@\(tweet.user!.screenname!)"
            //idLabel.text = "@\(tweet.user!.screenname!)"
            
            retweetLabel.text = String(tweet.retweetCount)
            favoriteLabel.text = String(tweet.likeCount)
            likeButton.imageView!.image = UIImage(named: "likeIcon")
            retweetButton.imageView!.image = UIImage(named: "retweetIcon")
        
            timeLabel.text = "\(tweet.timestamp)"
            timeLabel.text = convertTimeToString(Int(NSDate().timeIntervalSinceDate(tweet.timestamp!)))
        }
    }
    
    func convertTimeToString(number: Int) -> String{
        let day = number/86400
        let hour = (number - day * 86400)/3600
        let minute = (number - day * 86400 - hour * 3600)/60
        if day != 0{
            return String(day) + "d"
        } else if hour != 0 {
            return String(hour) + "h"
        } else {
            return String(minute) + "m"
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
    
    @IBAction func retweet(sender: AnyObject) {
        if (tweet.isRetweeted == false) {
            TwitterClient.sharedInstance.retweet(String(tweet.id!))
            retweetLabel.text = String(tweet.retweetCount + 1)
            tweet.isRetweeted = true
            
        } else {
            TwitterClient.sharedInstance.unretweet(String(tweet.id!))
            retweetLabel.text = String(tweet.retweetCount)
            tweet.isRetweeted = false
            
        }
    }
    
    @IBAction func like(sender: AnyObject) {
        if (tweet.isLiked == false) {
            TwitterClient.sharedInstance.like(tweet.id!)
            favoriteLabel.text = String(tweet.likeCount + 1)
            tweet.isLiked = true
        } else {
            TwitterClient.sharedInstance.unlike(tweet.id!)
            favoriteLabel.text = String(tweet.likeCount)
            tweet.isLiked = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
