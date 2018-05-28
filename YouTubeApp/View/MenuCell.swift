//
//  MenuCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 28.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
     let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = self.isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.1525913481, green: 0.09426488235, blue: 0.09442671263, alpha: 1)
        }
    }
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = self.isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.1525913481, green: 0.09426488235, blue: 0.09442671263, alpha: 1)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithVisualFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithVisualFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
