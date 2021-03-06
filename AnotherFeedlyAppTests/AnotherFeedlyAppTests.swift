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
        signIn.urlRequest = FeedlySignIn(auth: auth).signInRequest

        _ = signIn.view

        XCTAssertNotNil(signIn.webView.navigationDelegate)
    }

    func testViewDidLoadStartsWebLoad() {

        let auth = Auth()
        let signIn = StoryboardScene.Main.instantiateWebViewController()
        let mockWebView = MockWebView()

        signIn.webView = mockWebView
        signIn.urlRequest = FeedlySignIn(auth: auth).signInRequest

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
        let feedly = FeedlySignIn(auth: auth)

        let json = feedly.tokenRequestPayload(code: code)
        guard let unSerialized = try? JSONSerialization.jsonObject(with: json, options: []) else {
            fatalError("json data cant be de-serialized")
        }
        let unSerializedDict = unSerialized as? [String: Any]
        XCTAssertEqual(unSerializedDict?["code"] as? String, code)
    }

    func testBuildRequestJSON() {

        let auth = Auth()
        let feedly = FeedlySignIn(auth: auth)

        let req = feedly.tokenRequest(code: "12345")

        XCTAssert(req.httpMethod == "POST")
        XCTAssertNotNil(req.httpBody)
        XCTAssertEqual(req.url?.absoluteString.contains("auth/token"), true)
    }

    func testNetworkResponseHandlerAll_ForAuthTokenRequest() {

        let auth = Auth()
        let feedly = FeedlySignIn(auth: auth)

        let exp = expectation(description: "token was returned")

        let handler = feedly.tokenResponseHandler { result in
            switch result {
            case .success(let token):
                XCTFail("Should not get token without passing data (only error)")
            case .error(let error):
                exp.fulfill()
            }
        }
        let err = NSError(domain: "networkFail", code: 1234, userInfo: nil)
        handler(nil, nil, err)

        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                XCTFail("\(error.localizedDescription)")
            }
        }

    }
}
