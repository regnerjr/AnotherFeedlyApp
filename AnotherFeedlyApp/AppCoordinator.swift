import UIKit

class AppCoordinator {

    let window: UIWindow

    let auth = Auth()
    lazy var feedly: Feedly = { Feedly(auth: self.auth) }()

    init(window: UIWindow) {
        self.window = window
    }

    func appLaunched(options: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        let signInVC = StoryboardScene.Main.instantiateWebViewController()
        let signInWebViewDelegate = InterestingWebViewDelegate(completion: signInComplete,
                                                          urlOfInterest: auth.redirectUri)
        signInVC.urlRequest = feedly.signInRequest
        signInVC.webViewDelegate = signInWebViewDelegate
        window.rootViewController = signInVC
    }

    func signInComplete(withRedirectRequest request: URLRequest) {
        print("OMG Sign In Complete")
        guard let code = request.extractAuthCodeFromRedirect() else {
            print("Called us back but with no code?")
            return
        }
        feedly.requestToken(withCode: code, completion: saveToken)
    }

    func saveToken(token: FeedlyToken) {
        print("SavingToken")
    }

}

extension URLRequest {
    func extractAuthCodeFromRedirect() -> String? {
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

