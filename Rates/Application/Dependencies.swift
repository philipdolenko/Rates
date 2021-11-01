//
//  Dependencies.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

// A helper class to reduce 3d party lib's and not over-engineer for the current task
// It should be replaced with proper DI solution: Swinject, DITranquillity etc
struct Dependencies {
	let ratesRepository: RatesRepository
	let currenciesRepository: CurrenciesRepository
	let storageRepository: StorageRepository

	func makeUpdateRatesUseCase() -> UpdateRatesUseCase {
		DefaultUpdateRatesUseCase(ratesRepository: ratesRepository)
	}

	func makeGetCurrenciesUseCase() -> GetCurrenciesUseCase {
		DefaultGetCurrenciesUseCase(currenciesRepository: currenciesRepository)
	}

	func makeFetchSavedPairsUseCase() -> FetchSavedPairsUseCase {
		DefaultFetchSavedPairsUseCase(storageRepository: storageRepository)
	}

	func makeSavePairUseCase() -> SavePairsUseCase {
		DefaultSavePairsUseCase(storageRepository: storageRepository)
	}
}
