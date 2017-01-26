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

    func signInComplete(code: String?) {
        print("OMG Sign In Complete")

        guard let code = code else {
            print("Called us back but with no code?")
            return
        }

        spotify.requestToken(withCode: code, completion: saveToken)

        //need to now try to get an auth Token
        // POST /v3/auth/token

    }

    func saveToken(token: TokenResponse) {
        print("SavingToken")
    }

}
