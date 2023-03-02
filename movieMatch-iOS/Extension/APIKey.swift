//
//  APIKey.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import Foundation

extension Bundle {
    
    var clientId: String? {
        guard let file = self.path(forResource: "ClientId", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["X-Naver-Client-Id"] as? String else{ return "" }
        return key
    }
    
    var clientSecret: String? {
        guard let file = self.path(forResource: "ClientSecret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["X-Naver-Client-Secret"] as? String else{ return "" }
        return key
    }
    
}
