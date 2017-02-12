import XCTest
@testable import AnotherFeedlyApp

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
        print(window)
        let coordinator = AppCoordinator(window: window)

        coordinator.appLaunched(options: nil)

        XCTAssertNotNil(window.rootViewController)
    }

}
