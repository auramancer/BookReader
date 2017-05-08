import UIKit

let isRunningUnitTests: Bool = NSClassFromString("XCTest") != nil
let defaultAnimated: Bool = !isRunningUnitTests

func addView(_ view: UIView, to container: UIView) {
  view.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(view)
  
  let namedView = ["view": view]
  addConstraints(withVisualFormat: "H:|-0-[view]-0-|", views: namedView, to: container)
  addConstraints(withVisualFormat: "V:|-0-[view]-0-|", views: namedView, to: container)
}

func addConstraints(withVisualFormat format: String, views: [String : AnyObject], to superView: UIView) {
  let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: views)
  superView.addConstraints(constraints)
}

func executeWithLock(_ lock: NSLock, execute: () -> Void) {
  lock.lock()
  execute()
  lock.unlock()
}

func dispatchOnMain(after timeInSeconds: TimeInterval, execute: @escaping (Void) -> Void) {
  DispatchQueue.main.asyncAfter(deadline:  .now() + .seconds(Int(timeInSeconds)), execute: execute)
}

extension String {
  var attributedString: NSAttributedString {
    return NSAttributedString(string: self, attributes: nil)
  }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
  let result = NSMutableAttributedString(attributedString: left)
  result.append(right)
  return result
}
