//
//  DefaultUpdateRatesUseCase.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 28.03.2021.
//

import Foundation

protocol UpdateRatesUseCase {
	func execute(pairs: [CurrencyPair], completion: @escaping ([Result<CurrencyRate, ApiError>]) -> Void)
}

class DefaultUpdateRatesUseCase: UpdateRatesUseCase {
	private let ratesRepository: RatesRepository

	init(ratesRepository: RatesRepository) {
		self.ratesRepository = ratesRepository
	}

	func execute(pairs: [CurrencyPair], completion: @escaping ([Result<CurrencyRate, ApiError>]) -> Void) {
		ratesRepository.getUpdatedRates(pairs: pairs, completion: completion)
	}
}
