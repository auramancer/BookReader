import UIKit

class AlertView: UIView {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var contentWidth: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageView: UITextView!
//  @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
  
  var message: AlertMessage? {
    didSet {
      messageView.showMessage(message)
      recalculate()
    }
  }
  
  func recalculate() {
    print(messageView.contentSize)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let size = messageView.frame.size
    let size2 = messageView.sizeThatFits(size)
    print(size)
    print(size2)
    
    messageView.isScrollEnabled = size.height + 1 < size2.height
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

extension UIView {
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
}
