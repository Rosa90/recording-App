//
//  audioRemoteController.swift
//  recordingApp
//
//  Created by Rosa Meijers on 06-04-17.
//  Copyright © 2017 Rosa Meijers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class audioRemoteController: UIViewController, AVAssetResourceLoaderDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
    var request:AVAssetResourceLoadingRequest?
    let url: NSURL = NSURL(string:"customscheme://host/audio.mp3")!
    var player: AVPlayer? = nil
    let videoLauncher = VideoLauncher()
    
    // MARK: class methods
    
    func setupAVPlayer(){
        
    let asset = AVURLAsset(url: url as URL, options: nil)
    asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        
    let item: AVPlayerItem = AVPlayerItem(asset: asset)
        
    // Register as an observer of the player item's status property
    item.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil)
        
    // Associate the player item with the player
    player = AVPlayer(playerItem: item)
    
    }
    
    // MARK: RESOURCE LOADER DELEGATES
    
    // The next thing we should do is create custom class that will load data of requested resource from the server and pass loaded data back to AVURLAsset. Let’s name it LSFilePlayerResourceLoader and add two parameters in init method. The first parameter is requested file url and the second is YDSession object. This session object is responsible for getting file data from cloud server.
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("lR:", loadingRequest)
        self.request = loadingRequest
       
        let resourceURL: URL = loadingRequest.request.url!
        
        if(resourceURL.scheme == "customscheme") {
            
        }
        
        return true

    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        //
    }
    
    
    // This method is invoked whenever the status changes giving you the chance to take some action in response. You do not play immediately because data for playing may not be ready yet (poor network). that is why player decides when to play and thats why you should observe status.
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
//        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
//            return
    //    }
        
            if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay: break
            // Player item is ready to play.
            case .failed: break
            // Player item failed. See error.
            case .unknown: break
            // Player item is not yet ready.
            }
        }
    }
    
    // MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoLauncher.showVideoPlayer()
       
        
    }
    
}
