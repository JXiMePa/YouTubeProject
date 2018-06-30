//
//  CollectionViewCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 02.06.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    
    private let videoCellId = "VideoCell"

    var videos: [Video]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //Vertical cv
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cv
    }()
    
    override func setupViews() {

        fetchVideos()
        
        addSubview(collectionView)
        
       _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 45, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
    }
    
    func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { [unowned self] (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}

extension FeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLanucer = VideoLauncher()
        videoLanucer.showVideoPlayer()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16 // 16/9 - screen
        let allSpacesBetweenItems: CGFloat = 16 + 8 + 36 + 45
        
        return CGSize(width: frame.width, height: height + allSpacesBetweenItems)
    }
}





