//
//  CurrenciesRepository.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

class DefaultCurrenciesRepository: CurrenciesRepository {
	func getCurrencies() -> [Currency] {
		let fileName = "currencies+names"
		let fileType = "json"

		guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
			return []
		}

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

			guard let jsonResult = jsonObject as? [String: String] else {
				return []
			}
			let result = jsonResult.map {
				Currency(code: $0.key, name: $0.value)
			}
			return result.sorted { $0.name < $1.name }
		} catch {
			return []
		}
	}
}
