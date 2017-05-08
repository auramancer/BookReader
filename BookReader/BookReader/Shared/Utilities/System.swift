import UIKit

struct System {
  static let version = UIDevice.current.systemVersion
  
  static func isAbove(_ threshold: String) -> Bool {
    return Float(version)! >= Float(threshold)!
  }
}
