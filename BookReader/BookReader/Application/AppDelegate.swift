import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    NavigationManager.shared.navigationController = window?.rootViewController as? UINavigationController
  }
}

