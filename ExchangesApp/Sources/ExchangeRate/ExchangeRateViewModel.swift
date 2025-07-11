//
//  ExchangeRateViewModel.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

final class ExchangeRateViewModel {
    private let service = ExchangeRateService() // 환율 API
    private var allItems: [ExchangeRateDisplayModel] = [] // 전체 환율

    var filteredItems: [ExchangeRateDisplayModel] = [] // 검색 하고 필터링 된 거

    var onUpdate: (() -> Void)? // 데이터 갱신 했을 때 호출
    var onError: ((String) -> Void)? // 에러 발생했을 때 호출

    private var currentQuery: String = ""

    func fetchRates(base: String = "USD") {
        service.fetchRates(base: base) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dict):
                    let favorites = Set(CoreDataManager.shared.getAllFavorites())
                    // 통화 코드에 맞는 국가명 매핑
                    let mapper = CurrencyCountryMapper.shared

                    // 딕셔너리 -> 모델 배열로 , 통화코드 기준으로 정렬
                    let models = dict.map { (code, rate) in
                        ExchangeRateDisplayModel(
                            currencyCode: code,
                            countryName: mapper.country(for: code), // 국가명
                            rate: rate,
                            isFavorite: favorites.contains(code)
                        )
                    }.sorted { $0.currencyCode < $1.currencyCode }

                    self?.allItems = models
                    self?.applyFilter(query: self?.currentQuery ?? "")

                case .failure:
                    self?.onError?("데이터를 불러올 수 없습니다")
                }
            }
        }
    }

    // 검색어 기반 환율 데이터 필터링
    func search(query: String) {
        currentQuery = query
        applyFilter(query: query)
    }

    func toggleFavorite(for index: Int) {
        var model = filteredItems[index]
        model.isFavorite.toggle()

        if model.isFavorite {
            CoreDataManager.shared.addFavorite(code: model.currencyCode)
        } else {
            CoreDataManager.shared.removeFavorite(code: model.currencyCode)
        }
        if let allIndex = allItems.firstIndex(where: { $0.currencyCode == model.currencyCode }) {
            allItems[allIndex] = model
        }

        applyFilter(query: currentQuery)
    }

    private func applyFilter(query: String) {
        let lower = query.lowercased()

        filteredItems = allItems.filter {
            query.isEmpty ||
            $0.currencyCode.lowercased().contains(lower) ||
            $0.countryName.lowercased().contains(lower)
        }
        .sorted {
            if $0.isFavorite == $1.isFavorite {
                return $0.currencyCode < $1.currencyCode
            }
            return $0.isFavorite && !$1.isFavorite
        }

        onUpdate?()
    }
}

