//
//  MovieAPI.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import Foundation
import RxSwift
import RxCocoa

enum MovieAPI {
    static let baseUrl = "https://openapi.naver.com/v1/search/movie.json"
    
    enum ApiError: Error {
        case invalidURL
        case unAuthorizedKey
        case decodingError
        case networkError
        case unknownError(_ error: Error?)
        
        var info: String {
            switch self {
            case .invalidURL: return "잘못된 URL입니다"
            case .unAuthorizedKey: return "인증키가 유효하지 않습니다."
            case .decodingError: return "Decoding 에러입니다."
            case .networkError: return "네트워크 에러입니다."
            case .unknownError(let error): return "알수 없는 에러: \(String(describing: error))입니다."
            }
        }
    }
}

extension MovieAPI {
    
    // 국가별로 영화 검색하기
    static func searchbyNation(nation: String) -> Observable<Result<MovieListResponse<MovieItem>, ApiError>> {
        
        let query =  "query=%EC%A3%BC%EC%8B%9D&display=10&start=1&country=\(nation)"
        let urlString = baseUrl + "?" + query
        
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        guard let clientId: String = Bundle.main.clientId,
              let clientSecret: String = Bundle.main.clientSecret else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        urlRequest.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponse<MovieItem>.self, from: data)
                        return .success(result)
                    } catch {
                        return .failure(ApiError.decodingError)
                    }
                } else if response.statusCode == 401 {
                    return .failure(ApiError.unAuthorizedKey)
                } else {
                    return .failure(ApiError.networkError)
                }
            }
            .catch { error in
                return Observable.just(.failure(ApiError.unknownError(error)))
            }
    }
    
    // 장르로 영화 검색하기
    static func searchbyGenre(genre: String) -> Observable<Result<MovieListResponse<MovieItem>, ApiError>> {
        
        let query =  "query=%EC%A3%BC%EC%8B%9D&display=10&start=1&genre=\(genre)"
        let urlString = baseUrl + "?" + query
        
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        guard let clientId: String = Bundle.main.clientId,
              let clientSecret: String = Bundle.main.clientSecret else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        urlRequest.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponse<MovieItem>.self, from: data)
                        return .success(result)
                    } catch {
                        return .failure(ApiError.decodingError)
                    }
                } else if response.statusCode == 401 {
                    return .failure(ApiError.unAuthorizedKey)
                } else {
                    return .failure(ApiError.networkError)
                }
            }
            .catch { error in
                return Observable.just(.failure(ApiError.unknownError(error)))
            }
    }
    
    
}
