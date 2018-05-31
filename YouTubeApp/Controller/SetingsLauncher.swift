//
//  SetingsLauncher.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 29.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

//Setings model class
struct Seting { // NSObject?
    let name: String
    let image: UIImage
}

class SettingsLauncher: NSObject {
    
    private let blackView = UIView()
    private let cellHight: CGFloat = 45.0
    
    private let settings: [Seting] = {
        let seting = Seting(name: "Settings", image: #imageLiteral(resourceName: "settings"))
        let privacy = Seting(name: "Terms & Privacy policy", image: #imageLiteral(resourceName: "privacy"))
        let feedBeck = Seting(name: "Send FeedBeck", image: #imageLiteral(resourceName: "feedback"))
        let help = Seting(name: "Help", image: #imageLiteral(resourceName: "help"))
        let swichAccount = Seting(name: "Swich Account", image: #imageLiteral(resourceName: "switch_account"))
        let cancel = Seting(name: "Cancel", image: #imageLiteral(resourceName: "cancel"))
        return [seting, swichAccount, help, feedBeck, privacy, cancel]
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cv
    }()
    
    @objc func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6500160531)
            blackView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(hendleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height:CGFloat = CGFloat(settings.count) * cellHight
            
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.60, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y,
                                                   width: self.collectionView.frame.width,
                                                   height: self.collectionView.frame.height)
                
            }, completion: nil)
            
        }
    }
    @objc private func hendleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height,
                                                   width: self.collectionView.frame.width,
                                                   height: self.collectionView.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: "cellId")
    }
}

//MARK: SettingsLauncher implement
extension SettingsLauncher : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SettingsCell
        let setting = settings[indexPath.item]
        cell.settingsSetValue = setting   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}







