//
//  BettedHand.swift
//  Blackjack
//
//  Created by Feng Xiong on 12/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import UIKit

class BettedHand: Hand {
  enum Result {
    case Unsettled
    case Won
    case Lost
    case Tied
  }
  
  var result = Result.Unsettled
  var stakes: Money
  var paid: Money
  
  init(owner: AnyObject, stakes: Money) {
    self.stakes = stakes
    self.paid = Money(currency: stakes.currency, amount: 0)
    super.init(owner: owner)
  }
  
  var isSettled: Bool {
    return result != .Unsettled
  }
  
  override func split() throws -> BettedHand {
    let newHand = try? super.split()
    let newBettedHand = BettedHand(owner: owner, stakes: stakes)
    newBettedHand.cards.append(contentsOf: newHand!.cards)
    return newBettedHand
  }
}
