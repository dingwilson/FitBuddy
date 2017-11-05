//
//  SplashViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class SplashViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var backgroundVideo: BackgroundVideo!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundVideo.createBackgroundVideo(name: "Background", type: "mp4", alpha: 0.10)

        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("Fit")
            .normal("Buddy")

        titleTextLabel.attributedText = formattedString
    }

    @IBAction func didPressLoginButton(_ sender: Any) {
        guard
            let userName = UserDefaults.standard.object(forKey: "userName") as? String,
            let password = UserDefaults.standard.object(forKey: "password") as? String,
            !userName.isEmpty,
            !password.isEmpty
        else {
            alertView(withTitle: "Error", message: "You are not signed up. Please sign up first!")
            return
        }

        performSegue(withIdentifier: "segueToLogin", sender: self)
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) { }
}
