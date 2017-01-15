import UIKit

class AppCoordinator {

    let window: UIWindow

    let auth = Auth()
    lazy var spotify: Spotify = {Spotify(auth: self.auth)}()

    init(window: UIWindow) {
        self.window = window
    }

    func appLaunched(options: [UIApplicationLaunchOptionsKey : Any]? = nil) {

        let signInVC = StoryboardScene.Main.instantiateSignInViewController()
        let signInWebViewDelegate = SignInWebViewDelegate(signInComplete: signInComplete,
                                                          redirectURI: auth.redirectUri)
        signInVC.spotify = spotify
        signInVC.webViewDelegate = signInWebViewDelegate
        window.rootViewController = signInVC
    }

    func signInComplete() {
        print("😎 Sign In Is Complete and The Coordinator Knows it")
    }

}
