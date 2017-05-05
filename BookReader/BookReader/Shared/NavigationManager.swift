import UIKit

@objc class NavigationManager: NSObject {
  static let shared = NavigationManager()
  
  var navigationHelpers = [UINavigationController : NavigationHelper]()
  
  override init() {
    super.init()
    
    observe()
  }
  
  func navigationHelper(for navigationController: UINavigationController) -> NavigationHelper {
    if let exsistingNavigationHelper = navigationHelpers[navigationController] {
      return exsistingNavigationHelper
    }
    else {
      navigationController.delegate = self
      let newNavigationHelper = NavigationHelper(for: navigationController)
      navigationHelpers[navigationController] = newNavigationHelper
      return newNavigationHelper
    }
  }
  
  private func observe() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(resetHelpers),
                                           name: .UIApplicationWillResignActive,
                                           object: nil)
  }
  
  @objc private func resetHelpers() {
    navigationHelpers.values.forEach { $0.reset() }
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
    guard let navigationController = navigationController else { return nil }
    
    return NavigationManager.shared.navigationHelper(for: navigationController)
  }
}
