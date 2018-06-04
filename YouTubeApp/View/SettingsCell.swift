//
//  SettingsCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 31.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class SettingsCell: BaseCell {
    
    override var isHighlighted: Bool  {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.3019607961, green: 0.2511276917, blue: 0.2491173584, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameLabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            iconImageView.tintColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    //incapsulation implement
    var settingsSetValue: Setting? {
        didSet {
            if  let text = settingsSetValue?.name {
                nameLabel.text = text.rawValue
            }
            if let image = settingsSetValue?.image {
               iconImageView.image = image.withRenderingMode(.alwaysTemplate)
                //.withRenderingMode(.alwaysTemplate) - to change .tintColor
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithVisualFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithVisualFormat(format: "V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
