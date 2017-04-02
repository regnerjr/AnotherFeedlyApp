import UIKit
import WebKit

/// A Simple WebViewController
/// The `WKWebView` it uses will fill the entire `UIScreen.main.bounds`
/// There are 2 points of configuration, `urlRequest`, and `webViewDelegate`
class WebViewController: UIViewController {

    lazy var webView: WKWebView = WKWebView(frame: UIScreen.main.bounds, configuration: WKWebViewConfiguration())

    /// The WebView's NavigationDelegate
    var webViewDelegate: WKNavigationDelegate? //swiftlint:disable:this weak_delegate
    /// The URLRequest to load when View Controller comes on screen
    var urlRequest: URLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = webViewDelegate
        webView.load(urlRequest)
    }

    // Since its a full screen web view we hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

/// A concrete implimentation of `WKNavigationDelegate` which calls a completion
/// handler when an 'interesting' URL is loaded.
/// All non interesting URL's are allowed to load
class InterestingWebViewDelegate: NSObject, WKNavigationDelegate {

    let completion: ((URLRequest) -> Void)
    let urlOfInterest: String

    /// Create a WKNavigationDelegate
    ///
    /// - Parameters:
    ///   - completion: The Handler to be called when an interesting URL is being loaded
    ///   - urlOfInterest: The "String" of the URL to look for
    init(completion: @escaping ((URLRequest) -> Void), urlOfInterest: String) {
        self.completion = completion
        self.urlOfInterest = urlOfInterest
        super.init()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decideIf(requestIsInteresting: navigationAction.request, AndCallCorrectHandler: decisionHandler)
    }

    /// Decides if a URLRequest meets our "interesting" criteria.
    ///
    /// Declared internal for testing purposes, can't test caller because no way
    /// to instantiate WKNavigationAction
    ///
    /// - Parameters:
    ///   - request: The request to examine
    ///   - decisionHandler: The navigation 'decision' handler, Non-interesting 
    ///                      URLs are called with `.allow` to continue the web
    ///                      loading, while interesting URL's are `.cancel`ed
    ///                      The object's completion handler is then called
    func decideIf(requestIsInteresting request: URLRequest,
                  AndCallCorrectHandler decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if isInteresting(request: request) {
            completion(request)
            decisionHandler(.cancel)
        }
        decisionHandler(.allow)
    }

    private func isInteresting(request: URLRequest) -> Bool {
        guard let  url = request.url else {
            print("🐛 Request has no URL! \(request)")
            return false
        }

        if url.absoluteString.hasPrefix(urlOfInterest) {
            return true
        }
        return false
    }

}
