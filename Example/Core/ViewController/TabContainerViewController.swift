//
//  TabContainerViewController.swift
//  Example
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit
import ContainerController

class TabContainerViewController: UIViewController {

	@IBAction private func didPressContentAButton(_ sender: AnyObject) {
		self.ccContainerViewController?.display(segue: "showContentA")
	}

	@IBAction private func didPressContentBButton(_ sender: AnyObject) {
		self.ccContainerViewController?.display(segue: "showContentB")
	}

	@IBAction private func didPressContentCButton(_ sender: AnyObject) {
		self.ccContainerViewController?.display(segue: "showContentC")
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		self.cc_setupContainerViewControllerIfNeeded(segue, default: "showContentA", didSetup: {
			self.ccContainerViewController?.delegate = self
		})
	}
}

extension TabContainerViewController: ContainerViewControllerDelegate {

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
