//
//  LocationCheckCoordinator.swift
//  MeccaBingo
//
//  Created by Feng Xiong on 07/03/2017.
//  Copyright © 2017 mkodo. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification.Name {
  static let locationCheckPassed = NSNotification.Name("locationCheckPassed")
}

@objc class LocationCheckCoordinator: NSObject {
  static let shared = LocationCheckCoordinator()
  
  var locationCheckWindow: LocationCheckWindow?
  
  override init() {
    super.init()
    
    observe()
  }
  
  func observe() {
    let center = NotificationCenter.default
    
    center.addObserver(self, selector: #selector(check), name: .UIApplicationWillEnterForeground, object: nil)
    center.addObserver(self, selector: #selector(close), name: .UIApplicationDidEnterBackground, object: nil)
    center.addObserver(self, selector: #selector(close), name: .locationCheckPassed, object: nil)
  }
  
  @objc func check() {
    showLocationCheckScreen()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
      self.close()
    }
  }
  
  private func showLocationCheckScreen() {
    let nav = UINavigationController()
    nav.viewControllers.append(Red())
    
    let window = LocationCheckWindow()
    window.backgroundColor = UIColor.clear
    window.rootViewController = nav
    window.windowLevel = UIWindowLevelNormal + 1
    window.isHidden = false
    locationCheckWindow = window
  }

  func close() {
    locationCheckWindow?.isHidden = true
    locationCheckWindow = nil
  }
}

class LocationCheckWindow: UIWindow {
}
