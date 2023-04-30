//
//  FuzzySearch.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 30.04.23.
//

import Foundation

class FuzzySearch {
    
    /// Searches an array of view models for occurrences of a fuzzy search query.
    ///
    /// This function takes a fuzzy search `query` and an array of `ViewModel` objects, and returns a new array that contains only
    /// those view models that match the query. The function uses the `score` function to calculate a score for each view model's
    /// `name` and `description` properties, and includes only those view models whose scores are greater than 0.0. The resulting
    /// array is then sorted by name score and description score, in descending order.
    ///
    /// - Parameters:
    ///   - query: A `String` value representing the fuzzy search query.
    ///   - array: An array of `ViewModel` objects to search within.
    /// - Returns: An array of `ViewModel` objects that match the fuzzy search query, sorted by name score and description score.
    static func search(query: String, in array: [ViewModel]) -> [ViewModel] {
        let result = array.filter { viewModel -> Bool in
            let nameScore = score(query: query, text: viewModel.name)
            let descriptionScore = score(query: query, text: viewModel.description)
            return nameScore > 0.0 || descriptionScore > 0.0
        }
        
        let sortedResult = result.sorted { viewModel1, viewModel2 -> Bool in
            let nameScore1 = score(query: query, text: viewModel1.name)
            let nameScore2 = score(query: query, text: viewModel2.name)
            let descriptionScore1 = score(query: query, text: viewModel1.description)
            let descriptionScore2 = score(query: query, text: viewModel2.description)
            
            if nameScore1 > nameScore2 {
                return true
            } else if nameScore1 < nameScore2 {
                return false
            } else if descriptionScore1 > descriptionScore2 {
                return true
            } else {
                return false
            }
        }
        
        return sortedResult
    }
    
    /// Calculates the score of the fuzzy search query against a text string.
    ///
    /// This function takes a fuzzy search `query` and a `text` string, and calculates a score based on how well the `query`
    /// matches the `text`. The function is case-insensitive and calculates the score by iterating through each token in the
    /// `query`, finding all occurrences of the token in the `text`, and calculating a proximity score for each occurrence. The
    /// final score is the average of all token scores weighted by their proximity scores.
    ///
    /// - Parameters:
    ///   - query: A `String` value representing the fuzzy search query.
    ///   - text: A `String` value representing the text to search within.
    /// - Returns: A `Double` value representing the calculated score.
    private static func score(query: String, text: String) -> Double {
        let query = query.lowercased()
        let text = text.lowercased()
        let queryTokens = query.split(separator: " ")
        var score: Double = 0.0
        
        for token in queryTokens {
            let ranges = text.ranges(of: token)
            if !ranges.isEmpty {
                let tokenScore = Double(token.count) / Double(text.count)
                let proximityScore = proximityScoreForRanges(ranges)
                score += tokenScore * proximityScore
            }
        }
        print("\(score / Double(queryTokens.count))")
        return score / Double(queryTokens.count)
    }
    
    
    /// Calculates the proximity score based on an array of ranges.
    ///
    /// This function takes an array of `Range<String.Index>` objects and calculates a proximity score. The higher the score,
    /// the closer the ranges are to each other in the original string.
    ///
    /// - Parameter ranges: An array of `Range<String.Index>` objects representing the positions of matched substrings.
    /// - Returns: A `Double` value representing the proximity score.
    private static func proximityScoreForRanges(_ ranges: [Range<String.Index>]) -> Double {
        let sortedRanges = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
        var score: Double = 1.0
        
        for i in 1..<sortedRanges.count {
            let previousRange = sortedRanges[i-1]
            let currentRange = sortedRanges[i]
            let distance = currentRange.lowerBound.encodedOffset - previousRange.upperBound.encodedOffset
            let proximity = 1.0 / Double(distance)
            score += proximity
        }
        return score / Double(sortedRanges.count)
    }
    
    
    
}
struct FuzzyProperty {
    var user: ViewModel
    var score: Double
}


/// Adds a new function to the `String` type that searches for all occurrences of a given substring within the original string.
///
/// This function is case-insensitive and returns an array of `Range<String.Index>` objects representing the positions of all
/// occurrences of the `searchString` within the original string. The function starts searching from the beginning of the
/// string and continues until the end is reached.
///
/// - Parameter searchString: A `String` value to search for within the original string.
/// - Returns: An array of `Range<String.Index>` objects representing the positions of all occurrences of `searchString`.
extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var searchStartIndex = startIndex
        while let range = self[searchStartIndex..<endIndex].range(of: searchString, options: .caseInsensitive) {
            result.append(range)
            searchStartIndex = range.upperBound
        }
        return result
    }
}
