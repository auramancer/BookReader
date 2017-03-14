import UIKit

class Blue: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue
  }
  
  @IBAction func tap(_ sender: Any) {
    self.navigationHelper?.beginSchedule().push(Red()).endSchedule()
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      let a = self.navigationController?.popToRootViewController(animated: false)
      print(a?.count)
    }
  }
  
  func isNotBlue(vc: UIViewController) -> Bool {
    return !(vc is Blue)
  }
}

class Red: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.red
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
    navigationHelper?.beginSchedule().dismissAnimated().endSchedule()
  }
}
