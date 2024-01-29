//
//  String+Normalise.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 27.01.24.
//

import Foundation

extension String {

    /// Normalises the characters in a string using ASCII encoding.
    ///
    /// This function takes each character in the string, converts it to its ASCII representation,
    /// and then reconstructs it back to a string using ASCII encoding. The resulting characters
    /// are returned as an array of FuzzySearchCharacter objects.
    ///
    /// - Returns: An array of FuzzySearchCharacter objects representing the normalised characters.
    /// If normalisation fails for any character, the original character is used.
    func normalise() -> [FuzzySearchCharacter] {
        return self.lowercased().map { char in
            guard let data = String(char).data(using: .ascii, allowLossyConversion: true),
                  let normalisedCharacter = String(data: data, encoding: .ascii) else {
                return FuzzySearchCharacter(content: String(char), normalisedContent: String(char))
            }

            return FuzzySearchCharacter(content: String(char), normalisedContent: normalisedCharacter)
        }
    }
}
