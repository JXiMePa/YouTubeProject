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
            userProfileImageView.loadImageWithUrl(profileImageUrl)
        }
    }
    
    private func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnail_image_name {
            thumbnailImageView.loadImageWithUrl(thumbnailImageUrl)
        }
    }
    
    override func setupViews() {
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        //Vertical and Horyzontal Format
        addConstraintsWithVisualFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: thumbnailImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithVisualFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        //Another way Constraint
        _ = titleLabel.anchor(thumbnailImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = subtitleTextView.anchor(titleLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: thumbnailImageView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    } 
}

///----------------------------------------------------------------------------
var imageCache = NSCache<AnyObject, UIImage>()

class CustomImageView: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        // setup activityIndicator...
        activityIndicator.color = .red
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageURL = url
        image = nil
        activityIndicator.startAnimating()
        
        //       retrieves image if already available in cache
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
//            self.image = imageFromCache
//            activityIndicator.stopAnimating()
//
//        } else {
        
            // image does not available in cache.. so retrieving it from url...
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    // self?.activityIndicator.stopAnimating()
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        
                        if self?.imageURL == url {
                            self?.image = imageToCache
                        }
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                    self?.activityIndicator.stopAnimating()
                })
            }).resume()
        }
   // }
}
