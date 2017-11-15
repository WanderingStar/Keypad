//
//  FourField.swift
//  Keypad
//
//  Created by Aneel Nazareth on 11/14/17.
//  Copyright © 2017 Aneel Nazareth. All rights reserved.
//

import UIKit

class FourField: UITextField {

    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        let originalText = (self.text ?? "") as NSString
        let convertedRange = NSRange(location: offset(from: beginningOfDocument, to: range.start),
                                     length: offset(from: range.start, to: range.end))
        let proposedText = originalText.replacingCharacters(in: convertedRange, with: text)
        
        if proposedText.count > 4 {
            return false
        }
        return true
    }

}
