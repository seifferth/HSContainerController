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

	private var customContainerController			: ContainerController?

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
		self.customContainerController?.display(segue: "showContentA")
	}

	@IBAction private func didPressContentBButton(_ sender: AnyObject) {
		self.customContainerController?.display(segue: "showContentB")
	}

	@IBAction private func didPressContentCButton(_ sender: AnyObject) {
		self.customContainerController?.display(segue: "showContentC")
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			segue.identifier == "customSegueIdentifier",
			let containerController = segue.destination as? ContainerController {

				self.customContainerController = containerController
				self.customContainerController?.shouldReuseContentController = false
				self.customContainerController?.defaultSegueIdentifier = "showContentA"
				self.customContainerController?.delegate = self
		}
	}
}

extension MenuContainerViewController: ContainerControllerDelegate {

	func containerController(_ containerController: ContainerController, willDisplay contentController: UIViewController, isReused: Bool) {
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
