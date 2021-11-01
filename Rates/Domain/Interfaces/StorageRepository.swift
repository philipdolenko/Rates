//
//  StorageRepository.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol StorageRepository {
	func save(pairs: [CurrencyPair])
	func getCurrencyPairs() -> [CurrencyPair]
}
