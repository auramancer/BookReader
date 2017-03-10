import UIKit

protocol ViewControllerFindable {
  func find(in viewContollers: [UIViewController]) -> UIViewController?
}

protocol ViewControllerInstantiable {
  func instantiate() -> UIViewController?
}

typealias PopToOrPushable = ViewControllerFindable & ViewControllerInstantiable

class PopToOrPushTask: PopTask {
  var instantiater: PopToOrPushable!
  
  override func execute() {
    if let viewController = viewControllerPopTo,
      canPopTo(viewController) {
      doPopTo(viewController)
    }
    else {
      push()
    }
  }
  
  private func push() {
    guard let viewController = instantiater.instantiate() else { return }
    
    willNavigate(to: viewController)
    navigationController.pushViewController(viewController, animated: animated)
  }
  
  override var viewControllerPopTo: UIViewController? {
    return instantiater.find(in: navigationController.viewControllers.reversed())
  }
}

extension NavigationHelper {
  func popToOrPush(_ instantiater: PopToOrPushable, data: Any? = nil) -> NavigationHelper {
    popToOrPush(instantiater: instantiater, data: data, animated: false)
    return self
  }
  
  func popToOrPushAnimated(_ instantiater: PopToOrPushable, data: Any? = nil) -> NavigationHelper {
    popToOrPush(instantiater: instantiater, data: data, animated: true)
    return self
  }
  
  private func popToOrPush(instantiater: PopToOrPushable, data: Any?, animated: Bool) {
    let task = PopToOrPushTask()
    task.instantiater = instantiater
    enqueueTask(task, data: data, animated: animated)
  }
}
