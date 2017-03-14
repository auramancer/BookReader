//
//  Event.swift
//  Blackjack
//
//  Created by Feng Xiong on 16/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

protocol Event {
  
}

protocol CardZone {
  func cardAtIndex() -> Card
  func cardCount() -> Int
}

struct CardMoveEvent: Event {
  var zoneFrom: CardZone!
  var zoneTo: CardZone!
}