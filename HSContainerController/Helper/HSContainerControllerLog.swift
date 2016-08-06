//
//  HSContainerControllerLog.swift
//  HSContainerControllerLog
//
//  Created by Hans Seiffert on 06.08.16.
//  Copyright © 2016 Hans Seiffert. All rights reserved.
//

import UIKit

// MARK: - HSLog

func Log(message: AnyObject = "", file: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
		if (HSContainerController.LogSettings.Verbose == true) {
			if (HSContainerController.LogSettings.DetailedLog == true),
				let className = NSURL(string: file)?.lastPathComponent?.componentsSeparatedByString(".").first {
					let log = "\(NSDate()) - [\(className)].\(function)[\(line)]: \(message)"
					print(log)
			} else {
				print(message)
			}
		}
	#endif
}
