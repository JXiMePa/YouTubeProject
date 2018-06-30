//
//  ViewController.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 27.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class HomeController: UICollectionViewController {
    
    private let topBarHight: CGFloat = 45.0
    private var hidesBarsOnSwipe = false
    
    private enum CellId: String {
        case feedCellId, trendingCellId, subscriptCellId, accountCellId
    }
    private enum Titels: String {
        case home, trending, subscriptions, account
    }
    private let titles: [Titels] = [.home, .trending, .subscriptions, .account]
    
    private lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self //Strong! reference
        return mb
    }()
    
    private lazy var settingsLauncher: SettingsLauncher = {
        let lancher = SettingsLauncher()
        lancher.homeController = self //Strong! reference
        return lancher
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavBar()
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    private func setupNavBar() {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                               width: view.frame.width - 32,
                                               height: view.frame.height))
        titleLabel.text = " Home"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        navigationItem.title = " Home"
        navigationController?.navigationBar.isTranslucent = false //полупрозрачной(true)
        navigationItem.titleView = titleLabel
    }
    
    private func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal //scroll orrientation
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: CellId.feedCellId.rawValue)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: CellId.trendingCellId.rawValue)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: CellId.subscriptCellId.rawValue)
        collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: CellId.accountCellId.rawValue)
        
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true // stop in One Cell
//      collectionView?.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
//      collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(45, 0, 0, 0)
        //UIEdgeInsetsMake: - маржа вокруг прямоугольника
    }
    
    private func setupNavBarButtons() {
        
        let searchBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        
        let moreBarButtonItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [ moreBarButtonItem, searchBarButtonItem]
    }
    
    func showControllerForSetting(setting: Setting) {
        
        let blanckSettingsViewController = UIViewController()
        blanckSettingsViewController.navigationItem.title = setting.name.rawValue
        blanckSettingsViewController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) ]
        
        navigationController?.pushViewController(blanckSettingsViewController, animated: true)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        setTitleForIndex(menuIndex)
    }
    
    fileprivate func setTitleForIndex(_ index: Int) {
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  " + "\(titles[index])".capitalized
        }
    }
    
    @objc private func handleSearch() {
        print("handleSearch()")
    }
    
    @objc private func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = hidesBarsOnSwipe //MARK: Bug!
        
        let redView = UIView()
            redView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        _ = redView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topBarHight)
        
        ///.safeAreaLayoutGuide !
        _ = menuBar.anchor(view.safeAreaLayoutGuide.topAnchor , left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topBarHight)
    }
}//end

//MARK: Horizontal CV |||
extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x / view.frame.width) //1,2,3,4
        ///targetContentOffset.pointee.x // - curent "x" value in scroll pozition
        
        let indexPath = IndexPath(item: index, section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition() ) //EndDragging  -> .selectItem
        
        setTitleForIndex(index)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier: String
        
        switch indexPath.item {
        case 1: identifier = CellId.trendingCellId.rawValue
        case 2: identifier = CellId.subscriptCellId.rawValue
        case 3: identifier = CellId.accountCellId.rawValue
        default: identifier = CellId.feedCellId.rawValue
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: view.frame.height)
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
