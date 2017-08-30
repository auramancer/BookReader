import Foundation
import UIKit

class LandscapeOnlyViewController: UIViewController {
  @IBAction func alertButtonPressed(_ sender: Any) {
    textField.resignFirstResponder()
    showOKAlert(title: nil, message: "Hello")
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }
  
  @IBOutlet weak var textField: UITextField!
  
  var picker: UIPickerView!
  
  override func viewDidLoad() {
  }
  
  var toolbar: UIToolbar {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    return toolbar
  }
}

extension LandscapeOnlyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 4
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row)"
  }
}

class DualOrientationViewController: UIViewController {
  @IBAction func backButtonPressed(_ sender: Any) {
    navigationHelper.schedule().dismissAnimated().run()
  }
  
  
  @IBAction func alertButtonPressed(_ sender: Any) {
    showOKAlert(title: "Test", message: "Bye")
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .allButUpsideDown
  }
}

class TestNavigationController: UINavigationController {
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
}
