//
//  MenuContainerViewController.swift
//  Example
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit
import HSContainerController

class MenuContainerViewController: UIViewController {

	private var customContainerController		: HSContainerController?

	private var isMenuCollapsed					= false
	@IBOutlet weak var menuWidthConstraint		: NSLayoutConstraint?

	@IBAction func didPressToggleMenuButton(sender: AnyObject) {
		self.menuWidthConstraint?.constant = (isMenuCollapsed == true ? 200 : 70)
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
			let _containerController = segue.destinationViewController as? HSContainerController {
				self.customContainerController = _containerController
				self.customContainerController?.shouldReuseContentController = false
				self.customContainerController?.defaultSegueIdentifier = "showContentA"
		}
    }
}
