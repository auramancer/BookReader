import UIKit

class PushTask: NavigationTask {
  var viewController: UIViewController!
  
  override func execute() {
    willNavigate(to: viewController)
    navigationController.pushViewController(viewController, animated: animated)
  }
}

extension NavigationHelper {
  func push(_ viewController: UIViewController, data: Any? = nil) -> NavigationHelper {
    push(viewController: viewController, data: data, animated: false)
    return self
  }
  
  func pushAnimated(_ viewController: UIViewController, data: Any? = nil) -> NavigationHelper {
    push(viewController: viewController, data: data, animated: true)
    return self
  }
  
  private func push(viewController: UIViewController, data: Any?, animated: Bool) {
    let task = PushTask()
    task.viewController = viewController
    enqueueTask(task, data: data, animated: animated)
  }
}
