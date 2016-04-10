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
    
    //instance of GraphView class
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "moveGraph:"))
            let tapNumber = UITapGestureRecognizer(target: graphView, action: "tapCenter:")
            tapNumber.numberOfTapsRequired = 2;
            graphView.addGestureRecognizer(tapNumber)
        }
    }
    
    //compute the value of output given an input
    func functionValueFromPointX(x: CGFloat) -> CGFloat? {
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
    
    func updateUI(){
        graphView?.setNeedsDisplay()
        title = "\(brain.description)"
    }
    
    
}

