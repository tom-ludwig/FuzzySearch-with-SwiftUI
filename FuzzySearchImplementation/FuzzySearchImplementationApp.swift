//
//  FuzzySearchImplementationApp.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import SwiftUI

@main
struct FuzzySearchImplementationApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Levenshtein", systemImage: "person.3")
                    }
                
                FilesView()
                    .tabItem {
                        Label("FuzzySearchable", systemImage: "doc")
                    }
            }
        }
    }
}
