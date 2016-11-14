//
//  TrendingCell.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/11/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    // Fetch Data from the JSON Link and set the Data
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed(completion: { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        })
    }

}
