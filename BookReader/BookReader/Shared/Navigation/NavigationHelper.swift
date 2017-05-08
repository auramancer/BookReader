import UIKit

class NavigationHelper {
  var navigationController: UINavigationController!
  
  var tasks = [NavigationTask]()
  var currentTask: NavigationTask?
  var sequenceCompletion: (() -> Void)?
  
  var lock = NSLock()
  
  init(for navigationController: UINavigationController) {
    self.navigationController = navigationController
    
    let notification = NSNotification.Name(NavigationManager.Notification.didShowViewController)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(viewControllerShowed),
                                           name: notification,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func enqueueTask(_ task: NavigationTask, data: Any?, animated: Bool) {
    task.navigationController = navigationController
    task.data = data
    task.animated = animated
    task.completion = task is NavigationCompleteTask ? sequenceCompleted : taskCompleted
    tasks.append(task)
  }
  
  private func taskCompleted() {
    currentTask = nil
    
    executeNextTask()
  }
  
  private func sequenceCompleted() {
    currentTask = nil
    tasks.removeAll()
    
    sequenceCompletion?()
  }
  
  func executeNextTask() {
    if currentTask == nil && tasks.count > 0 {
      currentTask = tasks.removeFirst()
      currentTask?.execute()
    }
  }
  
  func schedule() -> NavigationHelper {
    lock.lock()
    return self
  }
  
  func run(completion: (() -> Void)? = nil) {
    sequenceCompletion = completion
    enqueueTask(NavigationCompleteTask(), data: nil, animated: false)
    
    lock.unlock()
    
    executeNextTask()
  }
  
  func reset() {
    tasks.removeAll()
    currentTask = nil
    sequenceCompletion = nil
    lock.unlock()
  }
  
  @objc func viewControllerShowed() {
    if navigationController.topViewController == currentTask?.expectedTopViewController {
      currentTask?.completion?()
    }
  }
}

class NavigationCompleteTask: NavigationTask {
  override func execute() {
    completion?()
  }
}

