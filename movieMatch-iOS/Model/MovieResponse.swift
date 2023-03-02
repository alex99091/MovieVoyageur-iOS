//
//  MovieResponse.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import Foundation

struct MovieResponse: Codable {
    let lastBuildDate: String?
    let total, start, display: Int?
    let items: [MovieItem]
}

// Generic
struct MovieListResponse<T: Codable>: Codable {
    let lastBuildDate: String?
    let total, start, display: Int?
    let items: [T]
}
