//
//  NSMutableAttributedString+Bold.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/5/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 80)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)

        return self
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-Light", size: 80)!]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)

        return self
    }
}
