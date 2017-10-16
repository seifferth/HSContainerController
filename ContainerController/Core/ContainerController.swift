//
//  ContainerController.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

/**
A `UIViewController` which can be used as embed view controller of an `UIContainerView`.
By using segues in the storyboard which point from an instance of this class to other view controller it's possible to dynamically replace them using segues.
This can be used for custom tab bars, side menus, etc.. The content view controller can either be reused or newly created everytime they are openend by setting the `shouldReuseContentController` flag.
*/
open class ContainerController: UIViewController {

	// MARK: - PUBLIC -

	public typealias UIStoryboardSegueIdentifier	= String

	// MARK: - Constants

	/**
	The default embed segue identifiert which should be used for the default setup.
	*/
	open static let embedSegueIdentifier			= "cc_embedContainerController"

	// MARK: - Settings

	/**
	Set this to true if the content controller should be hold in the memory after they disappeared to reuse them if the same segue identifier is called again. Otherwise all content controller will be release after the transition to another content controller. The default is `true`.
	*/
	open var shouldReuseContentController			= true

	/**
	The animation duration of the transition animation. The default is `0.0`. Set it to `0` to disable the animation.
	*/
	open var transitionAnimationDuration			: TimeInterval = 0.0

	/**
	Settings regarding the logging in all `ContainerController` instances.
	*/
	public struct LogSettings {
		/**
		Set this to true if the log should be enabled. The default is `false`.
		*/
		public static var Verbose					= false

		/**
		Set this to true if the log should containt detailed information about the calling class, function and line. The default is `false`.
		*/
		public static var DetailedLog				= false
	}

	// MARK: -

	/**
	The segue identifier of the content controller which should be displayes as first content controller after the creation of the container controller. This should be set during `preapreForSegue()` manually or using `setupContainerControllerIfNeeded()`.
	*/
	open var defaultSegueIdentifier				: UIStoryboardSegueIdentifier?

	open weak var delegate						: ContainerControllerDelegate?

	// MARK: - Lifecycle

	override open func viewDidLoad() {
		super.viewDidLoad()

		// Show the default view controller if the the container view is empty and a default segue identifier is set.
		if (self.currentContentController == nil),
			let _defaultSegueIdentifier = self.defaultSegueIdentifier {
				self.displayContentController(segueIdentifier: _defaultSegueIdentifier)
		}
	}

	// MARK: - Display

	/**
	Displays the content controller with the given segie identifier. The segue has to point from the `ContainerController` object to an `UIViewController`.
	If there is already a content controller shown, it will be replaced by the new one and either store in the memory or released (depending on the `shouldReuseContentController` property.

	- parameter segueIdentifier: The segue identifier of the segue to the content controller which should be displayed.
	*/
	open func displayContentController(segueIdentifier: UIStoryboardSegueIdentifier) {

		guard self.isPerformingTransition == false && (self.currentSegueIdentifier != segueIdentifier || self.shouldReuseContentController == false) else {
			// Don't perform the swap if we are currently performing a transition or if the target view controller is already is shown.
			Log("Segue with the identifier \(segueIdentifier) won't be displayed as it is already the current content controller" as AnyObject)
			return
		}

		Log("Will display segue with the identifier \(segueIdentifier)" as AnyObject)

		// Update the transition flag to match the current state
		self.isPerformingTransition = true
		// Store whether the content controller is reused from the stored embed content controllers
		var didReuseContentController = false

		if (self.shouldReuseContentController == true) {
			// Check if the content controller was presented before, we might have saved it in the embedViewController dictionary then
			// If there is a reusable controller and the current content controller isn't nil, both content controller can be replaced directly without using a segue
			for (storedSegueIdentifier, storedContentController) in self.embedContentControllers {
				if (storedSegueIdentifier == segueIdentifier),
					let _currentContentController = self.currentContentController {
						self.replaceContentController(fromContentController: _currentContentController, toContentController: storedContentController, isReused: true)
						// Update the reuse state
						didReuseContentController = true
						// Update the current segue identifier
						self.currentSegueIdentifier = segueIdentifier
						break
				}
			}
		}

		// If the content controller wasn't initiated once, we have to create it by performing the segue
		if (didReuseContentController == false) {
			self.performSegue(withIdentifier: segueIdentifier, sender: nil)
		}
	}

	// MARK: - Segue

	// The default segue behavior will be overriden by this method. Instead of performing the segue, the destination conent controllers view will replace the current view.
	override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		Log("Prepare for segue with identifier: \(String(describing: segue.identifier))" as AnyObject)
		if let _segueIdentifier = segue.identifier {
			// Store the content controller for later reuse and to keep track of the current content controller if reusing is enabled
			if (self.shouldReuseContentController == true) {
				self.embedContentControllers[_segueIdentifier] = segue.destination
			}
			// Check whether there is already a current content controler
			if let _currentContentController = self.currentContentController {
				// If there is a current content controller we can replace the content controller directly
				self.replaceContentController(fromContentController: _currentContentController, toContentController: segue.destination, isReused: false)
			} else {
				// Inform the delegate that the view controller is created and will be displayed. As it's just created it's not reused.
				self.delegate?.containerController(self, willDisplay: segue.destination, isReused: false)
				// If there isn't a current controller we have to add it as child and add the view
				self.addChildViewController(segue.destination)
				// Replace the container view with the content controlers view
				guard let destinationView = segue.destination.view else {
					assertionFailure("Coudln't access view of the segue destination")
					return
				}

				destinationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
				destinationView.frame = self.view.bounds
				destinationView.layoutIfNeeded()
				self.view.addSubview(destinationView)
				// Inform the content controller that is visible now
				self.triggerDidMoveToParentViewControllerIfNeeded(segue.destination, isReused: false)
				// Set the content controller as the current one
				self.currentContentController = segue.destination
				// Update the transition state flag
				self.isPerformingTransition = false
			}
			// Update the current segue identifier
			self.currentSegueIdentifier = _segueIdentifier
		} else {
			assertionFailure("Error using ContainerController: The segue has to contain an identifier!")
		}
	}

	// MARK: - PRIVATE -

	/**
	Flag which is `true` a transition is currently performing
	*/
	fileprivate var isPerformingTransition			= false

	/**

	*/
	fileprivate var embedContentControllers			= [UIStoryboardSegueIdentifier: UIViewController]()

	fileprivate var currentSegueIdentifier			: UIStoryboardSegueIdentifier?

	fileprivate weak var currentContentController	: UIViewController?

	// MARK: - Display

	/**
	Replaces the given content controller with each other. The `fromContentController` has to be one which is currently displayed.

	- parameter fromContentController: The current content controller which should be replaced
	- parameter toContentController: The new content controller which should be displayed
	- parameter isReused: A `Bool` which indicates whether the view controller is reused
	*/
	fileprivate func replaceContentController(fromContentController: UIViewController, toContentController: UIViewController, isReused: Bool) {
		Log("Replace content controller: \(fromContentController) with content controller \(toContentController)" as AnyObject)

		// Inform the delegate that the view controller will be displayed
		self.delegate?.containerController(self, willDisplay: toContentController, isReused: isReused)

		// Update the layout from the new content controller to match the current frame
		toContentController.view.frame = self.view.bounds
		// Update the auto layout
		toContentController.view.layoutIfNeeded()

		// Prepare the transition
		self.addChildViewController(toContentController)
		// Perform the transition
		self.transition(from: fromContentController, to: toContentController, duration: self.transitionAnimationDuration, options: .transitionCrossDissolve, animations: nil) { (finished: Bool) in
			// Remove the old content controller from the stored controllers if reusing is disabled. This will release the old content controller
			if (self.shouldReuseContentController == false),
				let _index = self.embedContentControllers.values.index(of: fromContentController) {
					Log("Remove content controller: \(fromContentController) from the stored embed controller as it shouldn't be reused." as AnyObject)
					self.embedContentControllers.remove(at: _index)
			}
			// Complete the adding of the new content controller
			self.triggerDidMoveToParentViewControllerIfNeeded(toContentController, isReused: isReused)
			// Remove the old content controller as the animation is completed
			fromContentController.removeFromParentViewController()
			// Set the content controller as the current one
			self.currentContentController = toContentController
			// Update the transition state flag
			self.isPerformingTransition = false
		}
	}

	func triggerDidMoveToParentViewControllerIfNeeded(_ toContentController: UIViewController, isReused: Bool) {
		if let _navigationController = toContentController as? UINavigationController {
			// If the view isn't reused we don't need to do anything here as the navigation controller will trigger the didMoveToParentViewController method itself
			if (isReused == true) {
				_navigationController.childViewControllers.first?.didMove(toParentViewController: self)
			}
		} else {
			// As the destination isn't a UINavigationController we need to call the method manually
			toContentController.didMove(toParentViewController: self)
		}
	}
}
