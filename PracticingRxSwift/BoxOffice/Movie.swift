//
//  Movie.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/8/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
