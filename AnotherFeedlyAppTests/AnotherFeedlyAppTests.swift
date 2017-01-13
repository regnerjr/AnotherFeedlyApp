import XCTest
@testable import AnotherFeedlyApp

class AppDelegateTests: XCTestCase {

    var ad: AppDelegate! = nil

    override func setUp() {
        super.setUp()
        ad = AppDelegate()
    }
    
    override func tearDown() {
        ad = nil
        super.tearDown()
    }
    
    func testAppDelegateCreatesWindow() {
        XCTAssertNotNil(ad.window)
    }

    func testAppDelegateHasCoordinator() {
        XCTAssertNotNil(ad.appCoordinator)
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
