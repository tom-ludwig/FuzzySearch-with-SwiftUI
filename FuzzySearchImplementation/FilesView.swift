//
//  FilesView.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 23.05.23.
//

import SwiftUI

struct FilesView: View {
    @State private var searchText: String = ""
    var files: [URLModel] {
        if searchText.isEmpty {
            return fileURL
        } else {
            let result = fileURL.fuzzySearch(query: searchText)
            return result.map {
                return $0.item
            }
//            return FuzzySearchLevenstein.search(query: searchText, in: fileURL)
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(files, id: \.id) { user in
                    LazyVStack(alignment: .leading) {
                        HStack {
                            Text(user.fileURL)
                                .font(.footnote)
                                .fontDesign(.monospaced)
                            
                            Spacer()
                            
                            Text(user.id)
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .fontDesign(.monospaced)
                                .fontWeight(.light)
                            
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: Text("Search files"))
            .navigationTitle("Files")
        }
    }
}


struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
