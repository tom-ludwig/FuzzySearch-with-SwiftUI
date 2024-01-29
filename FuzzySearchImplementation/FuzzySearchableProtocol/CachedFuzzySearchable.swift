//
//  CachedFuzzySearchable.swift
//  FuzzySearchImplementation
//
//  Created by Tommy Ludwig on 29.01.24.
//

import Foundation

struct CachedFuzzySearchable<T>: FuzzySearchable where T: FuzzySearchable {
    let wrappedSearchable: T
    let fuzzySearchCache: FuzzyCache

    init(wrapping searchable: T) {
        self.wrappedSearchable = searchable
        self.fuzzySearchCache = FuzzyCache()
    }

    public var searchableString: String {
        return wrappedSearchable.searchableString
    }

    func tokenizeString() -> FuzzySearchString {
        if fuzzySearchCache.hash == nil || fuzzySearchCache.hash != searchableString.hashValue {
            let characters = searchableString.normalise()
            fuzzySearchCache.hash = searchableString.hashValue
            fuzzySearchCache.lastTokenization = FuzzySearchString(characters: characters)
        }

        return fuzzySearchCache.lastTokenization
    }
}
