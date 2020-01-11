//
//  Memento.swift
//  Project2
//
//  Created by Channing on 10/2/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

//Memento Interface
protocol Memento {
    var name: String { get }
}

class ConcreteMemento: Memento {
    private(set) var state: [String: CellData]
    init(state:  [String: CellData]) {
        self.state = state
    }
    var name: String { UUID().uuidString }
}

class Caretaker {
    private lazy var mementos = [Memento]()
    init() {}
    // Type should just be Originator and not Spreadsheet
    // But due to issues with SwiftUI I had to make it Spreadsheet
    func save(originator: Spreadsheet) {
        mementos.append(originator.save())
    }
    func undo(originator: Spreadsheet) {
        guard !mementos.isEmpty else { return }
        originator.restore(memento: mementos.removeLast())
    }
}

protocol Originator {
    func save() -> Memento
    func restore(memento: Memento)
}
