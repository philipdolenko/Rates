//
//  RateCell.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 30.03.2021.
//

import SnapKit
import UIKit

class RateCell: UITableViewCell {
	static let identifier = "RateCell"

	private lazy var sourceCodeLabel = UILabel()
	private lazy var sourceNameLabel = UILabel()
	private lazy var rateLabel = UILabel()
	private lazy var targetLabel = UILabel()

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	func configure(with rate: CurrencyRate) {
		updateRateLabel(with: rate.rate + Double.random(in: 0...0.009))
		sourceCodeLabel.text = "1 \(rate.pair.source.code)"
		sourceNameLabel.text = String(rate.pair.source.name)
		targetLabel.text = "\(rate.pair.target.name) \(rate.pair.target.code)"
	}

	func commonInit() {
		setupViews()
		setupHierarchy()
		setupConstraints()
	}

	func setupViews() {
		applyPrimaryStyle(for: rateLabel)
		applyPrimaryStyle(for: sourceCodeLabel)
		applySecondaryStyle(for: sourceNameLabel)
		applySecondaryStyle(for: targetLabel)
	}

	func setupHierarchy() {
		contentView.addSubview(sourceCodeLabel)
		contentView.addSubview(sourceNameLabel)
		contentView.addSubview(rateLabel)
		contentView.addSubview(targetLabel)
	}

	func setupConstraints() {
		sourceCodeLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.left.equalToSuperview().offset(16)
			make.height.equalTo(28)
		}
		sourceNameLabel.snp.makeConstraints { make in
			make.top.equalTo(sourceCodeLabel.snp.bottom)
			make.left.equalToSuperview().offset(16)
			make.height.equalTo(20)
			make.bottom.equalToSuperview().offset(-16).priority(999)
		}
		rateLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
			make.height.equalTo(28)
		}
		targetLabel.snp.makeConstraints { make in
			make.top.equalTo(rateLabel.snp.bottom)
			make.right.equalToSuperview().offset(-16)
			make.height.equalTo(20)
			make.bottom.equalToSuperview().offset(-16).priority(999)
		}
	}

	private func applyPrimaryStyle(for label: UILabel) {
		label.textColor = UIColor(named: "black") ?? .black
		label.font = .systemFont(ofSize: 20.0, weight: .medium)
	}

	private func applySecondaryStyle(for label: UILabel) {
		label.textColor = UIColor(named: "gray") ?? .gray
		label.font = .systemFont(ofSize: 14.0, weight: .regular)
	}
}

extension RateCell {
	func updateRateLabel(with rate: Double) {
		let whole = modf(rate).0
		let fraction = modf(rate).1

		let bigDigitsCount = 2
		var smallDigitsCount = 2
		var digitsAfterDotCount: Int { bigDigitsCount + smallDigitsCount }

		let redurentPartSize = "0.".count

		handleTinyRates(
			rate: rate,
			smallDigitsCount: &smallDigitsCount,
			bigDigitsCount: bigDigitsCount,
			redurentPartSize: redurentPartSize
		)
		let wholePart = String(
			format: "%.0f",
			whole
		)
		let fractionPart = String(
			format: "%.\(digitsAfterDotCount)f",
			fraction
		).dropFirst(redurentPartSize)

		let rateString = "\(wholePart).\(fractionPart)"
		let attrString = NSAttributedString(string: rateString)

		rateLabel.attributedText = attrString

		guard let start = rateString.index(
			rateString.endIndex,
			offsetBy: -smallDigitsCount,
			limitedBy: rateString.startIndex
		) else { return }

		let mutableAttributedString = NSMutableAttributedString(attributedString: attrString)
		mutableAttributedString.addAttributes(
			[NSAttributedString.Key.font: rateLabel.font.withSize(14)],
			range: .init(start ..< rateString.endIndex, in: rateString)
		)
		rateLabel.attributedText = mutableAttributedString
		rateLabel.sizeToFit()
	}

	// TODO:
	// Ask product manager if a rate can be lower than 0.00005
	// if yes keep as it as is if not => remove this method
	private func handleTinyRates(
		rate: Double,
		smallDigitsCount: inout Int,
		bigDigitsCount: Int,
		redurentPartSize: Int
	) {
		let fractionString = String(format: "%.32f", rate)

		if let i = fractionString.firstIndex(where: { $0 != "0" && $0 != "." }) {
			let firstNonZeroIndex: Int = fractionString.distance(from: fractionString.startIndex, to: i)
			let firstNonZeroIndexOneBased = firstNonZeroIndex + 1
			let newSmallDigitsCount = firstNonZeroIndexOneBased - redurentPartSize - bigDigitsCount

			if newSmallDigitsCount > smallDigitsCount {
				smallDigitsCount = newSmallDigitsCount
			}
		}
	}
}
