//
//  CalculatorBrain.swift
//  YangCalculator
//
//  Created by Adela  Yang on 2/5/16.
//  Copyright © 2016 edu.bowdoin.cs3400.ayang. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    /***************************************************************************/
    /* global variables */
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    /***************************************************************************/
     /* different types of operand and operations */
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    /***************************************************************************/
     /* initialize the operations */
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
    }

    /***************************************************************************
     Function:  pushOperand
     Inputs:    Double
     Returns:   Double
     Description: evaluates the operand
     ***************************************************************************/
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    /***************************************************************************
     Function:  performOperation
     Inputs:    String
     Returns:   Double
     Description: evaluates the operation
     ***************************************************************************/
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            return evaluate()
        }
        return nil 
    }
    
    /***************************************************************************
     Function:  evaluate
     Inputs:    none
     Returns:   Double
     Description: evaluates the stack
     ***************************************************************************/
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    /***************************************************************************
     Function:  evaluate
     Inputs:    array of Op
     Returns:   tuple
     Description: evaluates the stack recursively
     ***************************************************************************/
    private func evaluate(ops: [Op]) -> (result: Double?,  remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
        
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    let operandEvaluation2 = evaluate(operandEvaluation.remainingOps)
                    if let operand2 = operandEvaluation2.result {
                        return (operation(operand, operand2), operandEvaluation2.remainingOps)
                    }
                }
            }
        
        }
        
        return (nil, ops)
    }
    
    /***************************************************************************
     Function:  clearBrain
     Inputs:    none
     Returns:   none
     Description: clears the stack
     ***************************************************************************/
    func clearBrain() {
        opStack.removeAll()
    }
    
    

} // end class

/****** END OF FILE ********************************************************/