//
//  UIViewController+KeepAlive.swift
//  CurrencyRates
//
//  Created by Philip Dolenko on 28.03.2021.
//

import UIKit

private var associatedCoordinatorHandle: UInt8 = 0

extension UIViewController {
	func keepAlive(_ coordinator: Coordinator) {
		objc_setAssociatedObject(self, &associatedCoordinatorHandle, coordinator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}
