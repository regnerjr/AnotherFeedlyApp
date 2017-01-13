import UIKit

enum StoryboardIDs: String {
    case signInViewController
    case viewController
}

enum Storyboard {

    private static var main: UIStoryboard = { return UIStoryboard(name: "Main", bundle: nil) }()

    private static func instantiateMainSBVC(identifier: StoryboardIDs) -> UIViewController {
        return Storyboard.main.instantiateViewController(withIdentifier: identifier.rawValue)
    }

    static func instantiateSignInViewController() -> SignInViewController {
        guard let svc = Storyboard.instantiateMainSBVC(identifier: .signInViewController)
            as? SignInViewController else {
                fatalError("🐛 Sign In View Controller is not Sign In View Controller")
        }
        return svc
    }

}
