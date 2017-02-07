import XCTest
@testable import AnotherFeedlyApp

class MockDelegate: NSObject, UIWebViewDelegate {
    var loadStarted: (() -> Void)
    init(loadStarted: @escaping (() -> Void)) {
        self.loadStarted = loadStarted
    }
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        loadStarted()
        return true
    }
}

class SignInWebViewDelegateTests: XCTestCase {

    var webView: UIWebView!
    let otherAction = UIWebViewNavigationType.other

    lazy var exp: XCTestExpectation = { self.expectation(description: "Sign In Completion Called") }()
    lazy var signInCompletion: (String?) -> Void = { _ in self.exp.fulfill() }

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
        let delegate = SignInWebViewDelegate(signInComplete: { _ in }, redirectURI: "Whatever")
        signIn.webViewDelegate = delegate
        signIn.feedly = Feedly(auth: auth)

        _ = signIn.view

        XCTAssertNotNil(signIn.webView.delegate)
    }

    func testViewDidLoadStartsWebLoad() {

        let exp: XCTestExpectation = { self.expectation(description: "WebViewLoads") }()

        let auth = Auth()
        let mock = MockDelegate { exp.fulfill() }
        let signIn = StoryboardScene.Main.instantiateSignInViewController()
        signIn.webViewDelegate = mock
        signIn.feedly = Feedly(auth: auth)

        _ = signIn.view

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

class CodeExtraction: XCTestCase {

    func testGoodExtract() {

        let matchingCode = "AQAA7rJ7InAiOjEsImEiOiJmZWVk"
        let stringUrl = "https://your.redirect.uri/feedlyCallback?code=\(matchingCode)&state=state.passed.in"

        guard let url = URL(string: stringUrl) else {
            XCTFail("HMM URL Is invalid"); return
        }
        let request = URLRequest(url: url)

        let code = request.extractAuthCodeFromRedirect()

        XCTAssertEqual(code, matchingCode)
    }

    func testTokenRequestJSONHasRightForm() {
        let code = "12345"

        let auth = Auth()
        let feedly = Feedly(auth: auth)

        let json = feedly.tokenRequestJSON(code: code)
        guard let unSerialized = try? JSONSerialization.jsonObject(with: json, options: []) else {
            fatalError("json data cant be de-serialized")
        }
        let unSerializedDict = unSerialized as? [String: Any]
        XCTAssertEqual(unSerializedDict?["code"] as? String, code)
    }

    func testBuildRequestJSON() {

        let exp: XCTestExpectation = { self.expectation(description: "") }()
        let auth = Auth()
        let feedly = Feedly(auth: auth)

        feedly.requestToken(withCode: "123456", completion: { _ in exp.fulfill() })
        let req = feedly.tokenRequest(code: "12345")

        XCTAssert(req.httpMethod == "POST")
        XCTAssertNotNil(req.httpBody)
        XCTAssertEqual(req.url?.absoluteString.contains("auth/token"), true)

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

// What we really need to do is take the code that we got back, and put in in a json dict,
// then POST that dict to /v2/auth/token

// Then from that response we make a little user with a token.
