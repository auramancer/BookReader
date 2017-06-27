import UIKit
import StoreKit

class Blue: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    if #available(iOS 10.3, *) {
//      SKStoreReviewController.requestReview()
//    }
    
    AlertManager.shared.show(Alert(title: nil, message: "asdfasdf", actions: [], preferredAction: nil))
  }
  
  @IBAction func tap(_ sender: Any) {
    self.navigationHelper?.schedule().push(Red()).run()
  }
}

class Red: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.red
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}

class Green: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.green
  }
}

class Yellow: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.yellow
    
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(close), for: .touchUpInside)
    addView(button, to: view)
  }
  
  func close() {
    navigationHelper?.schedule().dismissAnimated().run()
  }
}
