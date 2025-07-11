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

    // 생성자 : 통화 정보 전달받음
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
        view.backgroundColor = .systemBackground
        setupUI()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        titleLabel.text = "환율 계산기"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label

        // 상단 통화/국가 레이블 스택
        let labelStack = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.alignment = .center

        // 레이블 세팅
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currencyLabel.text = currencyCode
        currencyLabel.textColor = .label

        countryLabel.font = .systemFont(ofSize: 16)
        countryLabel.textColor = .secondaryLabel
        countryLabel.text = countryName

        // 입력창 세팅
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.placeholder = "달러(USD)를 입력하세요"
        amountTextField.backgroundColor = .secondarySystemBackground
        amountTextField.textColor = .label

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
        resultLabel.textColor = .label

        [titleLabel, labelStack, amountTextField, convertButton, resultLabel].forEach {
            view .addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        // AutoLayout
        labelStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    @objc private func convertTapped() {
        guard let text = amountTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "금액을 입력해주세요")
            return
        }

        guard let amount = Double(text) else {
            showAlert(message: "올바른 숫자를 입력해주세요")
            return
        }

        let converted = amount * rate
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if  let formattedAmount = formatter.string(from: NSNumber(value: amount)),
            let formattedConverted = formatter.string(from: NSNumber(value: converted)) {
            resultLabel.text = "$\(formattedAmount) → \(formattedConverted) \(currencyCode)"
        } else {
            resultLabel.text = "계산 실패"
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert,animated: true)
    }
}

#Preview {
    CalculatorViewController(
        currencyCode: "AOA",
        countryName: "앙골라",
        rate: 920.8643
    )
}
