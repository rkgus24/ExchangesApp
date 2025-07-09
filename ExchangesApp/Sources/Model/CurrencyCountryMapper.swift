//
//  CurrencyCountryMapper.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/9/25.
//

import Foundation

// 통화 코드를 국가명으로 매핑하는 싱글턴 클래스
final class CurrencyCountryMapper {
    // 전역에서 접근 가능한 싱글턴 인스턴스
    static let shared = CurrencyCountryMapper()

    // 통화 코드 -> 국가 이름 매핑 딕셔너리
    private(set) var mapping: [String: String] = [:]

    // 생성자에서 매핑 로딩
    private init() {
        loadMapping()
    }

    // currencies.json 파일 읽고 매핑 딕셔너리에 저장
    private func loadMapping() {
        guard let url = Bundle.main.url(forResource: "currencies", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode([String: String].self, from: data) else {
            print("❌ currencies.json 불러오기 실패")
            return
        }
        mapping = result
    }

    // 통화 코드에 해당하는 국가명 반환
    func country(for currencyCode: String) -> String {
        return mapping[currencyCode] ?? "알 수 없음"
    }
}
