//
//  ExchangeRateCell.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit
import SnapKit
import Then

final class ExchangeRateCell: UITableViewCell {
    static let identifier = "ExchangeRateCell"

    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .label
    }

    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.lineBreakMode = .byTruncatingTail
    }

    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .label
        $0.textAlignment = .right // 숫자 우측 정렬
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ExchangeRateDisplayModel) {
        currencyLabel.text = model.currencyCode
        countryLabel.text = model.countryName

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        formatter.groupingSeparator = ""

        if let formatted = formatter.string(from: NSNumber(value: model.rate)) {
            rateLabel.text = formatted
        } else {
            rateLabel.text = String(format: "%.4f", model.rate)
        }
    }

    private func setupLayout() {
        labelStackView.addArrangedSubview(currencyLabel)
        labelStackView.addArrangedSubview(countryLabel)

        contentView.addSubview(labelStackView)
        contentView.addSubview(rateLabel)

        // contentView 높이 제약 조건
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }

        // labelStackView 제약 조건
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        // rateLabel 제약 조건
        rateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
    }
}
