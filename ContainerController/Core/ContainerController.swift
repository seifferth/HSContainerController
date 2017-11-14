//
//  ContainerController.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit


/// A `UIViewController` which can be used as embed view controller of an Container View.
/// By using segues in the storyboard which point from an instance of this class to other view controller it's possible to dynamically replace them using segues.
/// This can be used for custom tab bars, side menus, etc.. The content view controller can either be reused or newly created everytime they are openend by setting the `shouldReuseContentController` flag.
open class ContainerController: UIViewController {

	// MARK: - PUBLIC -

	public typealias ReuseIdentifier				= String
	public typealias StoryboardSegueIdentifier		= ReuseIdentifier

	// MARK: - Constants

	/// The default embed segue identifier which should be used for the default setup.
	open static let embedSegueIdentifier			= "cc_embedContainerController"

	// MARK: - Settings

	/// Set this to true if the content controller should be hold in the memory after they disappeared to reuse them if the same content identifier is called again.
	/// Otherwise all content controller will be released after the transition to another content controller. The default is `true`.
	open var shouldReuseContentController			= true

	/// The animation duration of the transition animation. The default is `0.0`. Set it to `0` to disable the animation.
	open var transitionAnimationDuration			: TimeInterval = 0.0

	/// Settings regarding the logging in all `ContainerController` instances.
	public struct LogSettings {
		/// Set this to true if the log should be enabled. The default is `false`.
		public static var verbose					= false

		/// Set this to true if the log should containt detailed information about the calling class, function and line. The default is `false`.
		public static var detailedLog				= false
	}

	// MARK: -

	/// The segue identifier of the content controller which should be displayed as first controller after the creation of the container controller.
	///
	/// This should be set during `preapreForSegue()` manually or using `setupContainerControllerIfNeeded()`.
	open var defaultSegueIdentifier					: StoryboardSegueIdentifier?

	open weak var delegate							: ContainerControllerDelegate?

	// MARK: - Lifecycle

	override open func viewDidLoad() {
		super.viewDidLoad()

		// Show the default view controller if the the container view is empty and a default content controller identifier is set.
		if
			self.currentContentController == nil,
			let _defaultSegueIdentifier = self.defaultSegueIdentifier {
				self.display(segue: _defaultSegueIdentifier)
		}
	}

	// MARK: - Display

	/// Displays the content controller with the given segue identifier. The segue has to point from the `ContainerController` object to an `UIViewController`.
	///
	/// If there is already a content controller shown, it will be replaced by the new one and either store in the memory or released (depending on the `shouldReuseContentController` property.
	///
	/// - parameter segueIdentifier: The segue identifier of the segue to the content controller which should be displayed.
	open func display(segue identifier: StoryboardSegueIdentifier) {

		guard !self.isPerformingTransition && (self.currentContentIdentifier != identifier || !self.shouldReuseContentController) else {
			// Don't perform the swap if we are currently performing a transition or if the target view controller is already is shown.
			Log("Content controller with identifier \(identifier) won't be displayed as it is already the current content controller" as AnyObject)
			return
		}

		Log("Will display segue with identifier \(identifier)" as AnyObject)

		// Update the transition flag to match the current state
		self.isPerformingTransition = true
		// Store whether the content controller is reused from the stored embed content controllers
		var didReuseContentController = false

		if self.shouldReuseContentController {
			// Check if the content controller was presented before, we might have saved it in the embedViewController dictionary then
			// If there is a reusable controller and the current content controller isn't nil, both content controller can be replaced directly without using a segue
			for (cachedIdentifier, cachedContentController) in self.embedContentControllers {
				if
					cachedIdentifier == identifier,
					let _currentContentController = self.currentContentController {
						self.replace(_currentContentController, with: cachedContentController, isReused: true)
						// Update the reuse state
						didReuseContentController = true
						// Update the current content identifier
						self.currentContentIdentifier = identifier
						break
				}
			}
		}

		// If the content controller wasn't initiated once, we have to create it by performing the segue
		if !didReuseContentController {
			self.performSegue(withIdentifier: identifier, sender: nil)
		}
	}

	// MARK: - Segue

	/// The default segue behavior will be overriden by this method. Instead of performing the segue, the destination content controllers view will replace the current view.
	override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		Log("Prepare for segue with identifier: \(String(describing: segue.identifier))" as AnyObject)
		guard let _segueIdentifier = segue.identifier else {
			assertionFailure("Error using ContainerController: The segue has to contain an identifier!")
			return
		}

		// Store the content controller for later reuse and to keep track of the current content controller if reusing is enabled
		if self.shouldReuseContentController {
			self.embedContentControllers[_segueIdentifier] = segue.destination
		}
		// Check whether there is already a current content controller
		if let _currentContentController = self.currentContentController {
			// If there is a current content controller we can replace the content controller directly
			self.replace(_currentContentController, with: segue.destination, isReused: false)
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
		// Update the current content controller identifier
		self.currentContentIdentifier = _segueIdentifier
	}

	// MARK: - PRIVATE -

	/// Flag which is `true` if a transition is currently performing
	private var isPerformingTransition			= false

	private var embedContentControllers			= [ReuseIdentifier: UIViewController]()

	private var currentContentIdentifier		: ReuseIdentifier?

	private weak var currentContentController	: UIViewController?

	// MARK: - Display

	/// Replaces the given content controller with each other. The `sourceContentController` has to be one which is currently displayed.
	///
	/// - Parameters:
	///   - sourceContentController: The current content controller which should be replaced
	///   - targetContentController: The new content controller which should be displayed
	///   - isReused: A `Bool` which indicates whether the view controller is reused
	private func replace(_ sourceContentController: UIViewController, with targetContentController: UIViewController, isReused: Bool) {
		Log("Replace content controller: \(sourceContentController) with content controller \(targetContentController)" as AnyObject)

		// Inform the delegate that the view controller will be displayed
		self.delegate?.containerController(self, willDisplay: targetContentController, isReused: isReused)

		// Update the layout from the new content controller to match the current frame
		targetContentController.view.frame = self.view.bounds
		// Update the auto layout
		targetContentController.view.layoutIfNeeded()

		// Prepare the transition
		self.addChildViewController(targetContentController)
		// Perform the transition
		self.transition(from: sourceContentController, to: targetContentController, duration: self.transitionAnimationDuration, options: .transitionCrossDissolve, animations: nil) { (finished: Bool) in
			// Remove the old content controller from the stored controllers if reusing is disabled. This will release the old content controller
			if
				!self.shouldReuseContentController,
				let _index = self.embedContentControllers.values.index(of: sourceContentController) {
					Log("Remove content controller: \(sourceContentController) from the stored embed controller as it shouldn't be reused." as AnyObject)
					self.embedContentControllers.remove(at: _index)
			}
			// Complete the adding of the new content controller
			self.triggerDidMoveToParentViewControllerIfNeeded(targetContentController, isReused: isReused)
			// Remove the old content controller as the animation is completed
			sourceContentController.removeFromParentViewController()
			// Set the content controller as the current one
			self.currentContentController = targetContentController
			// Update the transition state flag
			self.isPerformingTransition = false
		}
	}

	private func triggerDidMoveToParentViewControllerIfNeeded(_ toContentController: UIViewController, isReused: Bool) {
		if let _navigationController = toContentController as? UINavigationController {
			// If the view isn't reused we don't need to do anything here as the navigation controller will trigger the didMoveToParentViewController method itself
			if isReused {
				_navigationController.childViewControllers.first?.didMove(toParentViewController: self)
			}
		} else {
			// As the destination isn't a UINavigationController we need to call the method manually
			toContentController.didMove(toParentViewController: self)
		}
	}
}
