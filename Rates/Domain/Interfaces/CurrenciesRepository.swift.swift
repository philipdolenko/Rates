//
//  CurrenciesRepository.swift.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol CurrenciesRepository {
	func getCurrencies() -> [Currency]
}
