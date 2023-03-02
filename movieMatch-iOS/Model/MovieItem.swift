//
//  MovieItem.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import Foundation

struct MovieItem: Codable {
    let title: String?
    let link: String?
    let image: String?
    let subtitle, pubDate, director, actor: String?
    let userRating: String?
}

// Generic

struct BaseResponse<T: Codable>: Codable {
    let title: String?
    let link: String?
    let image: String?
    let subtitle, pubDate, director, actor: String?
    let userRating: String?
}
