//
//  ApiServise.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 01.06.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class ApiService: NSObject {
static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForomUrlString("\(baseUrl)/home_num_likes.json", complition: completion)
    }
    
    func fetchTrendingFeed(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForomUrlString("\(baseUrl)/trending.json", complition: completion)
    }
    
    func fetchSubscriptionFeed(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForomUrlString("\(baseUrl)/subscriptions.json", complition: completion)
    }
    
    func fetchFeedForomUrlString(_ urlString: String, complition: @escaping ([Video]) -> ()) {
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response , error) in
        
        guard error == nil else { print(error!); return }
        
        do {
        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        
        var videos = [Video]()
        
        for dictionary in json as! [[String: AnyObject]] {
        
        let video = Video()
        video.title = dictionary["title"] as? String
        video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
        video.numberOfViews = dictionary["number_of_views"] as? NSNumber
        
        let channelDictionary = dictionary["channel"] as! [String: AnyObject]
        let channel = Channel()
        channel.name = channelDictionary["name"] as? String
        channel.profileImageName = channelDictionary["profile_image_name"] as? String
        
        video.channel = channel
        videos.append(video)
        }
        
        DispatchQueue.main.async {
        complition(videos)
        }
        
        } catch let jsonError {
        print(jsonError)
        }
        }.resume()
    }   
}
