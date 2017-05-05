//
//  OS.swift
//  BookReader
//
//  Created by fengx on 05/05/2017.
//  Copyright © 2017 FFStudio. All rights reserved.
//

import UIKit

struct System {
  static let version = UIDevice.current.systemVersion
  
  static func isAbove(_ threshold: String) -> Bool {
    return Float(version)! >= Float(threshold)!
  }
}
