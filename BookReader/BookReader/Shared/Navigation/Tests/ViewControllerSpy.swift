import UIKit
@testable import BookReader

class ViewControllerSpy: UIViewController, Setupable {
  var name: String = ""
  var data: String?
  
  init(_ name: String) {
    self.name = name
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup(with data: Any?) {
    self.data = data as? String
  }
  
  static func ==(lhs: ViewControllerSpy, rhs: ViewControllerSpy) -> Bool {
    return lhs.name == rhs.name
  }
  
  override var description: String {
    return name
  }
}
