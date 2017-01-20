import UIKit

extension UIWindow {
    static func configure() -> UIWindow {
        let screenFrame = UIScreen.main.bounds
        let window = UIWindow(frame: screenFrame)
        window.backgroundColor = .blue
        window.makeKeyAndVisible()
        return window
    }
}
