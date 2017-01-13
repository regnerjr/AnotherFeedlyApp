import UIKit

class TestingAppDelegate: UIResponder, UIApplicationDelegate {

}

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = AppDelegate.configureWindow()

    lazy var appCoordinator: AppCoordinator = {
        guard let window = self.window else {
            fatalError("🐛 Error Window was not Configured Correctly")
        }
        return AppCoordinator(window: window)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil)
        -> Bool {

        appCoordinator.appLaunched(options: launchOptions)
        return true
    }

    static func configureWindow() -> UIWindow {
        let screenFrame = UIScreen.main.bounds
        let window = UIWindow(frame: screenFrame)
        window.backgroundColor = .blue
        window.makeKeyAndVisible()
        return window
    }
}

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
