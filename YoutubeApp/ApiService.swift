//
//  ApiService.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/11/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    // Fetch Data from the JSON Link and set the Data
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    if let unwrapped = data, let parsedData = try JSONSerialization.jsonObject(with: unwrapped, options: .mutableContainers) as? [[String: AnyObject]] {
                        var videos = [Video]()
                        
                        // Print Title
                        for dictionary in parsedData {
                            let video = Video()
                            video.setValuesForKeys(dictionary)
                            
                            let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                            
                            let channel = Channel()
                            channel.setValuesForKeys(channelDictionary)
                            
                            video.channel = channel
                            
                            
                            videos.append(video)
                        }
                        
                        
                        // This will wait to finish
                        DispatchQueue.main.sync(execute: {
                            // Update the UI on the main thread.
                            completion(videos)
                        })
                    } else {
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    
                    print(error)
                }
            }
            
            }.resume()
    }

}


//    var videos: [Video] = {
//        var taylorChannel = Channel()
//        taylorChannel.name = "TaylorSwiftVEVO"
//        taylorChannel.profileImageName = "taylor_swift.jpg"
//
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeWestVEVO"
//        kanyeChannel.profileImageName = "kanye_west.jpg"
//
//        // Video 1
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumbNailImageName = "taylor_swift_blank_space.png"
//        blankSpaceVideo.channel = taylorChannel
//        blankSpaceVideo.numberOfViews = 1836102846
//
//        // Video 2
//        var badBloodVideo = Video()
//        badBloodVideo.title = "Taylor Swift - Bad Blood ft. Kendrick Lamar (Explicit)"
//        badBloodVideo.thumbNailImageName = "taylor_swift_bad_blood.png"
//        badBloodVideo.channel = taylorChannel
//        badBloodVideo.numberOfViews = 975358226
//
//        // Video 3
//        var fadeVideo = Video()
//        fadeVideo.title = "Kanye West - Fade (Explicit)"
//        fadeVideo.thumbNailImageName = "kanye_west_fade.png"
//        fadeVideo.channel = kanyeChannel
//        fadeVideo.numberOfViews = 43985609
//
//
//        return [blankSpaceVideo, badBloodVideo, fadeVideo]
//    }()

