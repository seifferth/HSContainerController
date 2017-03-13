//
//  MenuContainerViewController.swift
//  Example
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit
import ContainerController

class MenuContainerViewController				: UIViewController {

	fileprivate var customContainerController		: ContainerController?

	fileprivate var isMenuCollapsed					= false
	@IBOutlet weak var menuWidthConstraint		: NSLayoutConstraint?

	@IBAction func didPressToggleMenuButton(_ sender: AnyObject) {
		self.menuWidthConstraint?.constant = (isMenuCollapsed == true ? 240 : 120)
		UIView.animate(withDuration: 0.3, animations: {
			self.view.layoutIfNeeded()
			self.isMenuCollapsed = !self.isMenuCollapsed
		}) 
	}

	@IBAction func didPressContentAButton(_ sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentA")
	}

	@IBAction func didPressContentBButton(_ sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentB")
	}

	@IBAction func didPressContentCButton(_ sender: AnyObject) {
		self.customContainerController?.displayContentController(segueIdentifier: "showContentC")
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "customSegueIdentifier"),
			let _containerController = segue.destination as? ContainerController {
				self.customContainerController = _containerController
				self.customContainerController?.shouldReuseContentController = false
				self.customContainerController?.defaultSegueIdentifier = "showContentA"
				self.customContainerController?.delegate = self
		}
    }
}

extension MenuContainerViewController: ContainerControllerDelegate {

	func containerController(_ containerController: ContainerController, willDisplay contentController: UIViewController, isReused: Bool) {
		if (isReused == false) {
			if let
				_navigationController = contentController as? UINavigationController,
				let _contentController = _navigationController.viewControllers.first as? ContentViewController {
				_contentController.bottomText = "Text set from the calling UIViewController"
			} else if let _contentController = contentController as? ContentViewController {
				_contentController.bottomText = "Text set from the calling UIViewController"
			}
		}
	}
}
