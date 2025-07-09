//
//  ExchangeRateResponse.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let result: String // API 호출 결과
    let base_code: String // 기준 통화 코드
    let rates: [String: Double] // 통화 코드별 환율 딕셔너리
}
