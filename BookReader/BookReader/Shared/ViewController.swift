import UIKit

class ViewController: UIViewController {
  typealias Tag = String
  typealias Module = String
  
  var module: Module = ""
  var tag: Tag = ""
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationCompletion?()
    navigationCompletion = nil
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    navigationCompletion?()
    navigationCompletion = nil
  }
  
  var navigationCompletion: ((Void) -> Void)?
}

class NavigationTask {
  var sequence: NavigationSequence!
  var animated: Bool!
  
  init(sequence: NavigationSequence, animated: Bool = false) {
    self.sequence = sequence
    self.animated = animated
  }
  
  func perform() {
    // abstract
  }
}

class PushTask: NavigationTask {
  var viewControllerToPush: ViewController!
  
  init(viewControllerToPush: ViewController, sequence: NavigationSequence, animated: Bool = false) {
    super.init(sequence: sequence, animated: animated)
    
    self.viewControllerToPush = viewControllerToPush
  }
  
  override func perform() {
    print(self)
    
    viewControllerToPush.navigationCompletion = {
      DispatchQueue.main.async {
        self.sequence.navigate()
      }
    }
    
    sequence.navigationController.pushViewController(viewControllerToPush, animated: animated)
  }
}

class PopTask: NavigationTask {
  override func perform() {
    topViewControllerAfterPop.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.popViewController(animated: animated)
  }
  
  var topViewControllerAfterPop: ViewController {
    let viewControllers = sequence.navigationController.viewControllers
    let count = viewControllers.count
    let newTopIndex = count > 1 ? count - 2 : 0
    let top = viewControllers[newTopIndex] as! ViewController
    return top
  }
}

class PresentTask: NavigationTask {
  var viewControllerToPresent: ViewController!
  
  init(viewControllerToPresent: ViewController, sequence: NavigationSequence, animated: Bool = false) {
    super.init(sequence: sequence, animated: animated)
    
    self.viewControllerToPresent = viewControllerToPresent
  }
  
  override func perform() {
    viewControllerToPresent.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.present(viewControllerToPresent, animated: animated, completion: nil)
  }
}

class DismissTask: NavigationTask {
  override func perform() {
    topViewControllerAfterDismiss.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.dismiss(animated: animated, completion: nil)
  }
  
  var topViewControllerAfterDismiss: ViewController {
    return sequence.navigationController.topViewController as! ViewController
  }
}

class NavigationSequence {
  var navigationController: UINavigationController!
  var viewController: ViewController!
  var sequence = [NavigationTask]()
  
  class func instantiate(for viewController: ViewController) -> NavigationSequence {
    let sequence = NavigationSequence()
    sequence.navigationController = (viewController.navigationController ?? viewController.presentingViewController as? UINavigationController)!
    sequence.viewController = viewController
    return sequence
  }
  
  @discardableResult
  func pushAnimated(_ viewController: ViewController) -> NavigationSequence {
    let task = PushTask(viewControllerToPush: viewController, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func push(_ viewController: ViewController) -> NavigationSequence {
    let task = PushTask(viewControllerToPush: viewController, sequence: self)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func popAnimated() -> NavigationSequence {
    let task = PopTask(sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func pop() -> NavigationSequence {
    let task = PopTask(sequence: self)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func presentAnimated(_ viewController: ViewController) -> NavigationSequence {
    let task = PresentTask(viewControllerToPresent: viewController, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func present(_ viewController: ViewController) -> NavigationSequence {
    let task = PresentTask(viewControllerToPresent: viewController, sequence: self)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func dismissAnimated() -> NavigationSequence {
    let task = DismissTask(sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func dismiss() -> NavigationSequence {
    let task = DismissTask(sequence: self)
    sequence.append(task)
    return self
  }
  
  func navigate() {
    guard sequence.count > 0 else { return }
    
    let task = sequence.removeFirst()
    task.perform()
  }
}

class PopToRootTask: NavigationTask {
  override func perform() {
    rootViewController.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.popToRootViewController(animated: animated)
  }
  
  var rootViewController: ViewController {
    return sequence.navigationController.viewControllers.first as! ViewController
  }
}

extension NavigationSequence {
  @discardableResult
  func popToRootAnimated() -> NavigationSequence {
    let task = PopToRootTask(sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func popToRoot() -> NavigationSequence {
    let task = PopToRootTask(sequence: self)
    sequence.append(task)
    return self
  }
}

class Blue: ViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue
    tag = "blue"
  }
  
  @IBAction func tap(_ sender: Any) {
    NavigationSequence.instantiate(for: self).push(Red()).push(Green()).present(Yellow()).navigate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      NavigationSequence.instantiate(for: self).dismissAnimated().popToRootAnimated().presentAnimated(Yellow()).navigate()
    }
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
    NavigationSequence.instantiate(for: self).dismissAnimated().navigate()
  }
}
