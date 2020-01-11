//
//  Context.swift
//  Project2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

// Handles the state and is used by the Interpreter to get values of cells
class Context: ObservableObject {
    @Published var cells: [String: Cell] = [:]

    func getCell(key: String) -> Cell? {
        if (cells[key] != nil) {
            return cells[key]
        } else {
            return nil
        }
    }
    
    func setCell(key: String, cell: Cell) {
        cells[key] = cell
    }
    
    func serialize() -> [String: CellData] {
        var serials: [String: CellData] = [:]
        for key in cells.keys {
            serials[key] = cells[key]!.serialize()
        }
        return serials
    }
    
    func deserialize(data: [String: CellData]) {
        for key in cells.keys {
            cells[key]!.deserialize(data: data[key]!, context: self)
        }
    }
    
}
