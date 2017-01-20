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

class MockDelegate: NSObject, UIWebViewDelegate {
    let loadCompletion: () -> Void
    init(completion: @escaping () -> Void) {
        loadCompletion = completion
    }
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        loadCompletion()
        return true
    }
}

class SignInViewControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        //perform setup
    }
    override func tearDown() {
        // perform tear down
        super.tearDown()
    }

    func testViewDidLoadSetsUpWebDelegate() {

        let auth = Auth()
        let signIn = StoryboardScene.Main.instantiateSignInViewController()
        let delegate = SignInWebViewDelegate(signInComplete: { }, redirectURI: "Whatever")
        signIn.webViewDelegate = delegate
        signIn.spotify = Spotify(auth: auth)

        _ = signIn.view

        XCTAssertNotNil(signIn.webView.delegate)
    }

    func testViewDidLoadStartsWebLoad() {

        let exp: XCTestExpectation = { self.expectation(description: "WebViewLoads") }()

        let auth = Auth()
        let mock = MockDelegate { exp.fulfill() }
        let signIn = StoryboardScene.Main.instantiateSignInViewController()
        signIn.webViewDelegate = mock
        signIn.spotify = Spotify(auth: auth)

        _ = signIn.view

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
