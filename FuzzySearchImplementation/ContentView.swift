//
//  ContentView.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    var sortedUsers: [ViewModel] {
        if searchText.isEmpty {
            return users
        } else {
            return FuzzySearch.search(query: searchText, in: users)
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedUsers, id: \.id) { user in
                    LazyVStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .fontDesign(.monospaced)
                            
                            Text(user.description)
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .fontDesign(.monospaced)
                                .fontWeight(.light)
                            
                        }
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
