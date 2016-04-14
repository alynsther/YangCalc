//
//  GraphViewController.swift
//  YangCalculator
//
//  Created by Adela  Yang on 3/10/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//

import UIKit

@IBDesignable
class GraphViewController: UIViewController, GraphViewDataSource {
    
    /***************************************************************************
     Function:  graphView
     Inputs:    none
     Returns:   none
     Description: initialize an instance of the graphView class
     ***************************************************************************/
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "move:"))
            let tapNumber = UITapGestureRecognizer(target: graphView, action: "center:")
            tapNumber.numberOfTapsRequired = 2;
            graphView.addGestureRecognizer(tapNumber)
        }
    }
    
    /***************************************************************************
     Function:  xForGraphView
     Inputs:    CGFloat
     Returns:   none
     Description: compute y value given x
     ***************************************************************************/
    func xForGraphView(x: CGFloat) -> CGFloat? {
        if let y = brain.setVariable("M", value: Double(x)) {
            return CGFloat(y)
        }
        return nil
    }
    
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    /***************************************************************************
     Function:  updateUI
     Inputs:    none
     Returns:   none
     Description: update the title to display the function being graphed
     ***************************************************************************/
    func updateUI(){
        graphView?.setNeedsDisplay()
        title = "\(brain.description)"
    }
    
    
}

