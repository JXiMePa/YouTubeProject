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
    private let topBarHight: CGFloat = 45.0
    
    private let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private lazy var settingsLauncher: SettingsLauncher = {
        let lancher = SettingsLauncher()
        lancher.homeController = self
        // Strong reference to HomeController ???
        return lancher
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
        ApiService.sharedInstance.fetchVideos { [unowned self] (videos: [Video]) in
            self.videos = videos
            self.collectionView?.reloadData()
        }  
    }
    
    private func setupNavBarButtons() {
        let searchImage = #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [ moreBarButtonItem, searchBarButtonItem]
 
    }

    func showControllerForSetting(setting: Setting) {
        
        let blanckSettingsViewController = UIViewController()
        blanckSettingsViewController.navigationItem.title = setting.name.rawValue
        blanckSettingsViewController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // navigationBarItems Color Color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) ]
        
        navigationController?.pushViewController(blanckSettingsViewController, animated: true)
    }
    
    @objc private func handleSearch() {
        print("handleSearch()")
    }
    
    @objc private func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true // swipeToHide
        
        let redView: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
           return view
        }()
        
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        _ = redView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topBarHight)
        
        ///.safeAreaLayoutGuide !
       _ = menuBar.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topBarHight)
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
