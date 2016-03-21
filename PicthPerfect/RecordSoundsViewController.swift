//
//  RecordSoundsViewController.swift
//  PicthPerfect
//
//  Created by Latha Doddikadi on 3/2/16.
//  Copyright © 2016 demo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    //outlet called when user clicks on record icon
    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        stopButton.enabled = true
        recordLabel.hidden=true
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //this method tells us when the audio has completed recording or not. This is extremely useful when the audio recording is for too long
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
        performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            print("The audio was not recorded!")
            stopButton.hidden = true
            recordingLabel.hidden=true
        }
    }
    
    //this segue navigates to the PlaySounds view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let pc:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            pc.receivedAudio = data
            
        }
    }
    
    //to stop the recording of the audio and then segue is activated to navigate to next screen
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.hidden = true
        recordButton.enabled = true
        stopButton.enabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recordLabel.hidden=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        recordLabel.hidden=false
        stopButton.hidden = true
        recordButton.enabled = true
        stopButton.enabled = false
    }

}

