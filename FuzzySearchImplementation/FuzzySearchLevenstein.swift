//
//  FuzzySearchLevenstein.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.01.24.
//

import Foundation

protocol LevenshteinSearchable {
    var searchableString: String { get }
}

extension String: LevenshteinSearchable {
    var searchableString: String {
        self
    }
}

//extension Collection where Iterator.Element: LevenshteinSearchable {
//    func fuzzySearch(searchString: String) -> [Iterator.Element]? {
//        let array = map { $0 }
//        return FuzzySearchLevenstein.fuzzySearch(candidates: array, searchString: searchString)
//    }
//}

extension Array where Element: LevenshteinSearchable {
    func search(searchString: String) -> [Element]? {
        return FuzzySearchLevenstein.fuzzySearch(candidates: self, searchString: searchString)
    }
}

struct FuzzySearchLevenstein {
    static func levenshteinDistanceVector(source: [UInt16], target: [UInt16]) -> UInt16 {
        let sourceLength = source.count
        let targetLength = target.count
        var distances = [UInt16](repeating: 0, count: targetLength + 1)

        // Initialise the first row
        for columnIndex in 0...targetLength {
            distances[columnIndex] = UInt16(columnIndex)
        }

        for rowIndex in 1...sourceLength {
            var previousDistance = distances[0]
            distances[0] = UInt16(rowIndex)

            for columnIndex in 1...targetLength {
                let substitutionCost = source[rowIndex - 1] != target[columnIndex - 1]
                let oldDistance = distances[columnIndex]

                distances[columnIndex] = min(
                    distances[columnIndex] + 1,           // Insert into target
                    previousDistance + (substitutionCost ? 1 : 0),        // Substitute
                    distances[columnIndex - 1] + 1        // Delete from target
                )

                previousDistance = oldDistance
            }
        }

        return distances[targetLength]
    }


    static func fuzzySearch<T>(candidates: [T], searchString: String) -> [T]? where T: LevenshteinSearchable {
        guard !searchString.isEmpty else {
            return nil
        }

        let targetVector = searchString.unicodeScalars.map { scalar in UInt16(scalar.value) }
        let targetStringLength = searchString.count

        let results: [(item: T, score: Double)] = candidates.map { candidate in
            let candidateString = candidate.searchableString
            let candidateVector = candidateString.unicodeScalars.map { scalar in UInt16(scalar.value) }

            let distance = levenshteinDistanceVector(source: candidateVector, target: targetVector)
            let score = 1.0 - Double(distance) / max(Double(targetStringLength), Double(candidateString.count))

            return (item: candidate, score: score)
        }

        return results.filter { $0.score > 0 }
            .sorted { $0.score > $1.score }
            .map { $0.item }
    }
}
