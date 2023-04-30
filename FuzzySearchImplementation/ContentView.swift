//
//  ContentView.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import SwiftUI

struct ContentView: View {
    @State private var users: [ViewModel] = decodeJSON("TestingData.json")
    @State private var searchText: String = ""
    var newUsers: [ViewModel] {
        if searchText.isEmpty {
            return users
        } else {
            return FuzzySearch.search(query: searchText, in: users)
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(newUsers, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text(user.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fontDesign(.monospaced)
                    }
                }
            }
            .searchable(text: $searchText, prompt: Text("Search users"))
            .navigationTitle("Users")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
