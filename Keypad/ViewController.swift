//
//  ViewController.swift
//  Keypad
//
//  Created by Aneel Nazareth on 11/12/17.
//  Copyright © 2017 Aneel Nazareth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.inputView = KeypadView.shared
        textView.inputView = KeypadView.shared
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

