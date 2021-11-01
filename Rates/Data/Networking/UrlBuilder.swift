//
//  UrlBuilder.swift
//  CurrencyRates
//

//

import Foundation

struct UrlBuilder {
	let pair: CurrencyPair
}

extension UrlBuilder {
	enum Constants {
		static let endpoint = "https://api.exchangeratesapi.io/latest"
		static let source = "base"
		static let target = "symbols"
	}

	func build() -> URL? {
		var components = URLComponents(string: Constants.endpoint)
		components?.queryItems = [
			.init(name: Constants.source, value: pair.source.code),
			.init(name: Constants.target, value: pair.target.code)
		]
		return components?.url
	}
}
