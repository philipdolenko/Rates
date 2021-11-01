//
//  RatesViewController.swift
//  CurrencyRates
//

//

import SnapKit
import UIKit

class RatesViewController: UIViewController {
	private lazy var tableView = UITableView()
	private lazy var addPairButton = UIButton()
	private lazy var addPairLabel = UILabel()
	private lazy var plusImageView = UIImageView()

	private var isFirstTableViewUpdate = true

	var viewModel: RatesViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupHierarchy()
		setupConstraints()

		bind()

		viewModel.viewDidLoad()
	}

	@objc func addPairClicked() {
		viewModel.addNewPairClicked()
	}
}

extension RatesViewController: UITableViewDelegate {
	func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
		true
	}

	func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }

		viewModel.removePair(at: indexPath.row)
	}
}

extension RatesViewController: UITableViewDataSource {
	func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		viewModel.rates.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: RateCell.identifier,
			for: indexPath
		) as? RateCell else {
			assertionFailure("Cannot dequeue reusable cell \(RateCell.self)")
			return UITableViewCell()
		}

		let rate = viewModel.rates.value[indexPath.row]
		cell.configure(with: rate)

		return cell
	}
}

private extension RatesViewController {
	func setupViews() {
		view.backgroundColor = .white
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.register(RateCell.self, forCellReuseIdentifier: RateCell.identifier)
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension

		plusImageView.image = UIImage(named: "Plus")
		addPairLabel.text = "Add currency pair"
		addPairLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
		addPairLabel.textColor = UIColor(named: "accentColor") ?? .black
	}

	func setupHierarchy() {
		view.addSubview(tableView)
		view.addSubview(addPairButton)
		addPairButton.addSubview(addPairLabel)
		addPairButton.addSubview(plusImageView)
	}

	func setupConstraints() {
		addPairButton.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
			make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
			make.height.equalTo(72)
		}

		plusImageView.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(15)
			make.centerY.equalToSuperview()
			make.size.equalTo(40)
		}

		addPairLabel.snp.makeConstraints { make in
			make.left.equalTo(plusImageView.snp.right).offset(17)
			make.centerY.equalToSuperview()
			make.height.equalTo(24)
		}

		tableView.snp.makeConstraints { make in
			make.top.equalTo(addPairButton.snp.bottom)
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}

private extension RatesViewController {
	func bind() {
		addPairButton.addTarget(self, action: #selector(addPairClicked), for: .touchUpInside)

		viewModel.ratesActions.bind { [unowned self] action in
			if case .insert(let index) = action {
				tableView.beginUpdates()
				tableView.insertRows(
					at: [.init(row: index, section: 0)],
					with: .top
				)
				tableView.endUpdates()
			} else if case .remove(let index) = action {
				tableView.beginUpdates()
				tableView.deleteRows(
					at: [.init(row: index, section: 0)],
					with: .left
				)
				tableView.endUpdates()
			}
		}

		viewModel.rates.bind { [unowned self] rates in
			DispatchQueue.main.async {
				if isFirstTableViewUpdate {
					tableView.reloadData()
					isFirstTableViewUpdate = false
				} else {
					reconfigureCells(using: rates)
				}
			}
		}
	}

	func reconfigureCells(using rates: [CurrencyRate]) {
		for (row, rate) in rates.enumerated() {
			if let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? RateCell {
				cell.configure(with: rate)
			}
		}
	}
}
