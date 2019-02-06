//
//  Log.swift
//  ContainerController
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

// MARK: - Log

func log(_ message: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
		guard ContainerViewController.LogSettings.verbose else {
			return
		}

		if
			ContainerViewController.LogSettings.detailedLog,
			let className = NSURL(string: file)?.lastPathComponent?.components(separatedBy: ".").first {
				let log = "\(NSDate()) - [\(className)].\(function)[\(line)]: \(message)"
				print(log)
		} else {
			print(message)
		}
	#endif
}
