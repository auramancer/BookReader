//
//  ButtonSprite.swift
//  Blackjack
//
//  Created by Feng Xiong on 14/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import SpriteKit

class ButtonSprite: SKLabelNode {
  
  override init() {
    super.init()
    configure()
  }
  
  func configure() {
    self.fontName = "Helvetica-Bold"
    self.fontColor = UIColor.blue
    self.fontSize = 17
    self.addChild(backgroundNode())
  }
  
  func backgroundNode() -> SKNode {
    let width = 42
    let height = 50
    let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
    let node = SKShapeNode(rect: rect, cornerRadius: 2)
    node.fillColor = .white
    node.strokeColor = .darkGray
    return node
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
