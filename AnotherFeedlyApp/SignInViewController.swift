import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    weak var webViewDelegate: UIWebViewDelegate?

    let spotify = Spotify()

    override func viewDidLoad() {
        webView.delegate = webViewDelegate
        webView.loadRequest(spotify.signInRequest)
    }
}

class SignInWebViewDelegate: NSObject, UIWebViewDelegate {

    let signInComplete: (() -> Void)

    init(signInComplete: @escaping (() -> Void)) {
        self.signInComplete = signInComplete
        super.init()
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {

        if isSignInRedirect(request: request) {
            signInComplete()
            return false
        }

        return true
    }

    private func isSignInRedirect(request: URLRequest) -> Bool {
        guard let  url = request.url else {
            print("🐛 Request has no URL! \(request)")
            return false
        }

        if url.absoluteString.hasPrefix(Auth.redirectUri) {
            return true
        }
        return false
    }
}
