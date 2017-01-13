import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))

if isRunningTests {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(TestingAppDelegate.self))
} else {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(AppDelegate.self))
}
