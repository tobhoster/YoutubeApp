//
//  VideoLauncher.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/13/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player: AVPlayer?
    
    // Loading Indicator
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    // Video Player Container
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    // Pause Button
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause.png")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.isHidden = true
        
        return button
    }()
    
    // Video Length Label
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Video - Current Time Label
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Video Slider
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.red
        let image = UIImage(named: "dots.png")
        slider.setThumbImage(image, for: .normal)
        return slider
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // SetUpViews
    func setupViews() {
        
        setupPlayerView()
        setupGradientLayer()
        
        pausePlayButton.addTarget(self, action: #selector(VideoPlayerView.handlePause), for: .touchUpInside)
        videoSlider.addTarget(self, action: #selector(VideoPlayerView.handleSliderChange), for: .valueChanged)
        
        controlContainerView.frame = frame
        addSubview(controlContainerView)
        
        // Add Activity Indicator to the Video Player Container
        controlContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // Add Pause Button to the Video Player Container
        controlContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        // Video Length Label
        controlContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Video Current Length
        controlContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        // Video Slider
        controlContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 5).isActive = true
        controlContainerView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: videoSlider)
            
        backgroundColor = UIColor.black
        
    }
    
    func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            
            // Track Player Progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: // This will wait to finish
                DispatchQueue.main, using: { (progressTime) in
                    let seconds = CMTimeGetSeconds(progressTime)
                    
                    let secondsText = String(format: "%02d", Int(seconds) % 60)
                    let minutesText = String(format: "%02d", Int(seconds) / 60)
                    self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
                    
                    // Let set Slider Value
                    if let duration = self.player?.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        
                        self.videoSlider.value = Float(seconds / durationSeconds)
                    }
                    
            })
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.2]
        
        controlContainerView.layer.addSublayer(gradientLayer)
    }
    
    func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: CMTimeValue(Int(value)), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // We would something later
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // When the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    var isPlaying = false
    
    // Handles the Pause Button - is changes the Pause Image to Play
    func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play.png"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause.png"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            // 16 x 9 is the aspect ration of all HD Video
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                view.frame = keyWindow.frame
                
            }, completion: { (completedAnimation) in
                // maybe we'll do something here later
//                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
            

        }
        
        
    }
}
