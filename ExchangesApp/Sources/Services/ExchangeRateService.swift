//
//  ExchangeRateService.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

final class ExchangeRateService {
    // 기준 통화로 환율 데이터 받기
    func fetchRates(base: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        let urlString = "https://open.er-api.com/v6/latest/\(base)"
        print("호출 URL : \(urlString)")

        // URL 객체 생성 실패했을 때 에러 반환
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        // 비동기 데이터 요청
        URLSession.shared.dataTask(with: url) { data, response, error in

            // 네트워크 오류
            if let error = error {
                completion(.failure(error))
                return
            }

            // 응답 데이터 없을 때
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                // JSON 디코딩
                let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                completion(.success(decoded.rates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
