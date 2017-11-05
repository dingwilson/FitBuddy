//
//  ExerciseViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, PredictionManagerDelegate {

    @IBOutlet weak var repetitionLbl: UILabel!
    @IBOutlet weak var exerciseLbl: UILabel!

    private var _predictionManager: PredictionManager!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func didDetectRepetition(exercise: PREDICTION_MODEL_EXERCISES) {
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
        exerciseLbl.text = "Set Break"
        repetitionLbl.text = "-"
    }

    func didChangeStatus(predictionManagerState: PredictionManagerState) {
        print(predictionManagerState.rawValue)
    }

}
