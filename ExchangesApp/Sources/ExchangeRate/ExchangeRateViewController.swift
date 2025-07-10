//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar() // 검색

    private let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 60
        table.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier) // 셀 등록
        return table
    }()

    private let noResultLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.isHidden = true
    }

    private let viewModel = ExchangeRateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "환율 정보"
        setupUI() // UI 초기 설정
        bindViewModel() // 뷰 모델이랑 바인딩
        viewModel.fetchRates() // 환율 데이터 요청
    }

    private func setupUI() {
        view.backgroundColor = .white
        // title = "환율 정보"

        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noResultLabel)

        titleLabel.text = "환율 정보"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .left

        searchBar.delegate = self
        searchBar.placeholder = "통화 검색"
        searchBar.backgroundImage = UIImage()

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8) // 상단
            make.leading.trailing.equalToSuperview() // 좌우 끝
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom) // 검색바 아래에
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide) // 좌우 하단
        }

        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }

        tableView.dataSource = self // 데이터 소스
        tableView.delegate = self
    }

    private func bindViewModel() {
        // 데이터 업데이트 했을 때 테이블뷰 갱신
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.noResultLabel.isHidden = !self.viewModel.filteredItems.isEmpty
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.identifier, for: indexPath) as? ExchangeRateCell else {
            return UITableViewCell()
        }
        let model = viewModel.filteredItems[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("셀 선택 : \(indexPath.row)")
        let selected = viewModel.filteredItems[indexPath.row]
        let calculatorVC = CalculatorViewController(
            currencyCode: selected.currencyCode,
            countryName: selected.countryName,
            rate: selected.rate
        )
        navigationController?.pushViewController(calculatorVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
