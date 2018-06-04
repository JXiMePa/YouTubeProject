//
//  MenuBar.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 28.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class MenuBar: UIView {
    
    private let imageToBarItem = [#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "trending"), #imageLiteral(resourceName: "subscriptions"), #imageLiteral(resourceName: "account")]
    private let cellId = "cellId"
    
    var homeController: HomeController?
    
     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: collectionView)
        
        //first select Item in collectionView
        let selectedIndexPatch = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPatch, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    private func setupHorizontalBar() {
        
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBar)
        
        horizontalBarLeftAnchorConstraint = horizontalBar.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = imageToBarItem[indexPath.item].withRenderingMode(.alwaysTemplate)
        cell.tintColor = #colorLiteral(red: 0.1525913481, green: 0.09426488235, blue: 0.09442671263, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
//        
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            //create animate time = 0.75, and update layout
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
}




