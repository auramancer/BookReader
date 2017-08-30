import UIKit

class NavigationManager: NSObject {
  static let shared = NavigationManager()
  
  var mainNavigationController: UINavigationController?
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

extension Notification.Name {
  static let willShowViewController = Notification.Name("willShowViewController")
  static let didShowViewController = Notification.Name("didShowViewController")
}

extension NavigationManager: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    NotificationCenter.default.post(name: .willShowViewController, object: viewController)
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController,
                            animated: Bool) {
    NotificationCenter.default.post(name: .didShowViewController, object: viewController)
  }
}

extension UIViewController {
  var navigationHelper: NavigationHelper {
    let nav = navigationController ?? NavigationManager.shared.mainNavigationController!
    return NavigationManager.shared.navigationHelper(for: nav)
  }
}
