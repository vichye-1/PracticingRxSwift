//
//  ShoppingViewModel.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    struct Input {
        let addButtonTapped: Observable<Void>
        let newItem: Observable<String>
        let checkButtonTapped: Observable<Int>
        let favoriteButtonTapped: Observable<Int>
    }
    
    struct Output {
        let items: Driver<[ShoppingItem]>
    }
    
    private let disposeBag = DisposeBag()
    
    private let items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(bought: false, wantToBuy: "에어팟 맥스", favorite: true),
        ShoppingItem(bought: false, wantToBuy: "아이폰16Pro 1TB", favorite: false),
        ShoppingItem(bought: true, wantToBuy: "애플워치 신형", favorite: true),
        ShoppingItem(bought: true, wantToBuy: "모니터", favorite: false)
    ])
    
    func transform(input: Input) -> Output {
        
        input.addButtonTapped
            .withLatestFrom(input.newItem)
            .filter { !$0.isEmpty }
            .map { ShoppingItem(bought: false, wantToBuy: $0, favorite: false)}
            .withLatestFrom(items) { (newItem, currentItems) in
                currentItems + [newItem]
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return Output(items: items.asDriver())
    }
}
