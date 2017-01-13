//
//  main.swift
//  AnotherFeedlyApp
//
//  Created by John Regner on 1/12/17.
//  Copyright © 2017 iOS-Connect. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil


let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))

if isRunningTests {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(TestingAppDelegate.self))
} else {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(AppDelegate.self))
}
