//
//  Dealer.swift
//  Blackjack
//
//  Created by Feng Xiong on 16/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

protocol Dealer {
  func deal() -> Card
}

class RandomCardDealer: Dealer {
  func deal() -> Card {
    return Card.random()
  }
}

class FixedCardsDealer: Dealer {
  var cards: [Card]
  
  init(with cards: [Card]) {
    self.cards = cards
  }
  
  func deal() -> Card {
    return cards.remove(at: 0)
  }
}

