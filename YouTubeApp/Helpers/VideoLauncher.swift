//
//  VideoLauncher.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 05.06.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {
    
    var view = UIView()

    func showVideoPlayer() {

        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)

            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.frame = keyWindow.frame
            }) { (completedAnimation) in
                // maybe we'll something here later...
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            }
            
            // 9x16 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerView = VideoPlayerView(frame: CGRect(x: 0, y: 0,
                                                                width: keyWindow.frame.width,
                                                                height: height))
           // videoPlayerView.link = self
            videoPlayerView.vpv = self
            
            view.addSubview(videoPlayerView)
            keyWindow.addSubview(view)
        }
    }
}

extension VideoLauncher: Close {
    func changeView() {
        
    print("VideoLauncher: Close, .removeFromSuperview()")
    self.view.removeFromSuperview()
    }
}
