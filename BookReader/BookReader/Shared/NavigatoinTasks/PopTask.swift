import UIKit

class PopTask: NavigationTask {
  override func execute() {
    if let viewController = viewControllerPopTo,
      canPopTo(viewController) {
      doPopTo(viewController)
    }
    else {
      completion?()
    }
  }
  
  func canPopTo(_ viewController: UIViewController) -> Bool {
    return viewController != navigationController.topViewController
  }
  
  func doPopTo(_ viewController: UIViewController) {
    willNavigate(to: viewController)
    _ = navigationController.popToViewController(viewController, animated: animated)
  }
  
  var viewControllerPopTo: UIViewController? {
    let viewControllers = navigationController.viewControllers
    let count = viewControllers.count
    return count > 1 ? viewControllers[count-2] : viewControllers.first
  }
}

extension NavigationHelper {
  func pop(data: Any? = nil) -> NavigationHelper {
    pop(data: data, animated: false)
    return self
  }
  
  func popAnimated(data: Any? = nil) -> NavigationHelper {
    pop(data: data, animated: true)
    return self
  }
  
  private func pop(data: Any?, animated: Bool) {
    let task = PopTask()
    enqueueTask(task, data: data, animated: animated)
  }
}

class PopToRootTask: PopTask {
  override var viewControllerPopTo: UIViewController? {
    return navigationController.viewControllers.first
  }
}

extension NavigationHelper {
  func popToRoot(data: Any? = nil) -> NavigationHelper {
    popToRoot(data: data, animated: false)
    return self
  }
  
  func popToRootAnimated(data: Any? = nil) -> NavigationHelper {
    popToRoot(data: data, animated: true)
    return self
  }
  
  private func popToRoot(data: Any?, animated: Bool) {
    let task = PopToRootTask()
    enqueueTask(task, data: data, animated: animated)
  }
}

typealias NavigationCondition = (UIViewController) -> Bool

class PopToTask: PopTask {
  var stopCondition: NavigationCondition!
  
  override var viewControllerPopTo: UIViewController? {
    return navigationController.viewControllers.reversed().first { stopCondition($0) }
  }
}

extension NavigationHelper {
  func popTo(_ stopCondition: @escaping (NavigationCondition), data: Any? = nil) -> NavigationHelper {
    popTo(stopCondition: stopCondition, data: data, animated: false)
    return self
  }
  
  func popToAnimated(_ stopCondition: @escaping (NavigationCondition), data: Any? = nil) -> NavigationHelper {
    popTo(stopCondition: stopCondition, data: data, animated: true)
    return self
  }
  
  private func popTo(stopCondition: @escaping NavigationCondition, data: Any?, animated: Bool) {
    let task = PopToTask()
    task.stopCondition = stopCondition
    enqueueTask(task, data: data, animated: animated)
  }
}

class PopWhileTask: PopTask {
  var stopCondition: NavigationCondition!
  
  override var viewControllerPopTo: UIViewController? {
    return navigationController.viewControllers.reversed().first { !stopCondition($0) }
  }
}

extension NavigationHelper {
  func popWhile(_ stopCondition: @escaping (NavigationCondition), data: Any? = nil) -> NavigationHelper {
    popWhile(stopCondition: stopCondition, data: data, animated: false)
    return self
  }
  
  func popWhileAnimated(_ stopCondition: @escaping (NavigationCondition), data: Any? = nil) -> NavigationHelper {
    popWhile(stopCondition: stopCondition, data: data, animated: true)
    return self
  }
  
  private func popWhile(stopCondition: @escaping NavigationCondition, data: Any?, animated: Bool) {
    let task = PopWhileTask()
    task.stopCondition = stopCondition
    enqueueTask(task, data: data, animated: animated)
  }
}
