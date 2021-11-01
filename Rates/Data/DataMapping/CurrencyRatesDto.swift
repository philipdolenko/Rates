//
//  CurrencyPairDto.swift
//  CurrencyRates
//

//

import Foundation

struct CurrencyRatesDto: Codable {
	var rates: [String: Double]
	var base: String
}

extension CurrencyRatesDto {
	func toDomain(using pair: CurrencyPair) -> CurrencyRate? {
		guard let rate = rates[pair.target.code] else {
			return nil
		}
		return CurrencyRate(pair: pair, rate: rate)
	}
}
