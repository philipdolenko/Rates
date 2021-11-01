//
//  CurrencyPairDto.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 28.03.2021.
//

import Foundation

// Domain Layer should not include anything from Data Layer — Mapping Codable
class CurrencyPairDto: Codable {
	struct CurrencyDto: Codable {
		let code: String
		let name: String

		init(_ currency: Currency) {
			code = currency.code
			name = currency.name
		}

		func toDomain() -> Currency {
			.init(code: code, name: name)
		}
	}

	let source: CurrencyDto
	let target: CurrencyDto

	init(_ pair: CurrencyPair) {
		source = .init(pair.source)
		target = .init(pair.target)
	}

	func toDomain() -> CurrencyPair {
		.init(
			source: source.toDomain(),
			target: target.toDomain()
		)
	}
}
