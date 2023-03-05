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

// MARK: - Result
struct MovieResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
