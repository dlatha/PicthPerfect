//
//  PlaySoundsViewController.swift
//  PicthPerfect
//
//  Created by Latha Doddikadi on 3/2/16.
//  Copyright © 2016 demo. All rights reserved.
//
//This ViewController is tied to second navigation screen which plays the recorded sound.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate{
    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var playSlow: UIButton!
    @IBOutlet weak var playFast: UIButton!
    @IBOutlet weak var playChipmunk: UIButton!
    @IBOutlet weak var playDarthVader: UIButton!
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer?.enableRate = true
        audioPlayer?.delegate = self
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        playAudioWithVariablePitch(-1000)

    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        resetAudioPlayer()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()

    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        resetAudioPlayer()
        changeAudioRate(1.5)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        resetAudioPlayer()
        changeAudioRate(0.5)
    }
    
    func changeAudioRate(rate: Float){
        audioPlayer?.rate = rate
        audioPlayer?.currentTime = 0.0
        audioPlayer?.play()
    }
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
    }
    
    override func viewDidDisappear(animated: Bool) {
        audioPlayer?.stop()
    }
    
    override func viewWillDisappear(animated: Bool) {
        audioPlayer?.stop()
    }
    
    func resetAudioPlayer(){
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
