import UIKit

class AlertManager {
  static let shared = AlertManager()
  
  var alertWindow: UIWindow?
  
  func show(_ alert: Alert) {
    if isShowingAlert {
      enqueue(alert)
    }
    else {
      showAlertWindow(for: alert)
//      showSystemAlert(for: alert)
    }
  }
  
  var isShowingAlert: Bool {
    return alertWindow != nil
  }
  
  func enqueue(_ alert: Alert) {
    
  }
  
  func showSystemAlert(for alert: Alert) {
    let controller = UIAlertController(title: alert.title, message: alert.message as? String, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "sss", style: .default, handler: nil))
    NavigationManager.shared.navigationHelpers.first?.value.schedule().present(controller).run() {
      
//      self.showSystemAlert(for: Alert(title: "£33", message: "£33", actions: [], preferredAction: nil))
    }
  }
  
  func showAlertWindow(for alert: Alert) {
    alertWindow = UIWindow()
    alertWindow!.rootViewController = UIViewController()
    alertWindow!.makeKeyAndVisible()
    
    let alertController = AlertController()
    alertController.alert = alert
    alertWindow!.rootViewController!.present(alertController, animated: true, completion: nil)
  }
}
