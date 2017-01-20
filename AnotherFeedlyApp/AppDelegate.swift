import UIKit

@objc(AppDelegate)
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow.configure()

    lazy var appCoordinator: AppCoordinator = {
        guard let window = self.window else {
            fatalError("🐛 Error Window was not Configured Correctly")
        }
        return AppCoordinator(window: window)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        appCoordinator.appLaunched(options: launchOptions)
        return true
    }
}

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {

}
