//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ExchangeRateViewController: UIViewController {
    private let viewModel = ExchangeRateViewModel()
    private let disposeBag = DisposeBag()

    private let tableView = UITableView().then {
        $0.rowHeight = 60
        $0.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier) // 셀 등록
    }

    private let titleLabel = UILabel().then {
        $0.text = "환율 정보"
        $0.font = .systemFont(ofSize: 36, weight: .bold)
        $0.textAlignment = .left
    }
    private let searchBar = UISearchBar().then { // 검색
        $0.placeholder = "통화 검색"
        $0.backgroundImage = UIImage()
    }

    private let noResultLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
        $0.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "환율 정보"
        setupUI() // UI 초기 설정
        bindViewModel() // 뷰 모델이랑 바인딩
        viewModel.fetchRates() // 환율 데이터 요청
        bindSearchBar()
    }

    private func setupUI() {
        view.backgroundColor = .white
        [titleLabel, searchBar, tableView, noResultLabel].forEach { view.addSubview($0) }

        tableView.backgroundView = noResultLabel
        tableView.dataSource = self
        tableView.delegate = self

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8) // 상단
            $0.leading.trailing.equalToSuperview() // 좌우 끝
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom) // 검색바 아래에
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide) // 좌우 하단
        }
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

    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.search(query: query)
            })
            .disposed(by: disposeBag)
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

        cell.onFavoriteToggle = { [weak self] in
            self?.viewModel.toggleFavorite(for: indexPath.row)
        }
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

#Preview {
    ExchangeRateViewController()
}
