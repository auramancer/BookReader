import UIKit

class ViewController: UIViewController {
  typealias Tag = String
  typealias Module = String
  
  var module: Module = ""
  var tag: Tag = ""
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationCompletion?(self)NavigationSequence
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    navigationCompletion?(self)
  }
  
  var navigationCompletion: ((ViewController) -> Void)?
  
  func navigator() -> Navigator {
    let navigator = Navigator()
    navigator.navigationController = (navigationController ?? presentingViewController?.navigationController)!
    navigator.viewController = self
    return navigator
  }
}

class NavigationSequence {
  
  var navigationController: UINavigationController!
  var viewController: ViewController!
  var navigationBlock: ((Void) -> Void)?
  var animated = true
  var canNavigate = true {
    didSet {
      if !oldValue && canNavigate {
        navigate()
      }
    }
  }
  
  @discardableResult
  func pushAnimated(_ viewController: ViewController) -> Navigator {
    return scheduleNavigation(viewController: viewController, navigationBlock: doPush, animated: true)
  }
  
  @discardableResult
  func push(_ viewController: ViewController) -> Navigator {
    return scheduleNavigation(viewController: viewController, navigationBlock: doPush, animated: false)
  }
  
  @discardableResult
  func popAnimated() -> Navigator {
    let newTopViewController = topViewControllerAfterPop()
    return scheduleNavigation(viewController: newTopViewController, navigationBlock: doPop, animated: true)
  }
  
  func topViewControllerAfterPop() -> ViewController {
    let viewControllers = navigationController.viewControllers
    let count = viewControllers.count
    let newTopIndex = count > 1 ? count - 2 : 0
    return viewControllers[newTopIndex] as! ViewController
  }
  
  @discardableResult
  func pop() -> Navigator {
    let newTopViewController = topViewControllerAfterPop()
    return scheduleNavigation(viewController: newTopViewController, navigationBlock: doPop, animated: false)
  }
  
  @discardableResult
  func presentAnimated(_ viewController: ViewController) -> Navigator {
    return scheduleNavigation(viewController: viewController, navigationBlock: doPresent, animated: true)
  }
  
  @discardableResult
  func present(_ viewController: ViewController) -> Navigator {
    return scheduleNavigation(viewController: viewController, navigationBlock: doPresent, animated: false)
  }
  
  @discardableResult
  func dismissAnimated() -> Navigator {
    let newTopViewController = topViewControllerAfterDismiss()
    return scheduleNavigation(viewController: newTopViewController, navigationBlock: doDismiss, animated: true)
  }
  
  func topViewControllerAfterDismiss() -> ViewController {
    var presentingVC = viewController.presentingViewController!
    if let nav = presentingVC as? UINavigationController {
      presentingVC = nav.topViewController!
    }
    return presentingVC as! ViewController
  }
  
  @discardableResult
  func dismiss() -> Navigator {
    let newTopViewController = topViewControllerAfterDismiss()
    return scheduleNavigation(viewController: newTopViewController, navigationBlock: dismissTask, animated: false)
  }
  
  private func scheduleNavigation(viewController: ViewController, navigationBlock: ((Void) -> Void)?, animated: Bool) -> Navigator {
    self.viewController = viewController
    self.navigationBlock = navigationBlock
    self.animated = animated

    let navigator = nextNavigator()
    
    if canNavigate {
      navigate()
    }
    
    return navigator
  }
  
  private func nextNavigator() -> Navigator {
    let navigator = Navigator()
    navigator.navigationController = navigationController
    navigator.canNavigate = false
    
    viewController.navigationCompletion = { viewController in
      self.viewController  = viewController
      navigator.canNavigate = true
    }
    
    return navigator
  }
  
  private func doPush() {
    navigationController.pushViewController(viewController, animated: animated)
  }
  
  private func doPop() {
    navigationController.popViewController(animated: animated)
  }
  
  private func doPresent() {
    DispatchQueue.main.async {
      self.navigationController.present(self.viewController, animated: self.animated, completion: nil)
    }
  }
  
  private func doDismiss() {
    DispatchQueue.main.async {
      self.navigationController.dismiss(animated: self.animated, completion: nil)
    }
  }
  
  private func navigate() {
    navigationBlock?()
  }
}

class Blue: ViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue
    tag = "blue"
  }
  
  @IBAction func tap(_ sender: Any) {
    navigator().pushAnimated(Red()).popAnimated().presentAnimated(Yellow()).dismissAnimated()
  }
}

class Red: ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.red
    tag = "red"
  }
}

class Green: ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.green
    tag = "green"
  }
}

class Yellow: ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.yellow
    tag = "yellow"
    
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(close), for: .touchUpInside)
    addView(button, to: view)
  }
  
  func close() {
//    dismissAnimated() { viewController in
//      viewController.popToRootAnimated()
//    }
  }
}
