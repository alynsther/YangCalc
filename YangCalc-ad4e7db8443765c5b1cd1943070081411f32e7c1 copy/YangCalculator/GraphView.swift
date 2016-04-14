//
//  GraphView.swift
//  YangCalculator
//
//  Created by Adela  Yang on 3/10/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func xForGraphView(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable var scale: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.cyanColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /***************************************************************************
     Function:  origin
     Inputs:    CGFloat
     Returns:   none
     Description: initialize an origin
     ***************************************************************************/
    private var origin: CGPoint = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    /***************************************************************************
     Function:  resetOrigin
     Inputs:    CGFloat
     Returns:   none
     Description: reset origin given tap gesture
     ***************************************************************************/
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    /***************************************************************************
     Function:  Constants
     Inputs:    none
     Returns:   none
     Description: define the graph gesture scale
     ***************************************************************************/
    private struct Constants {
        static let GraphGestureScale: CGFloat = 2
    }
    
    
    //MARK: Gestures
    
    /***************************************************************************
    Function:  scale
    Inputs:    gesture
    Returns:   none
    Description: readjust screen given the scale
    ***************************************************************************/
    func scale (gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    /***************************************************************************
     Function:  move
     Inputs:    gesture
     Returns:   none
     Description: recalculate the x and y values of the gesture
     ***************************************************************************/
    func move (gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            let xTemp = translation.x / Constants.GraphGestureScale
            let yTemp = translation.y / Constants.GraphGestureScale
            if (yTemp * xTemp) != 0 {
                origin.x += xTemp
                origin.y += yTemp
                gesture.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    /***************************************************************************
     Function:  center
     Inputs:    gesture
     Returns:   none
     Description: recalibrate the origin
     ***************************************************************************/
    //takes care of tap gesture
    func center (gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
    
    /***************************************************************************
     Function:  xForGraphView
     Inputs:    CGFloat
     Returns:   none
     Description: compute y value given x
     ***************************************************************************/
    override func drawRect(rect: CGRect) {
        //readjust the origin is reset by tap
        if resetOrigin {
            origin = center
        }
        
        //initializes axes
        AxesDrawer(color: UIColor.whiteColor(), contentScaleFactor: scale).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        color.set()
        
        let function = UIBezierPath()
        function.lineWidth = lineWidth
        var start = true
        var point = CGPoint()
        
        //iterating through every pixel on the graphView
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if (dataSource == nil) {
                print("data source is nil")
            }
            
            let x = point.x - origin.x
            if let y = dataSource!.xForGraphView(x / scale) {
                
                if !y.isNormal && !y.isZero {
                    start = true
                    continue
                }
                point.y = origin.y - y * scale
                
                if start {
                    function.moveToPoint(point)
                    function.stroke()
                    start = false
                }
                else {
                    function.addLineToPoint(point)
                    function.stroke()
                }
            }
        }
    }
    
}


