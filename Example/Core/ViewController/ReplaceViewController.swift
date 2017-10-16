//
//  ReplaceViewController.swift
//  Example
//
//  Created by Konstantin Deichmann on 16.10.17.
//  Copyright © 2017 Hans Seiffert. All rights reserved.
//

import UIKit

class ReplaceViewController			: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.replaceContent(with: self.storyboard?.instantiateViewController(withIdentifier: "AViewController"))
	}

	private func replaceContent(with viewController: UIViewController?) {

		guard let viewController = viewController else {
			return
		}

		self.containerController?.display(contentController: viewController)
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		self.cc_setupContainerControllerIfNeeded(segue)
	}
}

// MARK: - IBAction

extension ReplaceViewController {

	@IBAction private func replaceWithAViewController() {
		self.replaceContent(with: self.storyboard?.instantiateViewController(withIdentifier: "AViewController"))
	}

	@IBAction private func replaceWithBViewController() {
		self.replaceContent(with: self.storyboard?.instantiateViewController(withIdentifier: "BViewController"))
	}
}
