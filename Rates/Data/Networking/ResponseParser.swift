//
//  ResponseParser.swift
//  CurrencyRates
//

//

import Foundation

struct ResponseParser {
	let data: Data?
}

extension ResponseParser {
	func parse(with pair: CurrencyPair) -> Result<CurrencyRate, ApiError> {
		guard let data = data else {
			return .failure(.dataParsing)
		}

		let decoder = JSONDecoder()

		guard let dto = try? decoder.decode(CurrencyRatesDto.self, from: data) else {
			return .failure(.dataParsing)
		}

		guard let rate = dto.toDomain(using: pair) else {
			return .failure(.dataParsing)
		}

		return .success(rate)
	}
}
