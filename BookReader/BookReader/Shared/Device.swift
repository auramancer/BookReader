//
//  Device.swift
//  BookReader
//
//  Created by fengx on 05/05/2017.
//  Copyright © 2017 FFStudio. All rights reserved.
//

import UIKit

struct Device {
  static let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
  static let isSimulator: Bool = TARGET_OS_SIMULATOR != 0
  
  static let orientation = UIDevice.current.orientation
  static let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
  static let isLandscape = orientation == .landscapeLeft || orientation == .landscapeRight
}
