//
//  DefaultStorageRepository.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 28.03.2021.
//

import Foundation

class DefaultStorageRepository: StorageRepository {
	private let key = "selected_currency_pairs"

	func save(pairs: [CurrencyPair]) {
		let codablePairs = pairs
			.map { CurrencyPairDto($0) }

		if let pairsData = try? JSONEncoder().encode(codablePairs) {
			UserDefaults.standard.set(pairsData, forKey: key)
		}
	}

	func getCurrencyPairs() -> [CurrencyPair] {
		guard let placeData = UserDefaults.standard.data(forKey: key) else {
			return []
		}
		guard let placeArray = try? JSONDecoder().decode([CurrencyPairDto].self, from: placeData) else {
			return []
		}
		return placeArray.map { $0.toDomain() }
	}
}
