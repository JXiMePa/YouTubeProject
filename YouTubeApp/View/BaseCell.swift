//
//  BaseCell.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 31.05.2018.
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
