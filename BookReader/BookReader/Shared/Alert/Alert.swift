import Foundation

protocol AlertMessage {}
extension String: AlertMessage {}
extension NSAttributedString: AlertMessage {}

typealias AlertActionHandler = (AlertAction) -> Void

enum AlertActionStyle: Int {
  case `default`
  case cancel
  case destructive
}

struct AlertAction {
  var title: String?
  var style: AlertActionStyle
  var isEnabled: Bool = true
  var handler: AlertActionHandler?
  
  init(title: String?, style: AlertActionStyle, handler: AlertActionHandler?) {
    self.title = title
    self.style = style
    self.handler = handler
  }
}

struct Alert {
  var title: String?
  var message: AlertMessage?
  var actions: [AlertAction]
  
  init(title: String?, message: AlertMessage?, actionTitle: String?) {
    let action = AlertAction(title: actionTitle, style: .default, handler: nil)
    
    self.init(title: nil, message: message, actions: [action])
  }
  
  init(title: String?, message: AlertMessage?, actions: [AlertAction]) {
    self.title = title
    self.message = message
    self.actions = actions
  }
}
