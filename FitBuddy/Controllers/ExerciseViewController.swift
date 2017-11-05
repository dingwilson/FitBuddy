//
//  ExerciseViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExerciseViewController: UIViewController, PredictionManagerDelegate {

    @IBOutlet weak var repetitionLbl: UILabel!
    @IBOutlet weak var exerciseLbl: UILabel!

    var room : String?
    var ref: DatabaseReference = Database.database().reference()
    var workoutStats = [String:Int]()
    var updatePath: String = ""

    private var _predictionManager: PredictionManager!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInRoom(roomName: room!)
        _predictionManager = PredictionManager(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _predictionManager.startPrediction()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _predictionManager.stopPrediction()
    }
    
    func initUserInRoom(roomName: String) {
        let userName = UserDefaults.standard.object(forKey: "userName") as? String
        if (roomName.contains("private")) {
            print("Private")
            let user = ["name": userName,
                        "Burpee": 0,
                        "Situp": 0,
                        "Squat": 0] as [String : Any]
            self.updatePath = "private-rooms/\(roomName)"
            let childUpdates = [ self.updatePath : user]
            ref.updateChildValues(childUpdates)
        } else if (roomName.contains("random")) {
            
            ref.child("random-rooms").observeSingleEvent(of: .value, with: { (snapshot) in
                let user = ["name": userName,
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
                let user = ["name": userName,
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
        
        var updateValue = 1;
        if workoutStats[exercise.rawValue] == nil {
            workoutStats[exercise.rawValue] = updateValue;
        } else {
            updateValue = workoutStats[exercise.rawValue]! + 1
            workoutStats[exercise.rawValue] = updateValue;
        }
        
        let childUpdates = [ "\(self.updatePath)/\(exercise.rawValue)" : updateValue]
        ref.updateChildValues(childUpdates)

//        if exercise.rawValue != exerciseLbl.text {
//            exerciseLbl.text = exercise.rawValue
//            repetitionLbl.text = "1"
//        } else {
//            if let curRepStr = repetitionLbl.text {
//                if let curRep = Int(curRepStr) {
//                    repetitionLbl.text = String(curRep + 1)
//                }
//            }
//        }
    }

    func didDetectSetBreak() {
        exerciseLbl.text = "Set Break"
        repetitionLbl.text = "-"
    }

    func didChangeStatus(predictionManagerState: PredictionManagerState) {
        print(predictionManagerState.rawValue)
    }

}
