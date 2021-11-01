//
//  CurrencyPair.swift
//  CurrencyRates
//

//

import Foundation

struct CurrencyPair {
	let source: Currency
	let target: Currency
}

extension CurrencyPair {
	var code: String {
		source.code + target.code
	}
}
