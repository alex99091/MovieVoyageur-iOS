//
//  MovieSearchByNationViewModel.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/03.
//

import Foundation
import RxSwift
import RxCocoa

class MovieSearchByNationViewModel {

    let movieList: Driver<[MovieItem]>
    let nation: String = "US"
    private let disposeBag = DisposeBag()
    
    init() {
        let apiResponse = MovieAPI.searchbyNation(nation: nation)
            .share()
            .observe(on: MainScheduler.instance)

        let errorObservable = apiResponse
            .filter { result in
                if case .failure = result { return true }
                return false
            }
            .map { result -> Error? in
                switch result {
                case .failure(let error):
                    return error
                default:
                    return nil
                }
            }

        errorObservable
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { error in
                print("API Error: \(error)")
            })
            .disposed(by: disposeBag)

        movieList = apiResponse
            .compactMap { result -> [MovieItem]? in
                if case .success(let response) = result {
                    return response.items
                }
                return nil
            }
            .asDriver(onErrorJustReturn: [])
    }

}

//class MovieSearchByNationViewModel {
//
//    let movieList: Driver<[MovieItem]>
//    private let disposeBag = DisposeBag()
//
//    init(nation: String) {
//        movieList = Observable.just([])
//            .concat(fetchSearchByNation(nation: nation))
//            .asDriver(onErrorJustReturn: [])
//    }
//
//    func fetchSearchByNation(nation: String) -> Observable<[MovieItem]> {
//        return MovieAPI.searchbyNation(nation: nation)
//            .map { result -> [MovieItem] in
//                if case .success(let response) = result {
//                    return response.items
//                } else {
//                    throw APIError.invalidResponse
//                }
//            }
//            .asObservable()
//            .observe(on: MainScheduler.instance)
//            .catchAndReturn([])
//    }
//
//}
//
//enum APIError: Error {
//    case invalidResponse
//}
