//
//  MovieIdData.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/07.
//

import Foundation

// userDefaults에 저장할 movieIdList목록
struct MovieIdData: Codable {
    var movieIdList: [Int]?
    
    init() {
        movieIdList = []
    }
}
