//
//  SignUpViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self

        if let userName = UserDefaults.standard.object(forKey: "userName") as? String {
            userNameTextField.text = userName
        }

        if let password = UserDefaults.standard.object(forKey: "password") as? String {
            passwordTextField.text = password
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToVC", sender: self)
    }

    @IBAction func didPressSubmitButton(_ sender: Any) {
        guard
            let userName = userNameTextField.text,
            !userName.isEmpty
        else {
            alertView(withTitle: "Error", message: "Username field is empty or invalid.")
            return
        }

        guard
            let password = passwordTextField.text,
            !password.isEmpty
        else {
            alertView(withTitle: "Error", message: "Password field is empty or invalid.")
            return
        }

        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(password, forKey: "password")

        // FIREBASE TODO: send userName and password to backend
    }
}
