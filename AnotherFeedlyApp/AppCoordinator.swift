import UIKit

class AppCoordinator {

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func appLaunched(options: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        let signInVC = StoryboardScene.Main.instantiateSignInViewController()
        let signInWebViewDelegate = SignInWebViewDelegate(signInComplete: signInComplete)

        signInVC.webViewDelegate = signInWebViewDelegate
        window.rootViewController = signInVC
    }

    func signInComplete() {
        print("😎 Sign In Is Complete and The Coordinator Knows it")
    }

}
