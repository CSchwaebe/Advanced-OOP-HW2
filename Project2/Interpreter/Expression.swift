//
//  Expression.swift
//  Homework2
//
//  Created by Channing on 9/28/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import Foundation

protocol Expression {
    func evaluate(values: Context) -> Double
    func toString() -> String
}
