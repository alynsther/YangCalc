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
    var piWasPressed: Bool = false
    var brain = CalculatorBrain()
    let x = M_PI // pi functiong
    
    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var history: UILabel!
    
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
            updateHistory("\(operation)")
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
        
        if piWasPressed {
            updateHistory("∏")
        } else {
            updateHistory("\(displayValue)")
        }
        
    }
    
    func updateHistory(value: String) {
//        if history.text == "0" {
//            history.text = "0"
//        } else {
            history.text = history.text! + " " + value
//        }
    }


    @IBAction func piPressed() {
        userIsInTheMiddleOfTypingANumber = true
        piWasPressed = true
        display.text = "\(x)"
        enter()
        piWasPressed = false
    }
    
    @IBAction func decimalPressed() {
        userIsInTheMiddleOfTypingANumber = true
        if decimalWasPressed == false {
            display.text = display.text! + "."
            decimalWasPressed = true
        }
    }
    
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalWasPressed = false
        brain.clearBrain()
        display.text = "0"
        history.text = ""
        
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

}

