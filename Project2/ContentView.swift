//
//  ContentView.swift
//  Project2
//
//  Created by Channing on 10/6/19.
//  Copyright © 2019 Channing. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        HStack {
            SpreadsheetView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

