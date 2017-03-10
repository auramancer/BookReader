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
  
  func beginSchedule() -> NavigationHelper {
    lock.lock()
    return self
  }
  
  func endSchedule(completion: (() -> Void)? = nil) {
    sequenceCompletion = completion
    enqueueTask(NavigationCompleteTask(), data: nil, animated: false)
    
    lock.unlock()
    
    executeNextTask()
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

