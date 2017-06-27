import Foundation

protocol AlertMessage {}
extension String: AlertMessage {}
extension NSAttributedString: AlertMessage {}

typealias AlertActionHandler = (AlertAction) -> Void

struct AlertAction {
  var title: String
  var handler: AlertActionHandler?
}

struct Alert {
  var title: String?
  var message: AlertMessage?
  var actions: [AlertAction]
  var preferredAction: AlertAction?
}
