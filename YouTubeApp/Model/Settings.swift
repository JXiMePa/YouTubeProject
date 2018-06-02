//
//  Settings.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 01.06.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

//Setings model class
final class Setting: NSObject { // NSObject is Hashable!
    let name: SettingName
    let image: UIImage
    
    init(name: SettingName, image: UIImage) {
        self.name = name
        self.image = image
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Privacy = "Terms & Privacy policy"
    case FeedBeck = "Send FeedBeck"
    case Help = "Help"
    case SwichAccount = "Swich Account"
    case Setting = "Settings"
}
