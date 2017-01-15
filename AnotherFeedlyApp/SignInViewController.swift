import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    weak var webViewDelegate: UIWebViewDelegate?

    var spotify: Spotify!

    override func viewDidLoad() {
        guard spotify != nil else {
            fatalError("🐛Spotify Object Not Initialized")
        }
        webView.delegate = webViewDelegate
        webView.loadRequest(spotify.signInRequest)
    }
}

class SignInWebViewDelegate: NSObject, UIWebViewDelegate {

    let signInComplete: (() -> Void)
    let redirectURI: String

    init(signInComplete: @escaping (() -> Void), redirectURI: String) {
        self.signInComplete = signInComplete
        self.redirectURI = redirectURI
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

        if url.absoluteString.hasPrefix(redirectURI) {
            return true
        }
        return false
    }
}
