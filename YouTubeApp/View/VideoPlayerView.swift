//
//  VideoPlayerView.swift
//  YouTubeApp
//
//  Created by Tarasenko Jurik on 14.06.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit
import AVFoundation

protocol Close: AnyObject {
    func changeView()
}

final class VideoPlayerView: UIView {
    
   private var isPlaying = false
   private var player: AVPlayer?
   private var videoLauncher: VideoLauncher?///!!!!!!!
    
    private let closeVideoLancher: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        button.setTitle(">", for: .normal)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
       return button
    }()
    
    //weak var link: Close?
    var vpv: VideoLauncher?
    
    @objc private func closeButtonAction() {
        print("closeButtonAction(), delegat?.changeView()")
     //   link?.changeView()
        vpv?.changeView()
    }
   private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    private let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()

    @objc private func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
   private let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.isHidden = true
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        print(videoSlider.value) // (start = 0)...(1 = finish)
        
        if let duration = player?.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            
           let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTimer = CMTime(value: Int64(value), timescale: 1)
            //value - seconds,timescale - interval
            player?.seek(to: seekTimer, completionHandler: { (completedSeek) in
            // perhaps do something lather here
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        
        
        addSubview(controlsContainerView)
        controlsContainerView.frame = frame
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
       _ = videoLengthLabel.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 8, widthConstant: 50, heightConstant: 24)

        controlsContainerView.addSubview(currentTimeLabel)
       _ = currentTimeLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 2, rightConstant: 0, widthConstant: 50, heightConstant: 24)

        controlsContainerView.addSubview(videoSlider)
       _ = videoSlider.anchor(nil, left: currentTimeLabel.rightAnchor, bottom: bottomAnchor, right: videoLengthLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        controlsContainerView.addSubview(closeVideoLancher)
        
        backgroundColor = .black
        
        ///--------------------------------
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(scrollDown))
        swipe.direction = [.down]
        controlsContainerView.addGestureRecognizer(swipe)
    }
    
    @objc private func scrollDown() {
        print("12345")
        videoLauncher?.view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    }
    
    

    fileprivate func setupPlayerView() {
        //warning: use your own video url here, the bandwidth for google firebase storage will run out as more and more people use this file
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                self?.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                // move slider thumb
                if let duration = self?.player?.currentItem?.duration {
                    //.duration - Продолжительность материала элемента
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self?.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            videoSlider.isHidden = false
            isPlaying = true // player is ready! else to pause 2 click to pause
            
            if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            let secondsText = Int(seconds) % 60
           // let minutesText = Int(seconds) / 60
                let minutesText = String(format: "%2d", Int(seconds) / 60) //0:00 -> to 00:00
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds // bounds controlsContainerView
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.3]
        //  [(foolFrame = 0)...(foolFrame = 1), (foolColor"1" = 1)...(foolColor"0" = 0)]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
