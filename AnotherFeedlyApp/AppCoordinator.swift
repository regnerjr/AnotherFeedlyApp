import UIKit

class AppCoordinator {

    let window: UIWindow

    let auth = Auth()
    lazy var feedly: Feedly = { Feedly(auth: self.auth) }()

    init(window: UIWindow) {
        self.window = window
    }

    func appLaunched(options: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        let signInVC = StoryboardScene.Main.instantiateSignInViewController()
        let signInWebViewDelegate = SignInWebViewDelegate(signInComplete: signInComplete,
                                                          redirectURI: auth.redirectUri)
        signInVC.feedly = feedly
        signInVC.webViewDelegate = signInWebViewDelegate
        window.rootViewController = signInVC
    }

    func signInComplete(code: String?) {
        print("OMG Sign In Complete")

        guard let code = code else {
            print("Called us back but with no code?")
            return
        }

        feedly.requestToken(withCode: code, completion: saveToken)

        //need to now try to get an auth Token
        // POST /v3/auth/token

    }

    func saveToken(token: FeedlyToken) {
        print("SavingToken")
    }

}
