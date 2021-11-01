//
//  RatesApiService.swift
//  CurrencyRates
//

//

import Foundation

final class DefaultRatesRepository: RatesRepository {
	func getUpdatedRates(pairs: [CurrencyPair], completion: @escaping ([Result<CurrencyRate, ApiError>]) -> Void) {
		var results: [Result<CurrencyRate, ApiError>] = []
		let urlDownloadQueue = DispatchQueue(label: "ml.philipdolenko.urlqueue")
		let urlDownloadGroup = DispatchGroup()

		let pairsRequestData: [(URL, CurrencyPair)] = pairs.compactMap { pair in
			let builder = UrlBuilder(pair: pair)
			if let url = builder.build() {
				return (url, pair)
			} else {
				return nil
			}
		}
		pairsRequestData.forEach { url, pair in
			urlDownloadGroup.enter()

			let task = URLSession.shared.dataTask(with: url) { data, _, _ in
				let parser = ResponseParser(data: data)
				let result = parser.parse(with: pair)

				urlDownloadQueue.async {
					results.append(result)
					urlDownloadGroup.leave()
				}
			}

			task.resume()
		}

		urlDownloadGroup.notify(queue: DispatchQueue.global()) {
			completion(results)
		}
	}
}
