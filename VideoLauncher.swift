//
//  VideoLauncher.swift
//  recordingApp
//
//  Created by Rosa Meijers on 07-04-17.
//  Copyright © 2017 Rosa Meijers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        let urlString = "http://techslides.com/demos/sample-videos/small.mp4"
            if let url = NSURL(string: urlString) {
            let player = AVPlayer(url: url as URL)
                
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            
            player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer(){
        print("showing video player animation..")
        
        let keyframe = UIApplication.shared.keyWindow
        
        // because you are in NSObject, you don't have access to any views, so you that's why you use keywindow
        if keyframe != nil {
            
            let view = UIView(frame: (keyframe!.frame))
            view.backgroundColor = UIColor.purple
            
            view.frame = CGRect(x: (keyframe?.frame.width)!+50, y: (keyframe?.frame.height)!+50, width: 10, height: 10)
            
            //16 * 9 is the aspect ratio of all HD Video's
            let height = (keyframe?.frame.width)! * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: (keyframe?.frame.width)!, height: height
            )
            
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyframe!.addSubview(view)
            
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                
                view.frame = (keyframe?.frame)!
                
            },completion: { (completedAnimation) in
                
               // UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
            
        }
    }
}
