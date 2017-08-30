//
//  AlertDecorator.swift
//  MeccaBingo
//
//  Created by fengx on 09/08/2017.
//  Copyright © 2017 mkodo. All rights reserved.
//

import Foundation
import UIKit

typealias AlertButtonCustomizer = (UIButton, AlertActionStyle) -> Void

class AlertAppearance: NSObject {
  var backgroundColor: UIColor?
  
  var panelBackgroundColor: UIColor?
  var panelCornerRadius: CGFloat?
  var panelBorderWidth: CGFloat?
  var panelBorderColor: UIColor?
  var panelWidth: CGFloat?
  
  var titleTextColor: UIColor?
  var titleFont: UIFont?
  
  var messageTextColor: UIColor?
  var messageFont: UIFont?
  
  var buttonBackgroundImage: UIImage?
  var buttonTitleTextColor: UIColor?
  var buttonTitleFont: UIFont?
  var buttonCustomizer: AlertButtonCustomizer?
  var buttonHeight: CGFloat?
}
