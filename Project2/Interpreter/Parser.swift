//
//  Parser.swift
//  Project2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

class Parser {
    static let variables: Set = [
        "$A", "$B", "$C", "$D", "$E", "$F", "$G", "$H", "$I"
    ]
    static let operations: Set = [
        "+", "-", "*", "/", "sin", "lg"
    ]
    
    static func parse(equation: String) -> Expression {
        let tokens = equation.split(separator: " ")
        if (tokens.count == 0) {
            return Constant(value: 0)
        }
        
        var a: Expression
        var op1: Expression
        var op2: Expression
        var stack: [Expression] = [];
        
        for token in tokens {
            if let number = Double(token) {
                stack.append(Constant(value: number))
            } else if variables.contains(String(token)) {
                stack.append(Variable(name: String(token)))
            } else if operations.contains(String(token)) {
                switch token {
                case "+":
                    op1 = stack.popLast()!
                    op2 = stack.popLast()!
                    a = Addition(leftOperand: op2, rightOperand: op1)
                    stack.append(a)
                case "-":
                    op1 = stack.popLast()!
                    op2 = stack.popLast()!
                    a = Subtraction(leftOperand: op2, rightOperand: op1)
                    stack.append(a)
                case "*":
                    op1 = stack.popLast()!
                    op2 = stack.popLast()!
                    a = Multiplication(leftOperand: op2, rightOperand: op1)
                    stack.append(a)
                case "/":
                    op1 = stack.popLast()!
                    op2 = stack.popLast()!
                    a = Division(leftOperand: op2, rightOperand: op1)
                    stack.append(a)
                case "sin":
                    a = Sine(operand: stack.popLast()!)
                    stack.append(a)
                case "lg":
                    a = Log(operand: stack.popLast()!)
                    stack.append(a)
                default:
                    return Variable(name: "ERROR")
                }
            } else {
                return Variable(name: "ERROR")
            }
        }
        
        return stack.popLast()!
    }
    
    static func getVariables(equation: String) -> [String] {
        let tokens = equation.split(separator: " ")
        var list: [String] = []
        
        for token in tokens {
            let variable = String(token)
            if variables.contains(variable) {
                list += [variable]
            }
        }
        
        return list;
    }
}
