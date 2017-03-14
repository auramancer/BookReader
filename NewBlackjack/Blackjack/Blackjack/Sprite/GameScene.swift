//
//  GameScene.swift
//  Blackjack
//
//  Created by Feng Xiong on 06/09/2016.
//  Copyright (c) 2016 FF. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  var game: Game?
  
  override func didMove(to view: SKView) {
    self.size = view.bounds.size
    game = Game(bets: [("Player", GBP(10))])
    game?.dealStartingHands()
    
    layoutSprites()
  }
  
  func layoutSprites() {
    let button = ButtonSprite()
    button.text = "hit"
    button.position = position
    self.addChild(button)
  }
  
  var deckZoneOrigin: CGPoint {
    return CGPoint(x: 50, y: 50)
  }
  
  func put(cards: [Card], at position: CGPoint, space: CGFloat) {
    for (index, card) in cards.enumerated() {
      let x = position.x + CGFloat(index) * (CardSprite.Width + space)
      let y = position.y
      put(card, at: CGPoint(x: x, y: y))
    }
  }
  
  func put(_ card: Card, at position: CGPoint) {
    put(CardSprite(card: card), at: position)
  }
  
  func put(_ node: SKNode, at position: CGPoint) {
    node.position = position
    self.addChild(node)
  }
  
//  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    for touch in touches {
//      let location = touch.locationInNode(self)
//      putRandomCard(at: location)
//    }
//  }
}
