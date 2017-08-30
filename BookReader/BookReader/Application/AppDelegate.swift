import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    guard let nav = window?.rootViewController as? UINavigationController else { return }
    
    NavigationManager.shared.mainNavigationController = nav
    setUpAlertManager(with: nav)
  }
}

