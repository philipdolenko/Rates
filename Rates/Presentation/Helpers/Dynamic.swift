//
//  Dynamic.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 27.03.2021.
//

import Foundation

class Dynamic<T> {
	typealias Listener = (T) -> Void
	var listener: Listener?

	func bind(_ listener: Listener?) {
		self.listener = listener
	}

	func bindAndFire(_ listener: Listener?) {
		self.listener = listener
		listener?(value)
	}

	var value: T {
		didSet {
			listener?(value)
		}
	}

	init(_ initValue: T) {
		value = initValue
	}
}
