//
//  Operations.swift
//  Homework2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

class Addition: Expression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(leftOperand: Expression, rightOperand: Expression) {
        self.leftOperand = leftOperand
        self.rightOperand = rightOperand
    }
    
    func evaluate(values: Context) -> Double {
        return leftOperand.evaluate(values: values) + rightOperand.evaluate(values: values)
    }
    
    func toString() -> String {
        return "(" + leftOperand.toString() + " + " + rightOperand.toString() + ")"
    }
}


class Subtraction: Expression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(leftOperand: Expression, rightOperand: Expression) {
        self.leftOperand = leftOperand
        self.rightOperand = rightOperand
    }
    
    func evaluate(values: Context) -> Double {
        return leftOperand.evaluate(values: values) - rightOperand.evaluate(values: values)
    }
    
    func toString() -> String {
        return "(" + leftOperand.toString() + " - " + rightOperand.toString() + ")"
    }
}


class Multiplication: Expression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(leftOperand: Expression, rightOperand: Expression) {
        self.leftOperand = leftOperand
        self.rightOperand = rightOperand
    }
    
    func evaluate(values: Context) -> Double {
        return leftOperand.evaluate(values: values) * rightOperand.evaluate(values: values)
    }
    
    func toString() -> String {
        return "(" + leftOperand.toString() + " * " + rightOperand.toString() + ")"
    }
}


class Division: Expression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(leftOperand: Expression, rightOperand: Expression) {
        self.leftOperand = leftOperand
        self.rightOperand = rightOperand
    }
    
    func evaluate(values: Context) -> Double {
        return leftOperand.evaluate(values: values) / rightOperand.evaluate(values: values)
    }
    
    func toString() -> String {
        return "(" + leftOperand.toString() + " / " + rightOperand.toString() + ")"
    }
}


class Sine: Expression {
    var operand: Expression
    
    init(operand: Expression) {
        self.operand = operand
    }
    
    func evaluate(values: Context) -> Double {
        return sin(operand.evaluate(values: values) * Double.pi / 180);
    }
    
    func toString() -> String {
        return "sin(" + operand.toString() + ")"
    }
}


class Log: Expression {
    var operand: Expression
    
    init(operand: Expression) {
        self.operand = operand
    }
    
    func evaluate(values: Context) -> Double {
        return log2(operand.evaluate(values: values));
    }
    
    func toString() -> String {
        return "log(" + operand.toString() + ")"
    }
}
