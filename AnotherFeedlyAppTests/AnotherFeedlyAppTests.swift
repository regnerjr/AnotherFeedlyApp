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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class AppCoordinatorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // do setup
    }

    override func tearDown() {
        //tear down
        super.tearDown()
    }

    func testCoordinatorConfiguresRootVC() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator(window: window)

        coordinator.appLaunched(options: nil)

        XCTAssertNotNil(window.rootViewController)
    }
}
