//
//  ExerciseViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit
import PKHUD
import SRCountdownTimer
import FirebaseDatabase
import AudioToolbox
import AVFoundation

class ExerciseViewController: UIViewController, PredictionManagerDelegate {

    @IBOutlet weak var repetitionLbl: UILabel!
    @IBOutlet weak var exerciseLbl: UILabel!

    @IBOutlet weak var countdownTimer: SRCountdownTimer!
    
    @IBOutlet weak var setupCountdown: UILabel!
    
    var timer: Timer?
    var seconds = 10

    var room : String?
    var ref: DatabaseReference = Database.database().reference()
    var workoutStats = [String:Int]()
    var updatePath: String = ""

    private var _predictionManager: PredictionManager!
    private let _speechSynthesizer = AVSpeechSynthesizer()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        countdownTimer.delegate = self

        initUserInRoom(roomName: room!)

        _predictionManager = PredictionManager(delegate: self)

        setupCountdownTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSetupTimer), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()

        _predictionManager.stopPrediction()
    }

    @objc func updateSetupTimer() {
        setupCountdown.text = "\(seconds)"

        if seconds == 0 {
            timer?.invalidate()
            _predictionManager.startPrediction()
            setupCountdown.isHidden = true
            countdownTimer.start(beginingValue: 30, interval: 1)
        } else {
            seconds -= 1
        }
    }

    func setupCountdownTimer() {
        countdownTimer.lineWidth = 20.0
        countdownTimer.lineColor = .blue
        countdownTimer.trailLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        countdownTimer.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 80)!
        countdownTimer.timerFinishingText = "End"
    }
    
    func initUserInRoom(roomName: String) {
        let userName = UserDefaults.standard.object(forKey: "userName") as? String
        if (roomName.contains("private")) {
            print("Private")
            let user = ["name": userName as Any,
                        "Burpee": 0,
                        "Situp": 0,
                        "Squat": 0] as [String : Any]
            self.updatePath = "private-rooms/\(roomName)"
            let childUpdates = [ self.updatePath : user]
            ref.updateChildValues(childUpdates)
        } else if (roomName.contains("random")) {
            
            ref.child("random-rooms").observeSingleEvent(of: .value, with: { (snapshot) in
                let user = ["name": userName as Any,
                            "Burpee": 0,
                            "Situp": 0,
                            "Squat": 0] as [String : Any]
                if (snapshot.hasChild(roomName)) {
                    self.updatePath = "random-rooms/\(roomName)/player2"
                    let childUpdates = [ self.updatePath : user]
                    self.ref.updateChildValues(childUpdates)

                } else {
                    self.updatePath = "random-rooms/\(roomName)/player1"
                    let childUpdates = [ self.updatePath : user]
                    self.ref.updateChildValues(childUpdates)
                }
                
            })
        } else {
            ref.child("custom-rooms").observeSingleEvent(of: .value, with: { (snapshot) in
                let user = ["name": userName as Any,
                            "Burpee": 0,
                            "Situp": 0,
                            "Squat": 0] as [String : Any]
                if (snapshot.hasChild(roomName)) {
                    self.updatePath = "custom-rooms/\(roomName)/player2"
                    let childUpdates = [ self.updatePath : user]
                    self.ref.updateChildValues(childUpdates)
                    
                } else {
                    self.updatePath = "custom-rooms/\(roomName)/player1"
                    let childUpdates = [ self.updatePath : user]
                    self.ref.updateChildValues(childUpdates)
                }
                
            })
        }
    }
        
    func didDetectRepetition(exercise: PREDICTION_MODEL_EXERCISES) {
        let speechUtterance = AVSpeechUtterance(string: exercise.rawValue)
        speechUtterance.rate = 0.4
        _speechSynthesizer.speak(speechUtterance)

        var updateValue = 1;
        if workoutStats[exercise.rawValue] == nil {
            workoutStats[exercise.rawValue] = updateValue;
        } else {
            updateValue = workoutStats[exercise.rawValue]! + 1
            workoutStats[exercise.rawValue] = updateValue;
        }
        
        let childUpdates = [ "\(self.updatePath)/\(exercise.rawValue)" : updateValue]
        ref.updateChildValues(childUpdates)

        if exercise.rawValue != exerciseLbl.text {
            exerciseLbl.text = exercise.rawValue
            repetitionLbl.text = "1"
        } else {
            if let curRepStr = repetitionLbl.text {
                if let curRep = Int(curRepStr) {
                    repetitionLbl.text = String(curRep + 1)
                }
            }
        }
    }

    func didDetectSetBreak() {
    }

    func didChangeStatus(predictionManagerState: PredictionManagerState) {
    }

}

extension ExerciseViewController: SRCountdownTimerDelegate {
    func timerDidEnd() {
        HUD.flash(.success, delay: 2.0)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        _predictionManager.stopPrediction()
        performSegue(withIdentifier: "unwindToVC", sender: self)
    }
}
