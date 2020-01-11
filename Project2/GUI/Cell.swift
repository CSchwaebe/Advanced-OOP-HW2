//
//  Cell.swift
//  Homework2
//
//  Created by Channing on 9/29/19.
//  Copyright © 2019 Channing. All rights reserved.
//
import SwiftUI
import Foundation
import Combine

// Struct used for saving and restoring a cells state
struct CellData {
    var value: String
    var equation: String
    var valid: Bool
    var dependencies: [String]
}

class Cell: ObservableObject, Identifiable {
    private(set) var name: String
    @Published var value: String
    @Published var equation: String
    @Published var expression: Expression
    private(set) var valueSubject: PassthroughSubject<String, Never>
    private(set) var dependencies: [String: AnyCancellable]
    private(set) var allUpstreamDependencies: Set<String>
    private(set) var valid: Bool
    
    // Note: We pass context in from spreadsheet every time a cell needs it
    // If we made context a CurrentValueSubject that the cell subscribed to
    // Then every time the global context changed, every cell would perform some action
    // By only subscribing to immediate dependencies we only update cells at the exact moment they need to be updated.
    // And passing in the context from the spreadsheet ensures that every cell is working with the same context
    init(name: String) {
        self.name = name
        value = "0"
        valueSubject = PassthroughSubject<String, Never>()
        equation = "0"
        expression = Constant(value: 0)
        dependencies = [:]
        allUpstreamDependencies = []
        valid = true
    }
    
    // When the user enters a new value we throw out the old equation
    // Dont need to parse the equation since its just a constant
    // But first make sure the user actually put in a number
    func onCommitValue() {
        guard let val: Double = Double(value) else {
            handleError()
            return
        }
        equation = value
        expression = Constant(value: val)
        valueSubject.send(value)
    }
    
    // Parse the equation and then evaluate it if its a valid equation
    func onCommitEquation(context: Context) {
        if self.parse() {
            self.evaluate(context: context)
        } else {
            handleError()
        }
    }
    
    func evaluate(context: Context) {
        valid = true
        let list = Parser.getVariables(equation: equation)
        // Subscribe to variables regardless of validity
        // That way this cell will know exactly when it becomes valid again
        subscribe(variables: list, context: context)
        // Checks for circular dependencies and ensures all upstream cells are valid
        validityCheck(variables: list, context: context)
        // Only evaluate the expression if the cell is still valid
        if (valid) {
            value = String(self.expression.evaluate(values: context))
            valueSubject.send(value)
            context.setCell(key: name, cell: self);
        }
    }
    
    // Creates a set of all variables that this cell depends on
    // and the variables that those cells depend on...all the way up
    // if 'self' exists in that set, then its circular
    // other possibility is that one of this cells dependencies is either circular or
    // invalid. If either of cases is true, then this cell is invalid
    func validityCheck(variables: [String], context: Context) {
        allUpstreamDependencies = []
        for variable in variables {
            allUpstreamDependencies.insert(variable)
            for dependency in context.cells[variable]!.allUpstreamDependencies {
                allUpstreamDependencies.insert(dependency)
            }
        }
        for variable in allUpstreamDependencies {
            if (variable == name || !context.cells[variable]!.isValid() ) {
                handleError()
                return
            }
        }
    }
    
    // Subscribes to variables that the cell depends on directly
    // Dont Subscribe to all Upstream Variables because
    // then each cell would update more times than neccessary.
    // Ie only update when you need to and when you have all the data you need to update
    func subscribe(variables: [String], context: Context) {
        dependencies = [:]
        // We only subscribe to variables that we depend on directly
        for variable in variables {
            let valueSubject: PassthroughSubject<String, Never> = context.cells[variable]!.getValueSubject()
            dependencies[variable] =
                valueSubject.sink(receiveValue: { value in
                    if (value == "Error") {
                        self.handleError()
                    } else {
                        self.evaluate(context: context)
                    }
                })
        }
    }
    
    // Handles the parsing of the user input equation
    func parse() -> Bool {
        expression = Parser.parse(equation: equation)
        if (expression.toString() == "ERROR") {
            return false
        } else {
            return true
        }
    }
    
    // Used to Save State
    // Cant just save 'Context' because it holds references to cells
    // Need to 'flatten' or 'serialize' the cells and then save
    func serialize() -> CellData {
        var depend: [String] = []
        for variable in dependencies.keys {
            depend += [variable]
        }
        let val = valid ? true : false
        return CellData(
            value: String(value),
            equation: String(equation),
            valid: val,
            dependencies: depend
        )
    }
    
    // Used to restore a cell to a state
    func deserialize(data: CellData, context: Context) {
        self.valid = data.valid
        self.value = data.value
        self.equation = data.equation
        subscribe(variables: data.dependencies, context: context)
    }
    
    func handleError() {
        if (value != "Error") {
            value = "Error"
            valueSubject.send("Error")
        }
        valid = false
    }
    
    func getName() -> String {
        return name
    }
    func getEquation() -> String {
        return equation
    }
    func setEquation(equation: String) {
        self.equation = equation
    }
    func getValue() -> String {
        return value
    }
    func setValue(value: String) {
        self.value = value
    }
    func isValid() -> Bool {
        return valid
    }
    func getValueSubject() -> PassthroughSubject<String, Never> {
        return valueSubject
    }
    func getUpstreamDependencies() -> Set<String> {
        return allUpstreamDependencies
    }
}



struct CellContainer: View {
    @ObservedObject var cell: Cell
    @Binding var equationView: Bool
    @Binding var spreadsheet: Spreadsheet
    @Binding var caretaker: Caretaker
    
    var body: some View {
        VStack() {
            Text(self.cell.getName())
            if (equationView) {
                TextField("Equation", text: self.$cell.equation, onCommit: {
                    self.spreadsheet.onCommitEquation(cell: self.cell)
                    self.caretaker.save(originator: self.spreadsheet)
                })
            } else {
                TextField("Value", text: self.$cell.value, onCommit: {
                    self.spreadsheet.onCommitValue(cell: self.cell)
                    self.caretaker.save(originator: self.spreadsheet)
                })
            }
            
        }
        
    }
}


