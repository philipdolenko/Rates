//
//  RatesCoordinator.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 28.03.2021.
//

import UIKit

class RatesCoordinator: Coordinator, PairPickerCoordinatorDelegate, RatesViewModelDelegate {
	private var dependencies: Dependencies
	private weak var controller: RatesViewController?
	private weak var viewModel: RatesViewModel?
	private unowned var navigation: UINavigationController

	init(with navigation: UINavigationController, using dependencies: Dependencies) {
		self.navigation = navigation
		self.dependencies = dependencies
		print("🐣 RatesCoordinator")
	}

	deinit {
		print("🔥 RatesCoordinator")
	}

	func start() {
		let controller = RatesViewController()
		controller.keepAlive(self)

		let viewModel = DefaultRatesViewModel
			.init(
				updateRatesUseCase: dependencies.makeUpdateRatesUseCase(),
				fetchSavedPairsUseCase: dependencies.makeFetchSavedPairsUseCase(),
				savePairUseCase: dependencies.makeSavePairUseCase(),
				delegate: self
			)
		controller.viewModel = viewModel

		navigation.pushViewController(controller, animated: false)

		self.controller = controller
		self.viewModel = viewModel
	}

	func showAddNewPairFlow() {
		let pairPickerCoordinator = PairPickerCoordinator(
			with: navigation,
			using: dependencies,
			and: self
		)
		pairPickerCoordinator.start()
	}

	func pairSelected(_ pair: CurrencyPair) {
		if let controller = self.controller {
			viewModel?.pairWasPicked(pair)
			navigation.popToViewController(controller, animated: true)
		}
	}
}
