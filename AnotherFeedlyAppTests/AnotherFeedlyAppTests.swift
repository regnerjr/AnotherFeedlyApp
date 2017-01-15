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

class SignInWebViewDelegateTests: XCTestCase {

    var webView: UIWebView!
    let otherAction = UIWebViewNavigationType.other

    lazy var exp: XCTestExpectation = { self.expectation(description: "Sign In Completion Called") }()
    lazy var signInCompletion: () -> Void = { self.exp.fulfill() }

    override func setUp() {
        super.setUp()
        webView = UIWebView()
    }

    override func tearDown() {
        webView = nil
        super.tearDown()
    }

    func testShouldLoadRequestWhichIsRedirect() {

        //we don't care about the completion handler for this test
        let webDelegate = SignInWebViewDelegate(signInComplete: { _ in return },
                                                redirectURI: "myRedirectURI")
        let request = URLRequest(url: URL(string:"https://www.google.com")!)

        let result = webDelegate.webView(webView, shouldStartLoadWith: request, navigationType: otherAction)
        XCTAssert(result == true, "WebView should load google")
    }

    func testShouldNotLoadURLSMatchingOurRedirectURI() {
        //we don't care about the completion handler for this test
        let webDelegate = SignInWebViewDelegate(signInComplete: { _ in return },
                                                redirectURI: "myRedirectURI")
        let request = URLRequest(url: URL(string:"myRedirectURI://auth/somecodes&keys=here")!)

        let result = webDelegate.webView(webView, shouldStartLoadWith: request, navigationType: otherAction)
        XCTAssert(result == false, "WebView should not load if new url matches our redirect URI")
    }

    func testThatTheWebDelegateCallsOurCompletionHandlerWhenARedirectIsDetected() {

        let webDelegate = SignInWebViewDelegate(signInComplete: signInCompletion,
                                                redirectURI: "myRedirectURI")
        let request = URLRequest(url: URL(string:"myRedirectURI://auth/somecodes&keys=here")!)

        let _ = webDelegate.webView(webView, shouldStartLoadWith: request, navigationType: otherAction)

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

}
