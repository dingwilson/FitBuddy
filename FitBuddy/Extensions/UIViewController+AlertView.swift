//
//  UIViewController+AlertView.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertView(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
