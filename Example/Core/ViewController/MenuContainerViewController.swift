//
//  MenuContainerViewController.swift
//  Example
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit
import ContainerController

class MenuContainerViewController: UIViewController {

	private var customContainerViewController			: ContainerViewController?

	private var isMenuCollapsed						= false
	@IBOutlet private weak var menuWidthConstraint	: NSLayoutConstraint?

	@IBAction private func didPressToggleMenuButton(_ sender: AnyObject) {
		self.menuWidthConstraint?.constant = (isMenuCollapsed ? 240 : 120)
		UIView.animate(withDuration: 0.3, animations: {
			self.view.layoutIfNeeded()
			self.isMenuCollapsed = !self.isMenuCollapsed
		})
	}

	@IBAction private func didPressContentAButton(_ sender: AnyObject) {
		self.customContainerViewController?.display(segue: "showContentA")
	}

	@IBAction private func didPressContentBButton(_ sender: AnyObject) {
		self.customContainerViewController?.display(segue: "showContentB")
	}

	@IBAction private func didPressContentCButton(_ sender: AnyObject) {
		self.customContainerViewController?.display(segue: "showContentC")
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			segue.identifier == "customSegueIdentifier",
			let containerViewController = segue.destination as? ContainerViewController {

				self.customContainerViewController = containerViewController
				self.customContainerViewController?.shouldReuseContentController = false
				self.customContainerViewController?.defaultSegueIdentifier = "showContentA"
				self.customContainerViewController?.delegate = self
		}
	}
}

extension MenuContainerViewController: ContainerViewControllerDelegate {

	func containerViewController(_ containerViewController: ContainerViewController, willDisplay contentController: UIViewController, isReused: Bool) {
		guard !isReused else {
			return
		}

		if
			let navigationController = contentController as? UINavigationController,
			let contentController = navigationController.viewControllers.first as? ContentViewController {

				contentController.bottomText = "Text set from the calling UIViewController"
		} else if let contentController = contentController as? ContentViewController {

			contentController.bottomText = "Text set from the calling UIViewController"
		}
	}
}
