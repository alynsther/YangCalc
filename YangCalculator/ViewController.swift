//
//  ViewController.swift
//  YangCalculator
//
//  Created by Adela  Yang on 2/5/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var userIsInTheMiddleOfTypingANumber: Bool = false
    var decimalWasPressed: Bool = false
    var brain = CalculatorBrain()
    let x = M_PI // pi functiong
    
    @IBOutlet weak var display: UILabel!

    @IBAction func digitPressed(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
//        print("The digit pressed was \(display.text)")
        
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalWasPressed = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }


    @IBAction func piPressed() {
        userIsInTheMiddleOfTypingANumber = true
        if display.text != "0" {
            enter()
        }
        display.text = "\(x)"
        enter()
    }
    
    @IBAction func decimalPressed() {
        userIsInTheMiddleOfTypingANumber = true
        if !decimalWasPressed {
            display.text = display.text! + "."
            decimalWasPressed = true
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clearBrain()
        display.text = "0"
        enter()
        
    }
    //Chown suggests that this should be removed
    //kept it because wanted the background to be black
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        self.view.backgroundColor = UIColor.blackColor()
//    }
    
    //Chown suggests that this should be removed
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    


}

