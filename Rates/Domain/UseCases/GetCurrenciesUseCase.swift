//
//  GetCurrenciesUseCase.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol GetCurrenciesUseCase {
	func getCurrencies() -> [Currency]
}

class DefaultGetCurrenciesUseCase: GetCurrenciesUseCase {
	private let currenciesRepository: CurrenciesRepository

	init(currenciesRepository: CurrenciesRepository) {
		self.currenciesRepository = currenciesRepository
	}

	func getCurrencies() -> [Currency] {
		currenciesRepository.getCurrencies()
	}
}
