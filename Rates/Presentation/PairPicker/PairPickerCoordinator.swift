//
//  PairPickerCoordinator.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import UIKit

protocol PairPickerCoordinatorDelegate: class {
	func pairSelected(_ pair: CurrencyPair)
}

class PairPickerCoordinator: Coordinator {
	private var dependencies: Dependencies
	private weak var delegate: PairPickerCoordinatorDelegate?
	private unowned var navigation: UINavigationController

	init(
		with navigation: UINavigationController,
		using dependencies: Dependencies,
		and delegate: PairPickerCoordinatorDelegate
	) {
		self.navigation = navigation
		self.dependencies = dependencies
		self.delegate = delegate
		print("🐣 PairPickerCoordinator")
	}

	deinit {
		print("🔥 PairPickerCoordinator")
	}

	func start() {
		let finalCallback: ([Currency]) -> Void = { [unowned self] selected in
			guard selected.count >= 2 else {
				fatalError("selected for finalCallback should never be less than 2")
			}
			let pair = CurrencyPair(
				source: selected[0],
				target: selected[1]
			)
			delegate?.pairSelected(pair)
		}

		makeAndPushViewController { [unowned self] selected in
			makeAndPushViewController(with: finalCallback, using: selected)
		}
	}

	func makeAndPushViewController(
		with callback: @escaping ([Currency]) -> Void,
		using selected: [Currency] = []
	) {
		let controller = CurrencyPickerViewController()

		controller.keepAlive(self)

		controller.viewModel = DefaultCurrencyPickerViewModel(
			getCurrenciesUseCase: dependencies.makeGetCurrenciesUseCase(),
			selectedCurrencies: selected,
			proceesdWithSelected: callback
		)

		navigation.pushViewController(controller, animated: true)
	}
}
