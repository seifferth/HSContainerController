//
//  ContainerViewControllerDelegate.swift
//  ContainerController
//
//  Created by Hans Seiffert on 07.10.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerDelegate: AnyObject {

	func containerViewController(_ containerController: ContainerViewController, willDisplay contentController: UIViewController, isReused: Bool)
}
