// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func performSegue<S: StoryboardSegueType>(segue: S, sender: AnyObject? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case SignInViewControllerScene = "signInViewController"
    static func instantiateSignInViewController() -> AnotherFeedlyApp.SignInViewController {
      guard let vc = StoryboardScene.Main.SignInViewControllerScene.viewController() as? AnotherFeedlyApp.SignInViewController
      else {
        fatalError("ViewController 'signInViewController' is not of the expected class AnotherFeedlyApp.SignInViewController.")
      }
      return vc
    }

    case ViewControllerScene = "viewController"
    static func instantiateViewController() -> AnotherFeedlyApp.ViewController {
      guard let vc = StoryboardScene.Main.ViewControllerScene.viewController() as? AnotherFeedlyApp.ViewController
      else {
        fatalError("ViewController 'viewController' is not of the expected class AnotherFeedlyApp.ViewController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
}
