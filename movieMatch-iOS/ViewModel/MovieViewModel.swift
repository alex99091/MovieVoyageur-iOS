//
//  MovieViewModel.swift
//  movieMatch-iOS
//
//  Created by BOONGKI KWAK on 2023/03/02.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    let movieList: Driver<[MovieItem]>
    private let disposeBag = DisposeBag()
    
    init() {
        let apiResponse = MovieAPI.fetchAPIResponse()
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
