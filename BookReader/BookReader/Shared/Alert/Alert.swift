import Foundation

protocol StringVarient {
  var string: String { get }
}

extension String: StringVarient {
  var string: String {
    return self
  }
}

extension NSAttributedString: StringVarient {}

typealias AlertActionHandler = (AlertAction, String?) -> Void

enum AlertActionStyle: Int {
  case `default`
  case cancel
//  case destructive
}

struct AlertAction {
  var title: String?
  var style: AlertActionStyle
  var handler: AlertActionHandler?
  
  init(title: String?, style: AlertActionStyle, handler: AlertActionHandler?) {
    self.title = title
    self.style = style
    self.handler = handler
  }
}

struct Alert {
  var title: StringVarient?
  var message: StringVarient?
  var actions: [AlertAction]
  
  var needsInput = false
  var inputValidator: ((String?) -> Bool)?
  
  var activityIsInProgress = false
  var timeUntilAutoClose: TimeInterval?
  
  init(title: StringVarient?, message: StringVarient?, actions: [AlertAction]) {
    self.title = title
    self.message = message
    self.actions = actions
  }
  
  static func activity(title: StringVarient?, message: StringVarient?) -> Alert {
    var alert = Alert(title: title, message: message, actions: [])
    alert.activityIsInProgress = true
    return alert
  }
  
  static func acknowledgement(title: StringVarient?,
                              message: StringVarient?,
                              actionTitle: String? = "OK")  -> Alert {
    let action = AlertAction(title: actionTitle, style: .default, handler: nil)
    let alert = Alert(title: title, message: message, actions: [action])
    return alert
  }
}

extension Alert: Hashable {
  static func == (lhs: Alert, rhs: Alert) -> Bool {
    return lhs.title?.string == rhs.title?.string
      && lhs.message?.string == rhs.message?.string
  }
  
  var hashValue: Int {
    return "\(title?.string ?? "")\(message?.string ?? "")".hashValue
  }
}

class AlertWrapper: NSObject {
  var alert: Alert
  
  init(_ alert: Alert) {
    self.alert = alert
  }
}
