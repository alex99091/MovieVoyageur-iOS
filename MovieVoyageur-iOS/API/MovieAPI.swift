//
//  MovieAPI.swift
//  MovieVoyageur-iOS
//
//  Created by BOONGKI KWAK on 2023/03/06.
//

import Foundation
import RxSwift
import RxCocoa

enum MovieAPI {
    static let baseUrl = "https://api.themoviedb.org/3/movie"
    static let baseSearchUrl = "https://api.themoviedb.org/3/search/movie"
    static let baseGenreUrl = "https://api.themoviedb.org/3/discover/movie"
    static let supportingUrl = "&language=en-US&page=1"
        
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
    // 곧 개봉할 영화 목록받기
    static func fetchUpcoming() -> Observable<Result<MovieListResponse<MovieDate, MovieResult>, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        let query = "/upcoming"
        let apiString = "?api_key=" + apiKey
        let urlString = baseUrl + query + apiString + supportingUrl
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponse<MovieDate, MovieResult>.self, from: data)
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
    
    // 현재 상영중인 영화목록받기
    static func fetchNowPlaying() -> Observable<Result<MovieListResponse<MovieDate, MovieResult>, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        let query = "/now_playing"
        let apiString = "?api_key=" + apiKey
        let urlString = baseUrl + query + apiString + supportingUrl
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponse<MovieDate, MovieResult>.self, from: data)
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
    
    // 가장인기있는 영화목록받기
    static func fetchPopular() -> Observable<Result<MovieListResponseWithoutDate<MovieResult>, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        let query = "/popular"
        let apiString = "?api_key=" + apiKey
        let urlString = baseUrl + query + apiString + supportingUrl
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponseWithoutDate<MovieResult>.self, from: data)
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
    
    // 가장평점높은 영화목록받기
    static func fetchTopRated() -> Observable<Result<MovieListResponseWithoutDate<MovieResult>, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        let query = "/top_rated"
        let apiString = "?api_key=" + apiKey
        let urlString = baseUrl + query + apiString + supportingUrl
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieListResponseWithoutDate<MovieResult>.self, from: data)
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
    
    // 영화 디테일보기
    static func fetchMovieDetail(_ movieId: Int) -> Observable<Result<MovieDetail, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        
        let query = "/\(movieId)"
        let apiString = "?api_key=" + apiKey
        let urlString = baseUrl + query + apiString + supportingUrl
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieDetail.self, from: data)
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
    
    // 영화 검색하기
    static func searchMovie(_ searchTerm: String) -> Observable<Result<MovieSearchTerm, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        
        let apiString = "?api_key=" + apiKey
        let query = "&query=\(searchTerm)"
        let urlString = baseSearchUrl + apiString + query
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieSearchTerm.self, from: data)
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
    
    // 장르로 영화 리스트가져오기
    static func fetchByGenre(_ genreId: Int) -> Observable<Result<MovieSearchTerm, ApiError>> {
        
        guard let apiKey: String = Bundle.main.APIKey else { return Observable.just(Result.failure(.unAuthorizedKey)) }
        
        let apiString = "?api_key=" + apiKey
        let extraUrl = "&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&primary_release_date.gte=1990-01-01&primary_release_date.lte=1999-12-31&vote_average.gte=6"
        let query = "&with_genres=\(genreId)"
        let urlString = baseGenreUrl + apiString + extraUrl + query
        
        guard let completedUrl = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: completedUrl)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { response, data in
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieSearchTerm.self, from: data)
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

