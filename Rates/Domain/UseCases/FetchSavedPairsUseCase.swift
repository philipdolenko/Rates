//
//  FetchSavedPairsUseCase.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol FetchSavedPairsUseCase {
	func execute() -> [CurrencyPair]
}

class DefaultFetchSavedPairsUseCase: FetchSavedPairsUseCase {
	private let storageRepository: StorageRepository

	init(storageRepository: StorageRepository) {
		self.storageRepository = storageRepository
	}

	func execute() -> [CurrencyPair] {
		storageRepository.getCurrencyPairs()
	}
}
