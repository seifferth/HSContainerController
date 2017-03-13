//
//  ContainerControllerDelegate.swift
//  ContainerController
//
//  Created by Hans Seiffert on 07.10.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import Foundation

public protocol ContainerControllerDelegate: class {

	func containerController(_ containerController: ContainerController, willDisplay contentController: UIViewController, isReused: Bool)
}
