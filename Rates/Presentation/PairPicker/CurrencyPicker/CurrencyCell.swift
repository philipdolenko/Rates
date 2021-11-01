//
//  CurrencyCell.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 30.03.2021.
//

import SnapKit
import UIKit

class CurrencyCell: UITableViewCell {
	static let identifier = "CurrencyCell"

	private lazy var codeLabel = UILabel()
	private lazy var nameLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	func commonInit() {
		setupViews()
		setupHierarchy()
		setupConstraints()
	}

	func configure(with currency: Currency, isSelected: Bool) {
		codeLabel.text = currency.code
		nameLabel.text = currency.name

		isUserInteractionEnabled = !isSelected
		contentView.alpha = isSelected ? 0.5 : 1
	}

	func setupViews() {
		codeLabel.font = .systemFont(ofSize: 16)
		codeLabel.textColor = UIColor(named: "gray") ?? .gray
		nameLabel.font = .systemFont(ofSize: 16)
		nameLabel.textColor = UIColor(named: "black") ?? .black
		nameLabel.textAlignment = .left
	}

	func setupHierarchy() {
		contentView.addSubview(codeLabel)
		contentView.addSubview(nameLabel)
	}

	func setupConstraints() {
		let codeLabelWidth = 28 + 21
		codeLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.left.equalToSuperview().offset(16)
			make.bottom.equalToSuperview().offset(-16)
			make.height.equalTo(24)
			make.width.equalTo(codeLabelWidth)
		}
		nameLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.left.equalTo(codeLabel.snp.right)
			make.right.equalToSuperview().offset(-16)
			make.bottom.equalToSuperview().offset(-16)
			make.height.equalTo(24)
		}
	}
}
