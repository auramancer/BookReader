import UIKit

class AlertView: UIView {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var contentWidth: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageView: UITextView!
  @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
  
  var message: AlertMessage? {
    didSet {
      messageView.showMessage(message)
      recalculate()
    }
  }
  
  func recalculate() {
    print(messageView.contentSize)
    
    messageViewHeight.constant = messageView.contentSize.height
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    
  }
}

extension UITextView {
  fileprivate func showMessage(_ message: AlertMessage?) {
    if let attributedText = message as? NSAttributedString {
      self.attributedText = attributedText
    }
    else {
      text = message as? String
    }
  }
}
