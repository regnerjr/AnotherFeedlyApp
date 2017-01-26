import XCTest
@testable import AnotherFeedlyApp

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate! = nil // swiftlint:disable:this weak_delegate

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
    }

    override func tearDown() {
        appDelegate = nil
        super.tearDown()
    }

    func testAppDelegateCreatesWindow() {
        XCTAssertNotNil(appDelegate.window)
    }

    func testAppDelegateHasCoordinator() {
        XCTAssertNotNil(appDelegate.appCoordinator)
    }
    
}
