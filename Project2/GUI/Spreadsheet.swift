//
//  Spreadsheet.swift
//  Project2
//
//  Created by Channing on 9/29/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// Originator in Memento pattern
class Spreadsheet: Originator, ObservableObject {
    static let cells: [String] = ["$A", "$B", "$C", "$D", "$E", "$F", "$G", "$H", "$I" ]
    var context: Context

    init(context: Context) {
        self.context = context
    }
    
    static func initNew() -> Spreadsheet {
        let context = Context()
        for cell in cells {
            context.setCell(key: cell, cell: Cell(name: cell))
        }
        return Spreadsheet(context: context)
    }
    
    // Gets called when the user presses enter
    // Returns after all cells are updated
    // At which point the state is saved
    func onCommitEquation(cell: Cell) {
        cell.onCommitEquation(context: context)
    }
    
    func onCommitValue(cell: Cell) {
        cell.onCommitValue()
    }
    
    // Saves state
    // Cant just use 'Context' becuase it stores a reference that keeps getting updated
    // Defeats the whole point, so we have to kind of "serialize" it
    func save() -> Memento {
        let state: [String: CellData] = context.serialize()
        return ConcreteMemento(state: state)
    }
    
    // Restores State
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.context.deserialize(data: memento.state)
    }
}


struct SpreadsheetView: View {
    @State var equationView = true
    @State var spreadsheet: Spreadsheet = Spreadsheet.initNew()
    @State var caretaker: Caretaker = Caretaker()
    
    var body: some View {
        let cells: [String] = Spreadsheet.cells
        return VStack {
            HStack {
                Button(
                    action: { self.caretaker.undo(originator: self.spreadsheet) },
                    label: { Text("Undo") }
                )
            }
            HStack() {
                Text(self.equationView ? "Equation View" : "Value View")
                Spacer()
                Button(
                    action: { self.equationView.toggle() },
                    label: { Text("Change View") }
                )
            }
            HStack() {
                ForEach(cells, id: \.self) { cell in
                    HStack {
                        CellContainer(cell: self.spreadsheet.context.getCell(key: cell)!, equationView: self.$equationView, spreadsheet: self.$spreadsheet, caretaker: self.$caretaker)
                    }
                }
            }.onAppear( perform: { self.caretaker.save(originator: self.spreadsheet) } )
        }
    }
}
