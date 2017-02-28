import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    TagManager.shared.register(Blue())
    TagManager.shared.register(Yellow())
    TagManager.shared.register(Green())
    TagManager.shared.register(Red())
  }
}

