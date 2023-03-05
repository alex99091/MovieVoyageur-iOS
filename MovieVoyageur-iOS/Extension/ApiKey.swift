//
//  ApiKey.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import Foundation

extension Bundle {
    
    var APIKey: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else { return nil }
        
        return key
    }
    
}
