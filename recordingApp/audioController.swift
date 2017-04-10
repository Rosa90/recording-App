//
//  audioController.swift
//  recordingApp
//
//  Created by Rosa Meijers on 05/04/2017.
//  Copyright © 2017 Rosa Meijers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class audioController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var soundButton: UIButton!
    var soundArray: [String] = []
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    //MARK: button events
    
    func nextButtonClicked (){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "audioRemoteController")
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    //MARK: sound events
    
    func getSound() -> [String] {
        
        let fileManager = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = dirPaths[0]
        
        if fileManager.fileExists(atPath: documentDirectory){
            
            var fileListArray : [String] = []
            
            do
            {
                let fileList = try FileManager.default.contentsOfDirectory(atPath: documentDirectory)
                for file in fileList
                {
                    fileListArray.append(file)
                }
                return fileListArray
            }
                
            catch
            {
                print(error.localizedDescription)
                return []
            }
            
            
            
        } else{
            
            print("No Sound")
        }
        
        return [""]
    }
    
    
    
    @IBAction func soundAction(_ sender: Any) {
        playSound()
    }
    
    
    func playSound() {
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        if soundArray.count > 0 {
            let bla = (dirPaths! as NSString).appending("/\(soundArray[0])")
            
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath:bla))
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                print("maestro..music!")
            } catch {
                print("Error getting the audio file")
            }
        } else {
            print("no songs!")
        }
        
    }
    
    
    // MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundArray = getSound()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let navBar = self.navigationController?.navigationBar
        
        let nextButton = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(audioController.nextButtonClicked))
        nextButton.tintColor = UIColor.blue
        navBar?.topItem?.rightBarButtonItem = nextButton
    }
}
