//
//  ViewController.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 27.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class HomeController: UICollectionViewController {

    private var videos: [Video]?
    
    private let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false //полупрозрачной(true)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.titleView = titleLabel
        
        
        collectionView?.backgroundColor = .white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        //UIEdgeInsetsMake: Вставка - маржа вокруг прямоугольника
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    private func fetchVideos() {
        
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        
        URLSession.shared.dataTask(with: url!) { [unowned self] (data, response , error) in
            guard error == nil else { print(error!); return }
            
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    self.videos = [Video]()
                    
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
                        self.videos?.append(video)
                    }
                    
                    DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                    
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
    }
    
    private func setupNavBarButtons() {
        let searchImage = #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [ moreBarButtonItem, searchBarButtonItem]
        
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @objc private func handleSearch() {
        print("handleSearch")
    }
    
    @objc private func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithVisualFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithVisualFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
}//end

// MARK: UICollectionViewController, UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16 // 16/9 - screen
        return CGSize(width: view.frame.width, height: height + 16 + 8 + 36 + 44)
    }
}

///Fake video

//    var videos: [Video] = {
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeVEVO"
//        kanyeChannel.profileImageName = "kanye_image_profile"
//
//       var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumbnailImageName = "teilorSwift"
//        blankSpaceVideo.channel = kanyeChannel
//        blankSpaceVideo.numberOfViews = 1_604_684_607
//
//        var bedBloodVideo = Video()
//        bedBloodVideo.title = "Taylor Swift - Bed Blood featuring Kendring"
//        bedBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
//        bedBloodVideo.channel = kanyeChannel
//        bedBloodVideo.numberOfViews = 2_604_684_607
//
//        return [blankSpaceVideo, bedBloodVideo]
//    }()
