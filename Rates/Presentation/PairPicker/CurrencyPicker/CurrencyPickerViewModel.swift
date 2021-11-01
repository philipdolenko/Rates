//
//  PairPickerViewModel.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 29.03.2021.
//

import Foundation

protocol CurrencyPickerViewModelInput {
	func didSelectCurrency(at index: Int)
}

protocol CurrencyPickerViewModelOutput {
	var currencies: Dynamic<[Currency]> { get }
	var selectedCurrencies: Dynamic<[Currency]> { get }
	var proceesdWithSelected: ([Currency]) -> Void { get }
}

protocol CurrencyPickerViewModel: CurrencyPickerViewModelInput, CurrencyPickerViewModelOutput {}

class DefaultCurrencyPickerViewModel: CurrencyPickerViewModel {
	var proceesdWithSelected: ([Currency]) -> Void
	var selectedCurrencies: Dynamic<[Currency]>
	var currencies: Dynamic<[Currency]>

	init(
		getCurrenciesUseCase: GetCurrenciesUseCase,
		selectedCurrencies: [Currency],
		proceesdWithSelected: @escaping ([Currency]) -> Void
	) {
		currencies = .init(getCurrenciesUseCase.getCurrencies())
		self.selectedCurrencies = .init(selectedCurrencies)
		self.proceesdWithSelected = proceesdWithSelected
	}

	func didSelectCurrency(at index: Int) {
		selectedCurrencies.value.append(currencies.value[index])
		proceesdWithSelected(selectedCurrencies.value)
	}
}
