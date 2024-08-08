//
//  BoxOfficeViewModel.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let movieList: Observable<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print("뷰모델 서차바 텍스트 인식: \(value)")
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged() // 같은 검색어 검색 방지
            .map {
                guard let intText = Int($0) else {
                    return 20240701
                }
                return intText
            }
            .map { return "\($0)" }
            .flatMap { value in
                NetworkManager.shared.callBoxOffice(date: value)
            }
            .subscribe(with: self) { owner, movie in
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            }
            .disposed(by: disposeBag)
        

        return Output(movieList: boxOfficeList)
    }
    
    
}
