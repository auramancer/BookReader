import UIKit

class NavigationControllerSpy: UINavigationController {
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    delegate?.navigationController?(self, willShow: viewController, animated: animated)
    viewControllers.append(viewController)
    delegate?.navigationController?(self, didShow: viewController, animated: animated)
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let count = viewControllers.count
    let newTopIndex = count > 1 ? count - 1 : 0
    
    delegate?.navigationController?(self, willShow: viewController, animated: animated)
    viewControllers.append(viewController)
    delegate?.navigationController?(self, didShow: viewController, animated: animated)
    
    return nil
  }
  
  override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    return []
  }
  
  override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    return []
  }
  
  var _presentedViewController: UIViewController?
  
  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    _presentedViewController = viewControllerToPresent
    completion?()
  }
  
  override var presentedViewController: UIViewController? {
    return _presentedViewController
  }
  
//
//  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//    
//  }
}
