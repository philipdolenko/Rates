//
//  DefaultCurrencies.swift
//  CurrencyRates
//

//

import Foundation

extension Currency {
	static var pound: Self {
		Currency(code: "GBP", name: "Great Britain Pound")
	}

	static var euro: Self {
		Currency(code: "EUR", name: "Euro")
	}

	static var dollar: Self {
		Currency(code: "USD", name: "US Dollar")
	}
}

extension CurrencyPair {
	static var defaultPairs: [Self] {
		[
			CurrencyPair(source: .pound, target: .dollar),
			CurrencyPair(source: .pound, target: .euro),
			CurrencyPair(source: .dollar, target: .euro)
		]
	}
}
