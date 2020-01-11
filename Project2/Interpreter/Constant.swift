//
//  Constant.swift
//  Homework2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

class Constant: Expression {
    var value: Double
    
    init(value: Double) {
        self.value = value;
    }

    func Constant(value: Int) {
        self.value = Double(value);
    }

    func evaluate(values: Context) -> Double {
        return value;
    }

    func toString() -> String {
        return String(value);
    }
}
