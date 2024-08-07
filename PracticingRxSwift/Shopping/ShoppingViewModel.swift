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
    private let disposeBag = DisposeBag()
    
    private let items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(bought: false, wantToBuy: "에어팟 맥스", favorite: true),
        ShoppingItem(bought: false, wantToBuy: "아이폰16Pro 1TB", favorite: false),
        ShoppingItem(bought: true, wantToBuy: "애플워치 신형", favorite: true),
        ShoppingItem(bought: true, wantToBuy: "모니터", favorite: false)
    ])
    
    private var recentList = BehaviorRelay<[String]>(value: ["Xcode 버그 없애기", "과제 끝내기", "힘내기", "할수있다🍀"])
    
    struct Input {
        let addButtonTapped: Observable<Void>
        let newItem: Observable<String>
        let checkButtonTapped: Observable<Int>
        let favoriteButtonTapped: Observable<Int>
        let collectionViewItemSelected: Observable<String>
    }
    
    struct Output {
        let items: Driver<[ShoppingItem]>
        let recentList: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        input.collectionViewItemSelected
            .withLatestFrom(items) { (selectedItem, currentItems) in
                    currentItems + [ShoppingItem(bought: false, wantToBuy: selectedItem, favorite: false)]
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .withLatestFrom(input.newItem)
            .filter { !$0.isEmpty }
            .map { ShoppingItem(bought: false, wantToBuy: $0, favorite: false)}
            .withLatestFrom(items) { (newItem, currentItems) in
                currentItems + [newItem]
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        input.checkButtonTapped
            .withLatestFrom(items) { ($0, $1) }
            .map { (index, items) -> [ShoppingItem] in
                var updatedItems = items
                updatedItems[index].bought.toggle()
                return updatedItems
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        input.favoriteButtonTapped
            .withLatestFrom(items) { ($0, $1) }
            .map { (index, items) -> [ShoppingItem] in
                var updatedItems = items
                updatedItems[index].favorite.toggle()
                return updatedItems
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return Output(items: items.asDriver(), recentList: recentList)
    }
}
