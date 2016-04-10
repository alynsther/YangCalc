//
//  GraphView.swift
//  YangCalculator
//
//  Created by Adela  Yang on 3/10/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func functionValueFromPointX(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable var scale: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var origin: CGPoint = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //takes care of pinch gesture
    func scale (gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Constants {
        static let GraphGestureScale: CGFloat = 2
    }
    
    //takes care of pan gesture
    func moveGraph (gesture: UIPanGestureRecognizer) {
        print("entering pan")
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            let xChange = translation.x / Constants.GraphGestureScale
            let yChange = translation.y / Constants.GraphGestureScale
            if (yChange * xChange) != 0 {
                origin.x += xChange
                origin.y += yChange
                gesture.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    //takes care of tap gesture
    func tapCenter (gesture: UITapGestureRecognizer) {
        print("entering tap")
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        //auto adjust the origin to be the center if someone has already reset the origin
        if resetOrigin {
            origin = center
        }
        
        //draw the two axis centered in the UIView
        AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: scale).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        color.set()
        
        let graph = UIBezierPath()
        graph.lineWidth = lineWidth
        var firstValue = true
        var point = CGPoint()
        
        //iterating through every pixel on the graphView
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if (dataSource == nil) {
                print("data source is nil")
            }
            
            let x = point.x - origin.x
            if let y = dataSource!.functionValueFromPointX(x / scale) {
//                print("value of \(x) is \(y)")
                
                if !y.isNormal && !y.isZero {
                    firstValue = true
                    continue
                }
                point.y = origin.y - y * scale
                
                if firstValue {
                    graph.moveToPoint(point)
                    graph.stroke()
                    firstValue = false
                }
                else {
                    graph.addLineToPoint(point)
                    graph.stroke()
                }
            }
        }
    }
    
}


