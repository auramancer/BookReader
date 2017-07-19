import Foundation
import UIKit
import StoreKit

class Blue: TestViewController {
  override var color: UIColor {
    return UIColor.blue
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    let alert = UIAlertController(title: "asdf", message: "asdf", preferredStyle: .alert)
//    present(alert, animated: false, completion: nil)
  }
  
  override func buttonPressed() {
    navigationHelper?.schedule().present(Green()).run()
//    let alert = Alert(title: nil, message: "Be careful!", actionTitle: "OK")
    
//    AlertManager.shared.show(alert)
  }
  
//  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    return .landscape
//  }
//  
  override var prefersStatusBarHidden: Bool {
    return false
  }
}

class Red: TestViewController {
  override var color: UIColor {
    return UIColor.red
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    let alert = UIAlertController(title: "1234", message: "1234", preferredStyle: .alert)
//    present(alert, animated: false, completion: nil)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func buttonPressed() {
  }
}

class Green: TestViewController {
  override var color: UIColor {
    return UIColor.green
  }
  
//  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//    return .landscapeLeft
//  }
//  
//  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    return .allButUpsideDown
//  }
//  
//  override var shouldAutorotate: Bool {
//    return true
//  }
//  
  override var prefersStatusBarHidden: Bool {
    return false  
  }
}

class Yellow: TestViewController {
  override var color: UIColor {
    return UIColor.yellow
  }
}

class TestViewController: UIViewController {
  var color: UIColor {
    return UIColor.black
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = color
    
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    button.setTitle(String(describing: self), for: .normal)
    button.center = view.center
    addView(button, to: view)
  }
  
  func buttonPressed() {
    NavigationManager.shared.navigationHelpers.first?.value.schedule().dismiss().run()
    
//    let value = UIInterfaceOrientation.portrait.rawValue
//    UIDevice.current.setValue(value, forKey: "orientation")
  }
}

class NavigationController: UINavigationController {
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }
}
