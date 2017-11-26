//
//  KeypadView.swift
//  Keypad
//
//  Created by Aneel Nazareth on 11/12/17.
//  Copyright © 2017 Aneel Nazareth. All rights reserved.
//

import UIKit
import QuartzCore

class KeypadView: UIView {
    
    var targetTextInput: UITextInput?
    public var selectAllBeforeEditing = true
    
    static let hex: KeypadView = {
        let instance = KeypadView(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
        instance.initializeSubviews(xibFileName: "HexKeypad")
        return instance
    }()
    
    static let ipsum: KeypadView = {
        let instance = KeypadView(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
        instance.initializeSubviews(xibFileName: "IpsumKeypad")
        return instance
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews(xibFileName: "HexKeypad")
        addObservers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews(xibFileName: "HexKeypad")
        addObservers()
    }
    
    func initializeSubviews(xibFileName: String) {
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.editingDidBegin), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editingDidEnd), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editingDidBegin), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editingDidEnd), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func editingDidBegin(notification: Notification) {
        guard let textInput = notification.object as? UITextInput else {
            targetTextInput = nil
            return
        }
        targetTextInput = textInput
        if selectAllBeforeEditing {
            DispatchQueue.main.async {
                textInput.selectedTextRange = textInput.textRange(
                    from: textInput.beginningOfDocument,
                    to: textInput.endOfDocument)
            }
        }
    }
    
    @objc func editingDidEnd(notification: Notification) {
        if notification.object as AnyObject === targetTextInput as AnyObject {
            if let targetTextInput = targetTextInput {
                // if we don't deselect all here, it makes it impossible to begin editing with a single tap a second time
                DispatchQueue.main.async {
                    targetTextInput.selectedTextRange = targetTextInput.textRange(from: targetTextInput.beginningOfDocument, to: targetTextInput.beginningOfDocument)
                }
            }
            targetTextInput = nil
        }
    }
    
    func replaceTextIfShould(input: UITextInput, inRange range: UITextRange, withText text: String) {
        if input.shouldChangeText?(in: range, replacementText: text) ?? true {
            input.replace(range, withText: text)
        }
    }
    
    @IBAction func keyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput,
            let selectedTextRange = targetTextInput.selectedTextRange,
            let key = sender.titleLabel?.text,
            key.count > 0
        {
            replaceTextIfShould(input: targetTextInput, inRange: selectedTextRange, withText: key)
        }
    }
    
    @IBAction func deleteKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput,
            let selectedTextRange = targetTextInput.selectedTextRange {
            if selectedTextRange.isEmpty {
                if let start = targetTextInput.position(from: selectedTextRange.start, offset: -1),
                    let rangeToDelete = targetTextInput.textRange(from: start, to: selectedTextRange.end) {
                    replaceTextIfShould(input: targetTextInput, inRange: rangeToDelete, withText: "")
                }
            } else {
                replaceTextIfShould(input: targetTextInput, inRange: selectedTextRange, withText: "")
            }
        }
    }
    
    @IBAction func clearKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput,
            let rangeToDelete = targetTextInput.textRange(from: targetTextInput.beginningOfDocument, to: targetTextInput.endOfDocument) {
            replaceTextIfShould(input: targetTextInput, inRange: rangeToDelete, withText: "")
        }
    }
    
    @IBAction func doneKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput as? UIResponder {
            targetTextInput.resignFirstResponder()
        }
    }
    
}
