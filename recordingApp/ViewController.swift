//
//  ViewController.swift
//  recordingApp
//
//  Created by Rosa Meijers on 04/04/2017.
//  Copyright © 2017 Rosa Meijers. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    //  audio session: to manage recording, audio recorder: to handle the actual reading and saving of data. 
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var redordImage: UIImageView!
    @IBOutlet var noRecordImage: UIImageView!
    
    //MARK: Button events
    
    func closeButtonClicked() {
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "audioController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Recording methods
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // 2: call either startRecording() or finishRecording() depending on the state of the audio recorder.
    
    func recordTapped() {
        if audioRecorder == nil {
            redordImage.isHidden = false
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    // 4: tell the audio recorder to stop recording, then put the button title back to either "Tap to Record" (if recording finished successfully) or "Tap to Re-record" if there was a problem.
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            
            redordImage.isHidden = true
            
            let alertController = UIAlertController(title: "Succes", message:
                "Record is saved!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            recordButton.setTitle("Tap to Re-record", for: .normal)
            
        } else {
            
            redordImage.isHidden = true
            
            let alertController = UIAlertController(title: "Oops", message:
                "There went something wrong with the recording", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            
            recordButton.setTitle("Tap to Record", for: .normal)
        }
    }
    
    
    //  3: method to start recording. This needs to decide where to save the audio, configure the recording settings, then start recording.
    
    func startRecording() {
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            // audio format: AAC
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            
            // Hertz
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    @IBAction func recordPressed(_ sender: Any) {
        
        recordTapped()
        
    }
    
    // 5: when iOS stops recording for some reason (phone call for example)
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
   
    
    // MARK: ViewController LifeCycle
    
    func setupNavigationBar () {
        
        let navBar = self.navigationController?.navigationBar
        
        navBar?.barTintColor = UIColor(red: 0x33, green: 0x61, blue: 0x12)
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navBar?.topItem?.title = "Talk to your baby"
        
        let micButton = UIButton()
        micButton.setImage(UIImage(named: "microphone"), for: UIControlState.normal)
        //  button.addTarget(self, action: "fbButtonPressed", for: UIControlEvents.touchUpInside)
        micButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: micButton)
        navBar?.topItem?.leftBarButtonItem = barButton
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(ViewController.closeButtonClicked))
        closeButton.tintColor = UIColor.blue
        navBar?.topItem?.rightBarButtonItem = closeButton
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redordImage.isHidden = true
        
        // need to request recording permission from the user.
        
        recordButton.isHidden = true
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isHidden = false
                    } else {
                        
                        let alertController = UIAlertController(title: "Oops", message:
                            "You need to give permission to record", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    }
                }
            }
        } catch {
            
            let alertController = UIAlertController(title: "Oops", message:
                "There went something wrong", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
             setupNavigationBar()
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

