//
//  MovieResponse.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import Foundation
// MARK: - MovieResponse
struct MovieResponse: Codable {
    let dates: MovieDate?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// Generic
struct MovieListResponse<T: Codable, U: Codable>: Codable {
    let dates: T?
    let page: Int?
    let results: [U]?
    let totalPages, totalResults: Int?
    
    init(dates: T? = nil, page: Int? = nil, results: [U]? = nil, totalPages: Int? = nil, totalResults: Int? = nil) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// Generic
struct MovieListResponseWithoutDate<T: Codable>: Codable {
    let page: Int?
    let results: [T]?
    let totalPages, totalResults: Int?
    
    init(page: Int? = nil, results: [T]? = nil, totalPages: Int? = nil, totalResults: Int? = nil) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Dates
struct MovieDate: Codable {
    let maximum, minimum: String?
}

