//
//  RatesViewModel.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 27.03.2021.
//

import Foundation

protocol RatesViewModelInput {
	func addNewPairClicked()
	func removePair(at index: Int)
	func viewDidLoad()
	func pairWasPicked(_ pair: CurrencyPair)
}

protocol RatesViewModelOutput {
	var rates: Dynamic<[CurrencyRate]> { get }
	var ratesActions: Dynamic<DataAction?> { get }
	var ratesVisible: Dynamic<Bool> { get }
	var delegate: RatesViewModelDelegate? { get }
}

protocol RatesViewModelDelegate: class {
	func showAddNewPairFlow()
}

protocol RatesViewModel: class, RatesViewModelInput, RatesViewModelOutput {}

class DefaultRatesViewModel: RatesViewModel {
	var rates: Dynamic<[CurrencyRate]> = .init([])
	var ratesActions: Dynamic<DataAction?>
	var ratesVisible: Dynamic<Bool>
	weak var delegate: RatesViewModelDelegate?

	private let updateRatesUseCase: UpdateRatesUseCase
	private let fetchSavedPairsUseCase: FetchSavedPairsUseCase
	private let savePairUseCase: SavePairsUseCase

	private var pairs: [CurrencyPair]

	private var timer = Timer()

	init(
		updateRatesUseCase: UpdateRatesUseCase,
		fetchSavedPairsUseCase: FetchSavedPairsUseCase,
		savePairUseCase: SavePairsUseCase,
		delegate: RatesViewModelDelegate
	) {
		self.updateRatesUseCase = updateRatesUseCase
		self.fetchSavedPairsUseCase = fetchSavedPairsUseCase
		self.savePairUseCase = savePairUseCase
		self.delegate = delegate

		let savedPairs = fetchSavedPairsUseCase.execute()
		pairs = savedPairs
		ratesVisible = .init(!savedPairs.isEmpty)
		ratesActions = .init(nil)
	}

	deinit {
		timer.invalidate()
	}

	func viewDidLoad() {
		timer = .scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(self.updateCurrentPairs),
			userInfo: nil,
			repeats: true
		)
	}

	func pairWasPicked(_ pair: CurrencyPair) {
		pairs.insert(pair, at: 0)
		savePairUseCase.execute(pairs: pairs)
		updateCurrentPairs()
		rates.value.insert(.init(pair: pair, rate: 0), at: 0)
		ratesActions.value = .insert(0)
	}

	func addNewPairClicked() {
		delegate?.showAddNewPairFlow()
	}

	func removePair(at index: Int) {
		pairs.remove(at: index)
		savePairUseCase.execute(pairs: pairs)
		rates.value.remove(at: index)
		ratesActions.value = .remove(index)
	}

	@objc private func updateCurrentPairs() {
		updateRatesUseCase.execute(pairs: pairs) { [weak self] results in
			guard let self = self else { return }
			let freshRates: [CurrencyRate] = results.compactMap { result in
				if case let .success(rate) = result {
					return rate
				} else {
					return nil
				}
			}

			let ratesDictionary = freshRates.reduce([String: CurrencyRate]()) { dict, rate -> [String: CurrencyRate] in
				var dict = dict
				dict[rate.pair.code] = rate
				return dict
			}

			let sortedFreshRates = self.pairs.compactMap {pair in
				ratesDictionary[pair.code]
			}

			self.rates.value = sortedFreshRates
		}
	}
}
