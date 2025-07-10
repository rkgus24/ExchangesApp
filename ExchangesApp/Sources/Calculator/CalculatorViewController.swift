//
//  CalculatorViewController.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/9/25.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController {

    private let currencyLabel = UILabel()
    private let countryLabel = UILabel()
    private let amountTextField = UITextField()
    private let convertButton = UIButton(type: .system)
    private let resultLabel = UILabel()

    private let currencyCode: String
    private let countryName: String
    private let rate: Double

    private let titleLabel = UILabel()

    // 생성자: 통화 정보 전달받음
    init(currencyCode: String, countryName: String, rate: Double) {
        self.currencyCode = currencyCode
        self.countryName = countryName
        self.rate = rate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // title = "환율 계산기"
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "환율 계산기"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .left

        // 상단 통화/국가 레이블 스택
        let labelStack = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.alignment = .center

        // 레이블 세팅
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currencyLabel.text = currencyCode

        countryLabel.font = .systemFont(ofSize: 16)
        countryLabel.textColor = .gray
        countryLabel.text = countryName

        // 입력창 세팅
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.placeholder = "금액을 입력하세요"

        // 버튼 세팅
        convertButton.backgroundColor = .systemBlue
        convertButton.setTitle("환율 계산", for: .normal)
        convertButton.setTitleColor(.white, for: .normal)
        convertButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        convertButton.layer.cornerRadius = 8
        convertButton.addTarget(self, action: #selector(convertTapped), for: .touchUpInside)

        // 결과 레이블
        resultLabel.font = .systemFont(ofSize: 20, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.text = "계산 결과가 여기에 표시됩니다"

        // View에 추가
        view.addSubview(titleLabel)
        view.addSubview(labelStack)
        view.addSubview(amountTextField)
        view.addSubview(convertButton)
        view.addSubview(resultLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        // AutoLayout
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    @objc private func convertTapped() {
        guard let text = amountTextField.text, let amount = Double(text) else {
            resultLabel.text = "금액을 입력해주세요"
            return
        }

        let converted = amount * rate

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        if let formatted = formatter.string(from: NSNumber(value: converted)) {
            resultLabel.text = "환산 금액 : \(formatted) \(currencyCode)"
        } else {
            resultLabel.text = "계산 실패"
        }
    }
}

#Preview {
    CalculatorViewController(
        currencyCode: "AOA",
        countryName: "앙골라",
        rate: 920.8643
    )
}
