//
//  AppDelegate.swift
//  CurrencyRates
//

//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(
		_: UIApplication,
		didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		navigationController.isNavigationBarHidden = true

		window?.rootViewController = navigationController

		let dependencies = Dependencies(
			ratesRepository: DefaultRatesRepository(),
			currenciesRepository: DefaultCurrenciesRepository(),
			storageRepository: DefaultStorageRepository()
		)

		let ratesCoordinator = RatesCoordinator(with: navigationController, using: dependencies)

		ratesCoordinator.start()
		window?.makeKeyAndVisible()
		return true
	}
}
