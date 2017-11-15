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
    
    static let shared: KeypadView = {
        let instance = KeypadView(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
        instance.initializeSubviews()
        return instance
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
        addObservers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
        addObservers()
    }
    
    func initializeSubviews() {
        let xibFileName = "KeypadView"
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
        textInput.selectedTextRange = textInput.textRange(
            from: textInput.beginningOfDocument,
            to: textInput.endOfDocument)
        }
    }
    
    @objc func editingDidEnd(notification: Notification) {
        targetTextInput = nil
    }
    
    @IBAction func keyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput,
            let key = sender.titleLabel?.text,
            key.count > 0
        {
            targetTextInput.insertText(key)
        }
    }
    
    @IBAction func deleteKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput {
            targetTextInput.deleteBackward()
        }
    }
    
    @IBAction func clearKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput,
            let rangeToDelete = targetTextInput.textRange(from: targetTextInput.beginningOfDocument, to: targetTextInput.endOfDocument) {
            targetTextInput.replace(rangeToDelete, withText: "")
        }
    }
    
    @IBAction func doneKeyPressed(sender: UIButton) {
        if let targetTextInput = targetTextInput as? UIResponder {
            targetTextInput.resignFirstResponder()
        }
    }

}
