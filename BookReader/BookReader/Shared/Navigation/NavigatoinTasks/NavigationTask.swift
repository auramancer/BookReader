import UIKit

protocol Setupable {
  func setup(with data: Any?)
}

class NavigationTask {
  var navigationController: UINavigationController!
  var data: Any?
  var animated: Bool = true
  var completion: (() -> Void)?
  var expectedTopViewController: UIViewController?
  
  func execute() {
  }
  
  func willNavigate(to viewController: UIViewController) {
    setUp(viewController)
    expectedTopViewController = viewController
  }
  
  func setUp(_ viewController: UIViewController) {
    if let setupable = viewController as? Setupable {
      setupable.setup(with: self.data)
    }
  }
}
