import UIKit

class PresentTask: NavigationTask {
  var viewController: UIViewController!
  
  override func execute() {
    setUp(viewController)
    
    navigationController.present(viewController, animated: animated) { [weak self] in
      self?.completion?()
    }
  }
}

extension NavigationHelper {
  func present(_ viewController: UIViewController, data: Any? = nil) -> NavigationHelper {
    present(viewController: viewController, data: data, animated: false)
    return self
  }
  
  func presentAnimated(_ viewController: UIViewController, data: Any? = nil) -> NavigationHelper {
    present(viewController: viewController, data: data, animated: true)
    return self
  }
  
  private func present(viewController: UIViewController, data: Any?, animated: Bool) {
    let task = PresentTask()
    task.viewController = viewController
    enqueueTask(task, data: data, animated: animated)
  }
}
