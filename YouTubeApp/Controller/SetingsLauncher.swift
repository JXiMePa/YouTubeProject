//
//  SetingsLauncher.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 29.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    private let blackView = UIView()
    
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
            
            let height:CGFloat = 200
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
        
    }
    
}
