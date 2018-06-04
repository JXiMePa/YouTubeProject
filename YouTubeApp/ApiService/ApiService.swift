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
                guard let unwrappedData = data else { return }
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] else { return }

                let videos = jsonDictionary.map { return Video($0) } //[Video]()
                
                DispatchQueue.main.async {
                    complition(videos)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }   
}
