//
//  PairPickerViewController.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import SnapKit
import UIKit

class CurrencyPickerViewController: UIViewController {
	private lazy var tableView = UITableView()

	var viewModel: CurrencyPickerViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupConstraints()

		bind()
	}

	deinit {
		print("🔥 CurrencyPickerViewController")
	}
}

extension CurrencyPickerViewController: UITableViewDataSource {
	func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		viewModel.currencies.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: CurrencyCell.identifier,
			for: indexPath
		) as? CurrencyCell else {
			assertionFailure("Cannot dequeue reusable cell \(CurrencyCell.self)")
			return UITableViewCell()
		}

		let currency = viewModel.currencies.value[indexPath.row]
		let isSelected = viewModel.selectedCurrencies.value.contains(currency)

		cell.configure(with: currency, isSelected: isSelected)

		return cell
	}
}

extension CurrencyPickerViewController: UITableViewDelegate {
	func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		viewModel.didSelectCurrency(at: index)
	}
}

private extension CurrencyPickerViewController {
	func setupViews() {
		view.backgroundColor = .white
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none

		tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)

		view.addSubview(tableView)
	}

	func setupConstraints() {
		tableView.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}

private extension CurrencyPickerViewController {
	func bind() {
		viewModel.currencies.bind { [unowned self] _ in
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}
