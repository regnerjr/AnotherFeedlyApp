import UIKit

class AppCoordinator {

    let window: UIWindow

    let auth = Auth()
    lazy var feedly: FeedlySignIn = { FeedlySignIn(auth: self.auth) }()

    init(window: UIWindow) {
        self.window = window
    }

    func appLaunched(options: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        let signInVC = StoryboardScene.Main.instantiateWebViewController()
        let signInWebViewDelegate = InterestingWebViewDelegate(completion: feedly.signInFinished,
                                                          urlOfInterest: auth.redirectUri)
        signInVC.urlRequest = feedly.signInRequest
        signInVC.webViewDelegate = signInWebViewDelegate
        window.rootViewController = signInVC
    }

}
