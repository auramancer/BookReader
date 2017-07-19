import UIKit

class AlertController: UIViewController {
  var alert: Alert?
  
  var alertView: AlertView?
  
  init() {
    super.init(nibName: "AlertView", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    alertView = view as? AlertView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    alertView?.titleLabel.text = alert?.title
    alertView?.message = alert?.message
  }
}
