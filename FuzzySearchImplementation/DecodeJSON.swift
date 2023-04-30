//
//  DecodeJSON.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import Foundation

var testingData: [ViewModel] = decodeJSON("TestingData")

func decodeJSON<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let fileURL = Bundle.main.url(forResource: "TestingData.json", withExtension: nil) else {
        fatalError("Couldn't find \(filename)")
    }
    
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        fatalError("Unresolved error while creating data: \(error.localizedDescription)")
    }
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Unresolved error while decoding data \(error.localizedDescription)")
    }
}
