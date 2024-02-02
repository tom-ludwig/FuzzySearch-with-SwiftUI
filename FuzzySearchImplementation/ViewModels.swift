//
//  ViewModel.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import Foundation

struct ViewModel: Identifiable, Codable, LevenshteinSearchable {
    var id: Int
    var name: String
    var description: String

    var searchableString: String {
        name
    }
}
struct URLModel: Identifiable, Codable, FuzzySearchable {
    var id: String
    var fileURL: String

    var searchableString: String {
        fileURL
    }
}
