import UIKit
@testable import BookReader

class ViewControllerSpy: UIViewController, Setupable {
  var name: String = ""
  var data: Any?
  
  init(_ name: String) {
    self.name = name
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup(with data: Any?) {
    self.data = data
  }
  
  static func ==(lhs: ViewControllerSpy, rhs: ViewControllerSpy) -> Bool {
    return lhs.name == rhs.name
  }
}
