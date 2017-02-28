import UIKit

class ViewController: UIViewController {
  struct Tag: Hashable, CustomStringConvertible {
    let group: String
    let view: String
    
    var description: String {
      return "\(group).\(view)"
    }
    
    var hashValue: Int {
      return description.hashValue
    }

    static func ==(lhs: Tag, rhs: Tag) -> Bool {
      return lhs.description == rhs.description
    }
    
    init(_ description: String) {
      let parts = description.components(separatedBy: ".")
      if parts.count == 2 {
        self.group = parts[0]
        self.view = parts[1]
      }
      else {
        self.group = ""
        self.view = ""
      }
    }
  }
  
  var tag: Tag {
    return Tag(".")
  }
  
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
  var data: Any?
  var sequence: NavigationSequence
  var animated: Bool
  
  init(sequence: NavigationSequence, animated: Bool = false) {
    self.data = nil
    self.sequence = sequence
    self.animated = animated
  }

  init(data: Any?, sequence: NavigationSequence, animated: Bool = false) {
    self.data = data
    self.sequence = sequence
    self.animated = animated
  }
  
  func perform() {
    // abstract
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
  
  func navigate() {
    guard sequence.count > 0 else { return }
    
    let task = sequence.removeFirst()
    DispatchQueue.main.async {
      task.perform()
    }
  }
}

class PushTask: NavigationTask {
  var viewControllerToPush: ViewController
  
  init(viewController: ViewControllerConvertible, data: Any?, sequence: NavigationSequence, animated: Bool = false) {
    viewControllerToPush = viewController.viewController
    
    super.init(data: data, sequence: sequence, animated: animated)
  }
  
  override func perform() {
    viewControllerToPush.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.pushViewController(viewControllerToPush, animated: animated)
  }
}

extension NavigationSequence {
  @discardableResult
  func pushAnimated(_ viewController: ViewControllerConvertible, data: Any? = nil) -> NavigationSequence {
    let task = PushTask(viewController: viewController, data: data, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func push(_ viewController: ViewControllerConvertible, data: Any? = nil) -> NavigationSequence {
    let task = PushTask(viewController: viewController, data: data, sequence: self)
    sequence.append(task)
    return self
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

extension NavigationSequence {
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
}

class PresentTask: NavigationTask {
  var viewControllerToPresent: ViewController
  
  init(viewController: ViewControllerConvertible, data: Any? = nil, sequence: NavigationSequence, animated: Bool = false) {
    viewControllerToPresent = viewController.viewController
    
    super.init(data: data, sequence: sequence, animated: animated)
  }
  
  override func perform() {
    viewControllerToPresent.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.present(viewControllerToPresent, animated: animated, completion: nil)
  }
}

extension NavigationSequence {
  @discardableResult
  func presentAnimated(_ viewController: ViewControllerConvertible, data: Any? = nil) -> NavigationSequence {
    let task = PresentTask(viewController: viewController, data: data, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func present(_ viewController: ViewControllerConvertible, data: Any? = nil) -> NavigationSequence {
    let task = PresentTask(viewController: viewController, data: data, sequence: self)
    sequence.append(task)
    return self
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

extension NavigationSequence {
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

class PopToTask: NavigationTask {
  var viewControllerPopTo: ViewController
  
  init(viewController: ViewControllerConvertible, sequence: NavigationSequence, animated: Bool = false) {
    viewControllerPopTo = viewController.viewController
    
    super.init(data: nil, sequence: sequence, animated: animated)
  }
  
  override func perform() {
    guard let topViewController = topViewControllerAfterPop else { return }
    
    topViewController.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.popToViewController(topViewController, animated: animated)
  }
  
  var topViewControllerAfterPop: ViewController? {
    let viewControllers = sequence.navigationController.viewControllers
    for index in (0..<viewControllers.count).reversed() {
      let vc = viewControllers[index] as! ViewController
      if vc.tag == viewControllerPopTo.tag {
        return vc
      }
    }
    
    return nil
  }
}

extension NavigationSequence {
  @discardableResult
  func popToAnimated(_ viewController: ViewControllerConvertible) -> NavigationSequence {
    let task = PopToTask(viewController: viewController, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func popTo(_ viewController: ViewControllerConvertible) -> NavigationSequence {
    let task = PopToTask(viewController: viewController, sequence: self)
    sequence.append(task)
    return self
  }
}

class PopWhileTask: NavigationTask {
  var shouldPopBlock: (ViewController) -> Bool
  
  init(shouldPopBlock: @escaping ((ViewController) -> Bool), sequence: NavigationSequence, animated: Bool = false) {
    self.shouldPopBlock = shouldPopBlock
    
    super.init(sequence: sequence, animated: animated)
  }
  
  override func perform() {
    guard let (topViewControllerAfterPop, viewControllerPopTo) = topViewControllerAfterPopAndViewControllerPopTo else { return }
    
    topViewControllerAfterPop.navigationCompletion = {
      self.sequence.navigate()
    }
    
    sequence.navigationController.popToViewController(viewControllerPopTo, animated: animated)
  }
  
  var topViewControllerAfterPopAndViewControllerPopTo: (ViewController, ViewController)? {
    let viewControllers = sequence.navigationController.viewControllers
    for index in (0..<viewControllers.count).reversed() {
      let vc = viewControllers[index] as! ViewController
      if !shouldPopBlock(vc) {
        let newTop = index == 0 ? vc : viewControllers[index - 1]
        return (newTop as! ViewController, vc)
      }
    }
    
    return nil
  }
}

extension NavigationSequence {
  @discardableResult
  func popWhileAnimated(_ shouldPopBlock: @escaping ((ViewController) -> Bool)) -> NavigationSequence {
    let task = PopWhileTask(shouldPopBlock: shouldPopBlock, sequence: self, animated: true)
    sequence.append(task)
    return self
  }
  
  @discardableResult
  func popWhile(_ shouldPopBlock: @escaping ((ViewController) -> Bool)) -> NavigationSequence {
    let task = PopWhileTask(shouldPopBlock: shouldPopBlock, sequence: self)
    sequence.append(task)
    return self
  }
}

class TagManager {
  static let shared = TagManager()
  
  var viewControllers = Dictionary<ViewController.Tag, ViewController>()
  
  func register(_ viewController: ViewController) {
    viewControllers[viewController.tag] = viewController
  }
}

class Blue: ViewController {
  override var tag: ViewController.Tag {
    return Tag("color.blue")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue
  }
  
  @IBAction func tap(_ sender: Any) {
    NavigationSequence.instantiate(for: self).pushAnimated(Tag("red.red")).pushAnimated(Green()).navigate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {

      NavigationSequence.instantiate(for: self).popWhileAnimated({ (vc) -> Bool in
        vc.tag.group == "color"
      }).navigate()
    }
  }
}

class Red: ViewController {
  override var tag: ViewController.Tag {
    return Tag("red.red")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.red
  }
}

class Green: ViewController {
  override var tag: ViewController.Tag {
    return Tag("color.green")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.green
  }
}

class Yellow: ViewController {
  override var tag: ViewController.Tag {
    return Tag("color.blue")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.yellow
    
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(close), for: .touchUpInside)
    addView(button, to: view)
  }
  
  func close() {
    NavigationSequence.instantiate(for: self).dismissAnimated().navigate()
  }
}

protocol ViewControllerConvertible {
  var viewController: ViewController { get }
}

extension ViewController: ViewControllerConvertible {
  var viewController: ViewController { return self }
}

extension ViewController.Tag: ViewControllerConvertible {
  var viewController: ViewController {
    return TagManager.shared.viewControllers[self]!
  }
}
