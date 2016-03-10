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
    private var knownOps = [String: Op]()
    private var variableValues = [String: Double]()

    /***************************************************************************/
     /* different types of operand and operations */
    private enum Op:CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        //read only property returns a strin
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                    case .Variable(let symbol):
                        return "\(symbol)"
                }
            }
        }

    }
    
    /***************************************************************************
     Function:  program
     Inputs:    any object
     Returns:
     Description:
     ***************************************************************************/
    var program: AnyObject { // guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    }
                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
        }
    }

    /***************************************************************************
     Function:  description
     Inputs:
     Returns:
     Description: read-only that describes the contents of the brain as a String
     ***************************************************************************/
    var description: String {
        get {
            var (result, ops) = ("", opStack)
            repeat {
                var value: String?
                (value, ops) = description(ops)
                if (result == ""){
                    result = value!
                }
                else {
                    result = "\(value!), \(result)"
                }
            } while ops.count > 0
            return result
        }
    }

    /***************************************************************************/
     /* initialize the operations */
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", * ))
        learnOp(Op.BinaryOperation("+", + ))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 } ))
        learnOp(Op.BinaryOperation("−", { $1 - $0 } ))
        learnOp(Op.UnaryOperation("√", sqrt ))
        learnOp(Op.UnaryOperation("sin", sin ))
        learnOp(Op.UnaryOperation("cos", cos ))
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
                case .Variable(let symbol):
                    if variableValues[symbol] == nil {
                        return (nil, ops)
                    }
                    return (variableValues[symbol], remainingOps)
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
        variableValues = [String: Double]()
    }
    
    
    /***************************************************************************
     Function:  pushOperand (assignment 2)
     Inputs:    String
     Returns:   Double
     Description: pushes a variable onto your brain's stack
        should return the result of evaluate after having pushed the variable
     ***************************************************************************/
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    /***************************************************************************
    Function:   setVariable
    Inputs:     string and double
    Returns:    double
    Description: lets users of brain set the value for any variable they wish
    ***************************************************************************/
    func setVariable(symbol: String, value: Double) -> Double? {
        variableValues[symbol] = value
        return evaluate()
    }
    
    /***************************************************************************
     Function:  description
     Inputs:    array of Op
     Returns:   tuple
     Description: evaluates the stack recursively
     ***************************************************************************/
    private func description(ops: [Op]) -> (result: String?,  remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                if operand == M_PI{
                    return ("∏", remainingOps)
                }
                else {
                    return ("\(operand)", remainingOps)
                }
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result {
                    if operand == String(M_PI){
                        return ("\(symbol)(∏)", operandEvaluation.remainingOps)
                    }
                    else {
                        return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
                    }
                }
            case .BinaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if var operand = operandEvaluation.result {
                    if operand == String(M_PI){
                        if remainingOps.count - operandEvaluation.remainingOps.count > 2 {
                            operand = "(∏)"
                        }
                        let operandEvaluation2 = description(operandEvaluation.remainingOps)
                        if let operand2 = operandEvaluation2.result {
                            if operand2 == String(M_PI) {
                                return ("∏ \(symbol) ∏", operandEvaluation2.remainingOps)
                            }
                            else {
                                return ("\(operand2) \(symbol) ∏", operandEvaluation2.remainingOps)
                            }
                        }
                    }
                    else {
                        if remainingOps.count - operandEvaluation.remainingOps.count > 2 {
                            operand = "(\(operand))"
                        }
                        let operandEvaluation2 = description(operandEvaluation.remainingOps)
                        if let operand2 = operandEvaluation2.result {
                            if operand2 == String(M_PI) {
                                return ("∏ \(symbol) \(operand)", operandEvaluation2.remainingOps)
                            }
                            else {
                                return ("\(operand2) \(symbol) \(operand)", operandEvaluation2.remainingOps)
                            }
                        }
                    }
                }
            case .Variable(let symbol):
                return (symbol, remainingOps)
            }
        }
        
        return ("?", ops)
    }

    
    
} // end class

/****** END OF FILE ********************************************************/