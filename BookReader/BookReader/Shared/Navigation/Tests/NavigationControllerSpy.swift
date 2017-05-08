import UIKit

class NavigationControllerSpy: UINavigationController {
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    delegate?.navigationController?(self, willShow: viewController, animated: animated)
    viewControllers.append(viewController)
    delegate?.navigationController?(self, didShow: viewController, animated: animated)
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let index = viewControllers.count - 2
    return popToViewController(at: index, animated: animated)?.first
  }
  
  override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    return popToViewController(at: 0, animated: animated)
  }

  override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    let index = viewControllers.index(of: viewController)
    return popToViewController(at: index, animated: animated)
  }
  
  private func popToViewController(at index: Int?, animated: Bool) -> [UIViewController]? {
    guard let index = index,
      index >= 0 && index < viewControllers.count - 1 else { return nil }
    
    let popped = Array(viewControllers.suffix(from: index + 1))
    let newTop = viewControllers[index]
    
    delegate?.navigationController?(self, willShow: newTop, animated: animated)
    viewControllers = Array(viewControllers.prefix(through: index))
    delegate?.navigationController?(self, didShow: newTop, animated: animated)
    
    return popped
  }
  
  private var _presentedViewController: UIViewController?
  
  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    _presentedViewController = viewControllerToPresent
    completion?()
  }
  
  override var presentedViewController: UIViewController? {
    get {
      return _presentedViewController
    }
    set {
      _presentedViewController = newValue
    }
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    _presentedViewController = nil
    completion?()
  }
}
