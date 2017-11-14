//
//  ContentViewController.swift
//  Example
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

	var bottomText								: String?

	@IBOutlet private weak var titleLabel		: UILabel?
	@IBOutlet private weak var messageLabel		: UILabel?
	@IBOutlet private weak var bottomLabel		: UILabel?

	private var didDisappear					= false

	override func viewDidLoad() {
		super.viewDidLoad()

		self.logLifecycle(#function)

		self.bottomLabel?.text = self.bottomText
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		self.didDisappear = true

		self.logLifecycle(#function)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if self.didDisappear {
			self.messageLabel?.text = "REUSED"
		}
		self.logLifecycle(#function)
	}

	deinit {
		self.logLifecycle(#function)
	}

	// MARK: -

	private func logLifecycle(_ message: String) {
		print((self.titleLabel?.text ?? "-") + ": " + message)
	}
}
