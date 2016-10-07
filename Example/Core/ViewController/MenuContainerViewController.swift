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

	private var customContainerController		: ContainerController?

	private var isMenuCollapsed					= false
	@IBOutlet weak var menuWidthConstraint		: NSLayoutConstraint?

	@IBAction func didPressToggleMenuButton(sender: AnyObject) {
		self.menuWidthConstraint?.constant = (isMenuCollapsed == true ? 240 : 120)
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
			self.isMenuCollapsed = !self.isMenuCollapsed
		}
	}

	@IBAction func didPressContentAButton(sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentA")
	}

	@IBAction func didPressContentBButton(sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentB")
	}

	@IBAction func didPressContentCButton(sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentC")
	}

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "customSegueIdentifier"),
			let _containerController = segue.destinationViewController as? ContainerController {
				self.customContainerController = _containerController
				self.customContainerController?.shouldReuseContentController = false
				self.customContainerController?.defaultSegueIdentifier = "showContentA"
				self.customContainerController?.delegate = self
		}
    }
}

extension MenuContainerViewController: ContainerControllerDelegate {

	func containerController(containerController: ContainerController, willDisplay contentController: UIViewController, isReused: Bool) {
		if (isReused == false) {
			if let
				_navigationController = contentController as? UINavigationController,
				_contentController = _navigationController.viewControllers.first as? ContentViewController {
				_contentController.bottomText = "Text set from the calling UIViewController"
			} else if let _contentController = contentController as? ContentViewController {
				_contentController.bottomText = "Text set from the calling UIViewController"
			}
		}
	}
}
