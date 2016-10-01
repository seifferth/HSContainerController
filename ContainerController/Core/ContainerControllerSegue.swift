//
//  ContainerControllerSegue.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

/**
Custom `UIStoryboardSegue` which override `perform()` to do nothing as the it's only been used to identify the relationship between the two controllers and to pass them to the manually implementation in `ContainerController`.
*/
public class ContainerControllerSegue: UIStoryboardSegue {

	override public func perform() {
		// The ContainerController handles the transition. This class is used to enable you to add connections between the views in the storyboard.
	}
}
