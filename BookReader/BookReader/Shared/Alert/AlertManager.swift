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
    }
  }
  
  var isShowingAlert: Bool {
    return alertWindow != nil
  }
  
  func enqueue(_ alert: Alert) {
    
  }
  
  func showAlertWindow(for alert: Alert) {
    alertWindow = UIWindow()
    alertWindow!.rootViewController = UIViewController()
    alertWindow!.makeKeyAndVisible()
    
    let alertController = AlertController()
    alertWindow!.rootViewController!.present(alertController, animated: true, completion: nil)
  }
}
