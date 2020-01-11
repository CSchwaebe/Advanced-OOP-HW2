//
//  Project2Tests.swift
//  Project2Tests
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import XCTest
@testable import Project2

class Project2Tests: XCTestCase {
    
    var spreadsheet: Spreadsheet!
    var caretaker: Caretaker!
    
    override func setUp() {
        spreadsheet = Spreadsheet.initNew()
        caretaker = Caretaker()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFunctions() {
        let equations: [String] = [
            "10 6 +",
            "20 4 -",
            "4 4 *",
            "32 2 /",
        ]
        
        for eq in equations {
            XCTAssertTrue ( 16 == Parser.parse(equation: eq).evaluate(values: spreadsheet.context) )
        }
        
        XCTAssertTrue ( 1 == Parser.parse(equation: "90 sin").evaluate(values: spreadsheet.context) )
        
        XCTAssertTrue ( 5 == Parser.parse(equation: "32 lg").evaluate(values: spreadsheet.context) )
        
        XCTAssertTrue ( "ERROR" == Parser.parse(equation: "lsdhf").toString())
    }
    
    func testSimpleCells() {
        let equations: [String] = [
            "10 6 +",
            "20 4 -",
            "4 4 *",
            "32 2 /",
        ]
        
        let cells: [String] = [
            "$A", "$B", "$C", "$D"
        ]
        
        var index = 0
        for eq in equations {
            let cell = spreadsheet.context.getCell(key: cells[index])!
            
            cell.setEquation(equation: eq)
            spreadsheet.onCommitEquation(cell: cell)
            let value: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
            XCTAssertTrue ( 16 == Double(value) )
            index += 1
        }
    }
    
    // Tests the computation of values based on variables
    func testDependentCells() {
        let equations: [String] = [
            "10 6 +",
            "$A 4 -",
            "4 $B *",
            "$C 16 /",
        ]
        
        let cells: [String] = [
            "$A", "$B", "$C", "$D"
        ]
        
        let values: [Double] = [
            16,
            12,
            48,
            3
        ]
        
        var index = 0
        for eq in equations {
            let cell = spreadsheet.context.getCell(key: cells[index])!
            cell.setEquation(equation: eq)
            spreadsheet.onCommitEquation(cell: cell)
            let value: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
            XCTAssertTrue ( values[index] == Double(value) )
            index += 1
        }
    }
    
    // Creates and then fixes a circular dependency
    func testErrorToClean() {
        let equations: [String] = [
            "10 $A +",
            "$B 4 -",
            "4 $C *",
            "$C lg",
            "32 16 /",
        ]
        
        let cells: [String] = [
            "$B", "$C", "$A", "$D", "$A"
        ]
        
        let values: [String] = [
            "10.0",
            "6.0",
            "Error",
            "Error"
        ]
        
        var index = 0
        for eq in equations {
            let cell = spreadsheet.context.getCell(key: cells[index])!
            cell.setEquation(equation: eq)
            spreadsheet.onCommitEquation(cell: cell)
            //First Error State
            if (index == 2) {
                XCTAssertTrue ("Error" == spreadsheet.context.getCell(key: cells[0])!.getValue())
                XCTAssertTrue ("Error" == spreadsheet.context.getCell(key: cells[1])!.getValue())
                XCTAssertTrue ("Error" == spreadsheet.context.getCell(key: cells[2])!.getValue())
                
            }
            // After fixing the error
            else if index == 4 {
                XCTAssertTrue ("2.0" == spreadsheet.context.getCell(key: "$A")!.getValue())
                XCTAssertTrue ("12.0" == spreadsheet.context.getCell(key: "$B")!.getValue())
                XCTAssertTrue ("8.0" == spreadsheet.context.getCell(key: "$C")!.getValue())
                XCTAssertTrue ("3.0" == spreadsheet.context.getCell(key: "$D")!.getValue())
            } else {
                let value: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
                XCTAssertTrue ( values[index] == value )
            }
            index += 1
        }
    }
    
    func testUndo() {
        let equations: [String] = [
            "10 6 +",
            "$A 4 -",
            "4 $B *",
            "$C 16 /",
        ]
        
        let cells: [String] = [
            "$A", "$B", "$C", "$D"
        ]
        
        let values: [Double] = [
            16,
            12,
            48,
            3
        ]
        
        var index = 0
        
        for eq in equations {
            //Saves the state
            caretaker.save(originator: spreadsheet)
            // Gets a cell
            let cell = spreadsheet.context.getCell(key: cells[index])!
            
            // Performs operations on a cell and ensures correctness
            cell.setEquation(equation: eq)
            spreadsheet.onCommitEquation(cell: cell)
            let value: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
            XCTAssertTrue ( values[index] == Double(value) )
            index += 1
        }
        
        while index > 0 {
            // Double check that cell is still in the state it should be in
            index -= 1
            let v: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
            XCTAssertTrue ( values[index] == Double(v) )
            
            // Revert state to previous state
            caretaker.undo(originator: spreadsheet)
            
            // Check that cell is in its previous state
            let cell = spreadsheet.context.getCell(key: cells[index])!
            
            let value: String = spreadsheet.context.getCell(key: cells[index])!.getValue()
            XCTAssertTrue ( "0" == value )
        }
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
