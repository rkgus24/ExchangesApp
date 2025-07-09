//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateViewController: UIViewController {

    private let searchBar = UISearchBar() // 검색

    private let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 60
        table.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier) // 셀 등록
        return table
    }()

    private let viewModel = ExchangeRateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // UI 초기 설정
        bindViewModel() // 뷰 모델이랑 바인딩
        viewModel.fetchRates() // 환율 데이터 요청
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "환율 정보"

        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.delegate = self
        searchBar.placeholder = "통화 코드 또는 국가명 검색"

        searchBar.backgroundImage = UIImage()

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // 상단
            make.leading.trailing.equalToSuperview() // 좌우 끝
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom) // 검색바 아래에
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide) // 좌우 하단
        }

        tableView.dataSource = self // 데이터 소스
    }

    private func bindViewModel() {
        // 데이터 업데이트 했을 때 테이블뷰 갱신
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }

        // 에러 발생 알림
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    // 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }

    // 행에 표시할 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.identifier, for: indexPath) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let model = viewModel.filteredItems[indexPath.row]
        cell.configure(with: model) // 셀에 데이터 전달 UI 업뎃
        return cell
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    // 검색어 변경 했을 때 뷰모델에 필터링
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
}

#Preview {
    ExchangeRateViewController()
}
