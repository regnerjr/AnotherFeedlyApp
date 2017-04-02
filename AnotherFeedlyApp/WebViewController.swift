import UIKit
import WebKit

class WebViewController: UIViewController {

    lazy var webView: WKWebView = WKWebView(frame: UIScreen.main.bounds, configuration: WKWebViewConfiguration())
    var webViewDelegate: WKNavigationDelegate? //swiftlint:disable:this weak_delegate

    var urlRequest: URLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = webViewDelegate
        webView.load(urlRequest)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

class InterestingWebViewDelegate: NSObject, WKNavigationDelegate {

    let completion: ((URLRequest) -> Void)
    let urlOfInterest: String

    init(completion: @escaping ((URLRequest) -> Void), urlOfInterest: String) {
        self.completion = completion
        self.urlOfInterest = urlOfInterest
        super.init()
    }

    //swiftlint:disable:next line_length
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decideIf(requestIsInteresting: navigationAction.request, AndCallCorrectHandler: decisionHandler)
    }

    //declared internal for testing purposes, cant test caller because no way to instantiate WKNavigationAction
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
