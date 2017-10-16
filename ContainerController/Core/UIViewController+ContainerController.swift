//
//  UIViewController+ContainerController.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {

	// MARK: - PUBLIC -

	/**
	The `ContainerController` object which is contained in the `UIContainerView`.
	This property is set within the `setupContainerControllerIfNeeded` method using the default segue identifier.
	If you want to use a diferent segue identifier or multiple container controller in one view controller you have to store them manually by responding to your custom segue identifier.
	*/
	public var containerController: ContainerController? {
		return self.privateContainerController
	}

	/**
	Checks whether the segue uses the default container controller identifier.
	If this is the case and the defaut container controller isn't setup yet, it will store the controller in the default `containerController` property, set the default content segue identifier and call the `didSetup` closure.

	- parameter segue: A `UIStoryboardSegue` which might use the default container controller segue identifier.
	- parameter defaultSegueIdentifier: The default segue identifier of the content controller which should be used as first content to show.
	- parameter didSetup: A closure which will only be called if the container controller is initialized. You might want to adjust the settings then. The default value is `nil`.
	*/
	public func cc_setupContainerControllerIfNeeded(_ segue: UIStoryboardSegue, defaultSegueIdentifier: String?, didSetup: (() -> Void)? = nil) {
		if
			self.privateContainerController == nil && segue.identifier == ContainerController.embedSegueIdentifier,
			let _containerController = segue.destination as? ContainerController {
				self.privateContainerController = _containerController
				self.privateContainerController?.defaultSegueIdentifier = defaultSegueIdentifier
				didSetup?()
		}
	}

	// MARK: - PRIVATE -

	private struct AssociatedKeys {
		static var privateContainerController = "cc_privateContainerController"
	}

	/**
	The private associated property which holds the default `ContainerController` object. It's readable from the outside with the 'containerController' property.
	*/
	private var privateContainerController	: ContainerController? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.privateContainerController) as? ContainerController
		}

		set {
			if let newValue = newValue {
				objc_setAssociatedObject(self, &AssociatedKeys.privateContainerController, newValue as ContainerController?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
}
