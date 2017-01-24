import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var webViewDelegate: UIWebViewDelegate? //swiftlint:disable:this weak_delegate

    var spotify: Spotify!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard spotify != nil else {
            fatalError("🐛Spotify Object Not Initialized")
        }
        webView.delegate = webViewDelegate
        webView.loadRequest(spotify.signInRequest)
    }
}

class SignInWebViewDelegate: NSObject, UIWebViewDelegate {

    let signInComplete: ((String?) -> Void)
    let redirectURI: String

    init(signInComplete: @escaping ((String?) -> Void), redirectURI: String) {
        self.signInComplete = signInComplete
        self.redirectURI = redirectURI
        super.init()
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {

        if isSignInRedirect(request: request) {
            let code = request.extractCode()
            signInComplete(code)
            return false
        }

        return true
    }

    private func isSignInRedirect(request: URLRequest) -> Bool {
        guard let  url = request.url else {
            print("🐛 Request has no URL! \(request)")
            return false
        }

        if url.absoluteString.hasPrefix(redirectURI) {
            return true
        }
        return false
    }
}

extension URLRequest {
    func extractCode() -> String? {
        guard let url = url else { return nil }
        let components = NSURLComponents(string: url.absoluteString)
        guard let items = components?.queryItems else {
            return nil
        }
        let code = items.filter { (item) -> Bool in
            return item.name == "code"
        }
        return code.first?.value
    }
}
