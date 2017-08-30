import UIKit

typealias AlertControllerInstantiater = (Alert) -> AlertController

class AlertManager: AlertControllerDelegate {
  static let shared = AlertManager()
  
  var navigationController: UINavigationController?
  
  var alertWindow: AlertWindow?
  
  var currentAlert: Alert?
  var alertQueue = [Alert]()
  var alertControllerInstantiaters = [Alert : AlertControllerInstantiater]()
  var isInForeground = true
  
  init() {
    observeApplication()
    _ = KeyboardObserver.shared
  }
  
  private func observeApplication() {
    let center = NotificationCenter.default
    
    center.addObserver(self,
                       selector: #selector(willEnterForeground),
                       name: .UIApplicationWillEnterForeground,
                       object: nil)
    center.addObserver(self,
                       selector: #selector(didEnterBackground),
                       name: .UIApplicationDidEnterBackground,
                       object: nil)
  }
  
  @objc private func willEnterForeground() {
    isInForeground = true
    
    showNextAlert()
  }
  
  @objc private func didEnterBackground() {
    isInForeground = false
    
    requeueCurrentAlert()
  }
  
  private func showNextAlert() {
    if currentAlert == nil, alertQueue.count > 0 {
      currentAlert = alertQueue.removeFirst()
    }
    
    updateWindow()
  }
  
  private func requeueCurrentAlert() {
    if let alert = currentAlert {
      alertQueue.insert(alert, at: 0)
      currentAlert = nil
    }
    
    updateWindow()
  }
  
  func show(_ alert: Alert, alertControllerInstantiater: AlertControllerInstantiater? = nil) {
    if currentAlert != alert && !alertQueue.contains(alert) {
      alertQueue.append(alert)
      alertControllerInstantiaters[alert] = alertControllerInstantiater
    }
    
    showNextAlert()
  }
  
  func remove(_ alert: Alert, action: AlertAction? = nil, input: String? = nil) {
    if currentAlert == alert {
      currentAlert = nil
      
      if let action = action {
        action.handler?(action, input)
      }
      
      showNextAlert()
    }
    else if let index = alertQueue.index(of: alert) {
      alertQueue.remove(at: index)
    }
    
    alertControllerInstantiaters[alert] = nil
  }
  
  private func updateWindow() {
    let alertInWindow = alertWindow?.alert
    
    if currentAlert == nil {
      if alertWindow != nil {
        closeWindow()
      }
    }
    else {
      if alertWindow == nil {
        showWindow()
      }
      else if currentAlert != alertInWindow {
        replaceWindow()
      }
    }
  }
  
  private func closeWindow() {
    if isInForeground {
      dismissThenCloseWindow()
    }
    else {
      alertWindow?.close()
      alertWindow = nil
    }
  }
  
  private func dismissThenCloseWindow() {
    guard let window = alertWindow else { return }
    
    self.alertWindow = nil
    
    window.dismiss() {
      window.close()
    }
  }
  
  private func showWindow() {
    guard let alert = currentAlert else { return }
    
    createAlertWindow()
    alertWindow?.alertController = createAlertController(for: alert)
    alertWindow?.alert = alert
    alertWindow?.present()
  }
  
  private func createAlertController(for alert: Alert) -> AlertController {
    let instantiateControllerFor = alertControllerInstantiaters[alert] ?? defaultInstantiater
    alertControllerInstantiaters[alert] = nil
    
    let alertController = instantiateControllerFor(alert)
    alertController.delegate = self
    
    return alertController
  }
  
  func createAlertWindow() {
    alertWindow = AlertWindow()
  }
  
  private func defaultInstantiater(for alert: Alert) -> AlertController {
    let controller = AlertController()
    controller.alert = alert
    return controller
  }
  
  private func replaceWindow() {
    alertWindow?.dismiss() { [weak self] in
      self?.alertWindow?.close()
      self?.alertWindow = nil
      
      self?.showWindow()
    }
  }
}

extension AlertManager {
  func showAlert(title: StringVarient?,
                 message: StringVarient?,
                 confirmButtonTitle: String?,
                 cancelButtonTitle: String?,
                 confirmAction: ((String?)->Void)?) {
    
    let cancelAction = AlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
    let confirmAction = AlertAction(title: confirmButtonTitle, style: .default) { _, input in
      confirmAction?(input)
    }
    let actions = cancelButtonTitle == nil ? [confirmAction] : [cancelAction, confirmAction]
    
    let alert = Alert(title: title,
                      message: message,
                      actions: actions)
    
    show(alert)
  }
}

extension UIViewController {
  func showOKAlert(title: String?, message: String?) {
    let alert = Alert.acknowledgement(title: title, message: message)
    
    AlertManager.shared.show(alert)
  }
  
  func showOKAlert(title: String?, attributedMessage: NSAttributedString?) {
    let alert = Alert.acknowledgement(title: title, message: attributedMessage)
    
    AlertManager.shared.show(alert)
  }
  
  func showActivityAlert(title: String?, message: String?) {
    let alert = Alert.activity(title: title, message: message)
    
    AlertManager.shared.show(alert)
  }
  
  func showAlert(title: String?,
                 message: String?,
                 confirmButtonTitle: String?,
                 cancelButtonTitle: String?,
                 confirmAction: ((String?)->Void)?) {
    AlertManager.shared.showAlert(title: title,
                                  message: message,
                                  confirmButtonTitle: confirmButtonTitle,
                                  cancelButtonTitle: cancelButtonTitle,
                                  confirmAction: confirmAction)
  }
  
  func showAlert(title: String?,
                 attributedMessage: NSAttributedString?,
                 confirmButtonTitle: String?,
                 cancelButtonTitle: String?,
                 confirmAction: ((String?)->Void)?) {
    AlertManager.shared.showAlert(title: title,
                                  message: attributedMessage,
                                  confirmButtonTitle: confirmButtonTitle,
                                  cancelButtonTitle: cancelButtonTitle,
                                  confirmAction: confirmAction)
  }
}

extension UIView {
  func showOKAlert(title: String?, message: String?) {
    let alert = Alert.acknowledgement(title: title, message: message)
    
    AlertManager.shared.show(alert)
  }
  
  func showOKAlert(title: String?, attributedMessage: NSAttributedString?) {
    let alert = Alert.acknowledgement(title: title, message: attributedMessage)
    
    AlertManager.shared.show(alert)
  }
  
  func showAlert(title: String?,
                 message: String?,
                 confirmButtonTitle: String?,
                 cancelButtonTitle: String?,
                 confirmAction: ((String?)->Void)?) {
    AlertManager.shared.showAlert(title: title,
                                  message: message,
                                  confirmButtonTitle: confirmButtonTitle,
                                  cancelButtonTitle: cancelButtonTitle,
                                  confirmAction: confirmAction)
  }
  
  func showAlert(title: String?,
                 attributedMessage: NSAttributedString?,
                 confirmButtonTitle: String?,
                 cancelButtonTitle: String?,
                 confirmAction: ((String?)->Void)?) {
    AlertManager.shared.showAlert(title: title,
                                  message: attributedMessage,
                                  confirmButtonTitle: confirmButtonTitle,
                                  cancelButtonTitle: cancelButtonTitle,
                                  confirmAction: confirmAction)
  }
}

extension AppDelegate {
  func setUpAlertManager(with navigationController: UINavigationController) {
    AlertManager.shared.navigationController = navigationController
  }
}
