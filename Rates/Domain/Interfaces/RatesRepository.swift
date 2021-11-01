//
//  RatesRepository.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 27.03.2021.
//

import Foundation

protocol RatesRepository {
	func getUpdatedRates(pairs: [CurrencyPair], completion: @escaping ([Result<CurrencyRate, ApiError>]) -> Void)
}
