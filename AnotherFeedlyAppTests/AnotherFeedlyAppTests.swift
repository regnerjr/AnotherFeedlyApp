import XCTest
import WebKit
@testable import AnotherFeedlyApp

class MockWebView: WKWebView {
    var loaded = false
    var urlString: String! = ""
    override func load(_ request: URLRequest) -> WKNavigation? {
        print("trying to load \(request)")
        loaded = true
        urlString = request.url!.absoluteString
        return nil
    }
}

class InterestingWebViewDelegateTests: XCTestCase {

    let otherAction = UIWebViewNavigationType.other

    lazy var exp: XCTestExpectation = { self.expectation(description: "Sign In Completion Called") }()
    lazy var signInCompletion: (URLRequest) -> Void = { _ in self.exp.fulfill() }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testShouldLoadRequestWhichIsRegularURL() {

        //we don't care about the completion handler for this test
        let webDelegate = InterestingWebViewDelegate(completion: {_ in }, urlOfInterest: "myRedirectURI")
        let request = URLRequest(url: URL(string:"https://www.google.com")!)

        var result = false
        webDelegate.decideIf(requestIsInteresting: request, AndCallCorrectHandler: { policy in
            result = policy == .allow
        })

        XCTAssert(result == true, "WebView should load google")
    }

    func testShouldNotLoadURLSMatchingOurRedirectURI() {
        //we don't care about the completion handler for this test
        let webDelegate = InterestingWebViewDelegate(completion: {_ in }, urlOfInterest: "myRedirectURI")
        let request = URLRequest(url: URL(string:"myRedirectURI://auth/somecodes&keys=here")!)

        var result = false
        webDelegate.decideIf(requestIsInteresting: request, AndCallCorrectHandler: { policy in
            result = policy == .cancel
        })
        XCTAssert(result == false, "WebView should not load if new url matches our redirect URI")
    }

    func testThatTheWebDelegateCallsOurCompletionHandlerWhenARedirectIsDetected() {

        let webDelegate = InterestingWebViewDelegate(completion: signInCompletion, urlOfInterest: "myRedirectURI")
        let request = URLRequest(url: URL(string:"myRedirectURI://auth/somecodes&keys=here")!)

        webDelegate.decideIf(requestIsInteresting: request, AndCallCorrectHandler: { _ in
        })

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
        let signIn = StoryboardScene.Main.instantiateWebViewController()
        let delegate = InterestingWebViewDelegate(completion: {_ in }, urlOfInterest: "Whatever")
        signIn.webViewDelegate = delegate
        signIn.urlRequest = Feedly(auth: auth).signInRequest

        _ = signIn.view

        XCTAssertNotNil(signIn.webView.navigationDelegate)
    }

    func testViewDidLoadStartsWebLoad() {

        let auth = Auth()
        let signIn = StoryboardScene.Main.instantiateWebViewController()
        let mockWebView = MockWebView()

        signIn.webView = mockWebView
        signIn.urlRequest = Feedly(auth: auth).signInRequest

        _ = signIn.view

        XCTAssert(mockWebView.loaded, "Web View did not call `loadRequest` Loaded:\(mockWebView.loaded)")
        XCTAssert(mockWebView.urlString.hasPrefix("https://sandbox.feedly.com"), "URL String \(mockWebView.urlString)")
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

        let auth = Auth()
        let feedly = Feedly(auth: auth)

        let req = feedly.tokenRequest(code: "12345")

        XCTAssert(req.httpMethod == "POST")
        XCTAssertNotNil(req.httpBody)
        XCTAssertEqual(req.url?.absoluteString.contains("auth/token"), true)
    }
}

// What we really need to do is take the code that we got back, and put in in a json dict,
// then POST that dict to /v2/auth/token

// Then from that response we make a little user with a token.
