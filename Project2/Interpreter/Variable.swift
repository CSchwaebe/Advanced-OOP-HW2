//
//  Variable.swift
//  Homework2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

class Variable: Expression {
    
    var name: String
    
    init(name: String) {
        self.name = name;
    }
    
    func evaluate(values: Context) -> Double {
        return Double(values.getCell(key: self.name)!.getValue())!
    }
    
    func toString() -> String {
        return self.name
    }
}
