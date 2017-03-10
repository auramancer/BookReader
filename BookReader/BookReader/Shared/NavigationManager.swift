import UIKit

@objc class NavigationManager: NSObject {
  static let shared = NavigationManager()
  
  var navigationHelper: NavigationHelper?
  
  var navigationController: UINavigationController? {
    didSet {
      resetHelper()
    }
  }
  
  override init() {
    super.init()
    
    resetHelper()
    observe()
  }
  
  @objc private func resetHelper() {
    if let nav = navigationController {
      navigationHelper = NavigationHelper(for: nav)
      nav.delegate = self
    }
  }
  
  private func observe() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(resetHelper),
                                           name: .UIApplicationWillResignActive,
                                           object: nil)
  }
}

extension NavigationManager: UINavigationControllerDelegate {
  struct Notification {
    static let willShowViewController = "NavigationControllerWillShowViewController"
    static let didShowViewController = "NavigationControllerDidShowViewController"
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    let notification = NSNotification.Name(Notification.willShowViewController)
    NotificationCenter.default.post(name: notification, object: viewController)
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController,
                            animated: Bool) {
    let notification = NSNotification.Name(Notification.didShowViewController)
    NotificationCenter.default.post(name: notification, object: viewController)
  }
}

extension UIViewController {
  var navigationHelper: NavigationHelper? {
    return NavigationManager.shared.navigationHelper
  }
}
