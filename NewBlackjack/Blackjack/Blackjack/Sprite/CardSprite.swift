//
//  CardSprite.swift
//  Blackjack
//
//  Created by Feng Xiong on 06/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import SpriteKit

extension Card {
  var color: SKColor {
    get {
      switch suit {
      case .Heart, .Diamond:
        return SKColor(red: 212 / 255, green: 45 / 255, blue: 45 / 255, alpha: 1)
      case .Spade, .Club:
        return .black
      }
    }
  }
}

class CardSprite: SKLabelNode {
  let card: Card
  static let Width: CGFloat = 42
  static let Height: CGFloat = 50
  
  init(card: Card) {
    self.card = card
    super.init()
    configure()
  }
  
  func configure() {
    self.text = card.printableString
    self.fontName = "Helvetica-Bold"
    self.fontColor = card.color
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
