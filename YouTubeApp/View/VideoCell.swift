//
//  VideoCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 27.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    //every time when i call .dequeueReusableCell -> init!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class VideoCell: BaseCell {
 
   private let thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "teilorSwift")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
       return imageView
    }()
    
    private let userProfileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "teilorSwiftProfile")
    imageView.layer.cornerRadius = 22 // half width and height
        imageView.layer.masksToBounds = true
    return imageView
    }()
    
   private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let atribute:[NSAttributedStringKey : Any] =
            [.strokeWidth: 5, .font: UIFont.systemFont(ofSize: 22),
             .foregroundColor: UIColor.black]
        
        label.attributedText = NSAttributedString(string: "Taylor Swift - Blank Spase", attributes: atribute)
        return label
    }()
    
    private let subtitleTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        textView.text = "Taylor Swift VEVO - 1,604,684,607 views\n by 2 years"
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, -2, 0)
        textView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return textView
    }()
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        //Vertical and Horyzontal Format
        addConstraintsWithVisualFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        addConstraintsWithVisualFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithVisualFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
       //Another way Constraint
        _ = titleLabel.anchor(thumbnailImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
         _ = subtitleTextView.anchor(titleLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    } 
}
