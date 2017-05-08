import UIKit

class DismissTask: NavigationTask {
  override func execute() {
    if navigationController.presentedViewController != nil {
      navigationController.dismiss(animated: animated) { [weak self] in
        self?.completion?()
      }
    }
    else {
      completion?()
    }
  }
}

extension NavigationHelper {
  func dismiss() -> NavigationHelper {
    dismiss(animated: false)
    return self
  }
  
  func dismissAnimated() -> NavigationHelper {
    dismiss(animated: true)
    return self
  }
  
  private func dismiss(animated: Bool) {
    let task = DismissTask()
    enqueueTask(task, data: nil, animated: animated)
  }
}
