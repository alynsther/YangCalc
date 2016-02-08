//
//  ViewController.swift
//  YangCalculator
//
//  Created by Adela  Yang on 2/5/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//


/*****************************************************************************
Description: This program implements a basic calculator that has the stardard
operations along with sin, cos, sqrt, pi, clear, decimal and a history.
******************************************************************************/

import UIKit

class ViewController: UIViewController {

    /***************************************************************************/
    /* global variables */
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var decimalWasPressed: Bool = false
    var piWasPressed = 0
    var brain = CalculatorBrain()
    let x = M_PI // pi functiong
    
    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var history: UILabel!
    
    /***************************************************************************
     Function:  digitPressed
     Inputs:    button pressed
     Returns:   none
     Description: records the digit being pressed and displays it
     ***************************************************************************/
    @IBAction func digitPressed(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    /***************************************************************************
     Function:  operate
     Inputs:    button pressed
     Returns:   none
     Description: updates the operation to the history and calculates the answer
     ***************************************************************************/
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            updateHistory("\(operation)")
            
            if let result = brain.performOperation(operation) {
                displayValue = result
                updateHistory("\(displayValue)")
            } else {
                displayValue = 0
            }
        }
    }
    
    /***************************************************************************
     Function: enter
     Inputs:   none
     Returns:  none
     Description: updates the history adds the thing to the stack
     ***************************************************************************/
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalWasPressed = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        if piWasPressed > 0 {
            updateHistory("∏")
            piWasPressed--
        } else {
            updateHistory("\(displayValue)")
        }
    }
    
    /***************************************************************************
     Function:  piPressed
     Inputs:    none
     Returns:   none
     Description: updates the history and display value to pi
     ***************************************************************************/
    @IBAction func piPressed() {
        enter()
        piWasPressed = 1
        displayValue = x
        enter()
        piWasPressed = 0
    }
    
    /***************************************************************************
     Function:  decimalPressed
     Inputs:    none
     Returns:   none
     Description: updates the display of a floating number
     ***************************************************************************/
    @IBAction func decimalPressed() {
        userIsInTheMiddleOfTypingANumber = true
        if decimalWasPressed == false {
            display.text = display.text! + "."
            decimalWasPressed = true
        }
    }
    
    /***************************************************************************
     Function:  clear
     Inputs:    none
     Returns:   none
     Description: clears the history and display
     ***************************************************************************/
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        decimalWasPressed = false
        piWasPressed = 0
        displayValue = 0
        history.text = ""
        brain.clearBrain()
    }
    
    
    /***************************************************************************/
     /* utility functions */
    
    /***************************************************************************
     Function:  updateHistory
     Inputs:    String
     Returns:   none
     Description: displays the history
     ***************************************************************************/
    func updateHistory(value: String) {
        history.text = history.text! + " " + value
    }

    /***************************************************************************
     Function:  displayValue
     Inputs:    Double
     Returns:   none
     Description: displays the value
     ***************************************************************************/
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    
    
} // end class

/****** END OF FILE ********************************************************/