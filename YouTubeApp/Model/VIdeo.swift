//
//  VIdeo.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 28.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    @objc var thumbnail_image_name: String?
    @objc var title: String?
    @objc var number_of_views: NSNumber?
    @objc var uploadDate: Date?
   // @objc var duration: NSNumber?
   // @objc var number_of_likes: NSNumber? //"bad" property
    
    @objc var channel: Channel?
    
       //.setValuesForKeys in ApiServise
    override func setValue(_ value: Any?, forKey key: String) {
        
        //--- catch "bad" property
        let upperCaseFirstCharacter = String(key.characters.first!).uppercased() //T
        let range = key.startIndex...key.characters.index(key.startIndex, offsetBy: 0)
        let selectorString = key.replacingCharacters(in: range, with: upperCaseFirstCharacter) //"thumbnail_image_name" = "Thumbnail_image_name"
        let selector = NSSelectorFromString("set\(selectorString):")//"setTitle:" = true, "sdasdFef" = false
        let responds = self.responds(to: selector)
        if !responds { return }
        //---
        
        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(_ dictionary: [String: Any]) {
        super.init()
        setValuesForKeys(dictionary)
        //setValuesForKeys -> title = dictionary["title"] as? String
    }
}

class Channel: NSObject {
    @objc var name: String?
    @objc var profile_image_name: String?
}
