//
//  SavePairsUseCase.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol SavePairsUseCase {
	func execute(pairs: [CurrencyPair])
}

class DefaultSavePairsUseCase: SavePairsUseCase {
	private let storageRepository: StorageRepository

	init(storageRepository: StorageRepository) {
		self.storageRepository = storageRepository
	}

	func execute(pairs: [CurrencyPair]) {
		storageRepository.save(pairs: pairs)
	}
}
