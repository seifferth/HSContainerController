//
//  UIViewController+ContainerViewController.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {

	// MARK: - PUBLIC -

	/// The `ContainerViewController` object which is contained in the Container View.
	/// This property is set within the `cc_setupContainerViewControllerIfNeeded` method using the default segue identifier.
	///
	/// If you want to use a diferent segue identifier or multiple container controller in one view controller you have to store them manually by responding to your custom segue identifier.
	public var cc_ContainerViewController: ContainerViewController? {
		return self.privateContainerViewController
	}

	/// Checks whether the segue uses the default container controller identifier.
	/// If this is the case and the defaut container controller isn't setup yet, it will store the controller in the default `containerController` property, set the default content segue identifier and call the `didSetup` closure.
	///
	/// - Parameters:
	///   - segue: A `UIStoryboardSegue` which might use the default container controller segue identifier.
	///   - segueIdentifier: The default segue identifier of the content controller which should be used as first content to show.
	///   - didSetup: A closure which will only be called if the container controller is initialized. You might want to adjust the settings then. The default value is `nil`.
	public func cc_setupContainerViewControllerIfNeeded(_ segue: UIStoryboardSegue, default segueIdentifier: ContainerViewController.StoryboardSegueIdentifier?, didSetup: (() -> Void)? = nil) {
		if
			self.privateContainerViewController == nil && segue.identifier == ContainerViewController.embedSegueIdentifier,
			let containerController = segue.destination as? ContainerViewController {
				self.privateContainerViewController = containerController
				self.privateContainerViewController?.defaultSegueIdentifier = segueIdentifier
				didSetup?()
		}
	}

	// MARK: - PRIVATE -

	private struct AssociatedKeys {
		static var privateContainerViewController = "ccPrivateContainerViewController"
	}

	/// The private associated property which holds the default `ContainerViewController` object. It's readable from the outside with the 'containerViewController' property.
	private var privateContainerViewController	: ContainerViewController? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.privateContainerViewController) as? ContainerViewController
		}

		set {
			if let newValue = newValue {
				objc_setAssociatedObject(self, &AssociatedKeys.privateContainerViewController, newValue as ContainerViewController?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
}
