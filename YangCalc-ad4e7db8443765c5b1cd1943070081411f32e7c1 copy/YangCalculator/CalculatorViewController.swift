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

class CalculatorViewController: UIViewController {

    /***************************************************************************/
    /* global variables */
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var decimalWasPressed: Bool = false
    var piWasPressed = 0
    let x = M_PI // pi functiong
    var started: Bool = false
    var enterFirst: Bool = false
    var brain = CalculatorBrain()
    
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
        started = true
        
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
        started = true
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                history.text = history.text! + "="
            }
            else {
                displayValue = nil
                history.text = history.text!
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
        
        if piWasPressed > 0 {
            brain.pushOperand(x)
            piWasPressed--
        }
        else {
            if let varValue = displayValue {
                if let result = brain.pushOperand(varValue) {
                    displayValue = result
                } else {
                    displayValue = 0
                }
            }
            else {
                displayValue = nil
            }
        }
        enterFirst = true
    }
    
    /***************************************************************************
     Function:  piPressed
     Inputs:    none
     Returns:   none
     Description: updates the history and display value to pi
     ***************************************************************************/
    @IBAction func piPressed(sender: UIButton) {
        let piSign = sender.currentTitle!
        if started{
            enter()
        }
        
        piWasPressed = 1
        display.text = piSign
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
        started = true
        
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
        started = false
        enterFirst = false
        
        piWasPressed = 0
        display.text = ""
        history.text = ""
        brain.clearBrain()
    }
    
 
    @IBAction func getM(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
             // need to test this with a decimal
        }
        
        if let result = brain.pushOperand("M") {
            displayValue = result
        }
        else {
            displayValue = nil
        }
        
    }

    
    @IBAction func setM(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false

        if let result = brain.setVariable("M", value: NSNumberFormatter().numberFromString(display.text!)!.doubleValue) {
            displayValue = result
        }
        else {
            displayValue = nil
        }

    }
    
    /***************************************************************************/
     /* utility functions */
    
    /***************************************************************************
     Function:  displayValue
     Inputs:    Double
     Returns:   none
     Description: displays the value
     ***************************************************************************/
    var displayValue: Double? {
        get {
            if let varValue = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return varValue
            }
            else {
                return nil
            }
        }
        //possible difference here?
        set {
            if let varValue = newValue {
                if varValue != M_PI{
                    
                    display.text = "\(varValue)"
                }

            }
            else {
                display.text = ""
            }
            
            if(newValue != M_PI) {
                history.text = brain.description ?? " "
            }
            else {
                if !enterFirst {
                    history.text = "∏"
                }
                else {
                    history.text = history.text! + ",∏"
                }
            }
            userIsInTheMiddleOfTypingANumber = false
            
        }
    }
    
    /***************************************************************************
     Function:  prepareForSegue
     Inputs:    segue, sender
     Returns:   none
     Description: transfers information through the segue to GraphView
     ***************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "graph":
                    gvc.title = brain.description == "" ? "Graph" : brain.description.componentsSeparatedByString(", ").last
                    gvc.program = brain.program
                default:
                    break
                }
            }
        }
    }


    
    
} // end class

/****** END OF FILE ********************************************************/