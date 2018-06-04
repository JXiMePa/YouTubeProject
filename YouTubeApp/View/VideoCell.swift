//
//  VideoCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 27.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            setupProfileImage()
            
            let numberFormater = NumberFormatter()
            numberFormater.numberStyle = .decimal

            if let chanellName = video?.channel?.name, let numbersOfViews = video?.number_of_views {
                subtitleTextView.text = "\(chanellName) ● \(numberFormater.string(from: numbersOfViews)!) \n● 2 years"
            }

            if let thumbnailImageName = video?.thumbnail_image_name {
                thumbnailImageView.image = UIImage(named: thumbnailImageName)
            }
        }
    }
    
    private var thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "defaultVideo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "defaultProfile")
        imageView.contentMode = .scaleAspectFill
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
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.attributedText = NSAttributedString(string: "---", attributes: atribute)
        return label
    }()
    
    private let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        textView.text = "---"
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, -2, 0)
        textView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return textView
    }()
    
    
    //MARK: FIX...
    private func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profile_image_name {
            
            userProfileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
    }
    
    private func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnail_image_name {
            
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }

    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        //Vertical and Horyzontal Format
        addConstraintsWithVisualFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        addConstraintsWithVisualFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithVisualFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        //Another way Constraint
        _ = titleLabel.anchor(thumbnailImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = subtitleTextView.anchor(titleLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    } 
}


var imageCache = NSCache<NSString, UIImage>() {
    didSet { print("set") } }

final class CustomImageView: UIImageView {

   private var imageUrlString: String? // check to same url
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        imageUrlString = urlString
        image = nil
        
        //MARK: FIX!!!
//        if let imageFromCache: UIImage = imageCache.object(forKey: urlString as NSString) {
//            self.image = imageFromCache
//            return
//        }
        
        URLSession.shared.dataTask(with: url!) { [unowned self] (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                   self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }.resume()
    }
}
