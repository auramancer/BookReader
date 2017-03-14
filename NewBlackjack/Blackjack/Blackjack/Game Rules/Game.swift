//
//  Game.swift
//  Blackjack
//
//  Created by Feng Xiong on 07/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

extension BettedHand {
  var isCompleteButUnsettled: Bool {
    return isComplete && !isSettled
  }
}

class Game {
  struct ReturnRate {
    static let WonWithBlackjack = 2.5
    static let Won = 2.0
    static let Tied = 1.0
    static let Lost = 0.0
  }
  
  var dealer: Dealer = RandomCardDealer()
  var dealerHand: Hand
  var playerHands = [BettedHand]()

  init(bets: [(AnyObject, Money)]) {
    dealerHand = Hand(owner: "Dealer")
    
    for (better, stakes) in bets {
      let hand = BettedHand(owner: better, stakes: stakes)
      playerHands.append(hand)
    }
  }
  
  func dealStartingHands() {
    dealDealerStartingHands()
    dealPlayerStartingHands()
    settle()
  }
  
  private func dealDealerStartingHands() {
    addCard(to: dealerHand)
  }
  
  private func addCard(to hand: Hand) {
    let card = dealer.deal()
    hand.add(card)
  }
  
  private func dealPlayerStartingHands() {
    for _ in 1...2 {
      for hand in playerHands {
        addCard(to: hand)
      }
    }
  }
  
  private func settle() {
    settlePlayerHandsBeforeDealerHandCompletion()
    if allPlayerHandsAreComplete && somePlayerHandsAreNotSettled {
      completeDealerHand()
      settlePlayerHandsAfterDealerHandCompletion()
    }
  }
  
  private func settlePlayerHandsBeforeDealerHandCompletion() {
    for hand in playerHands where hand.isCompleteButUnsettled {
      settle(hand)
    }
  }
  
  private func settlePlayerHandsAfterDealerHandCompletion() {
    for hand in playerHands where hand.isCompleteButUnsettled {
      settle(hand, against: dealerHand)
    }
  }
  
  private var allPlayerHandsAreComplete: Bool {
    for hand in playerHands where !hand.isComplete {
      return false
    }
    return true
  }
  
  private var somePlayerHandsAreNotSettled: Bool {
    for hand in playerHands where !hand.isSettled {
      return true
    }
    return false
  }
  
  private func settle(_ hand: BettedHand) {
    if hand.isBlackjack {
      setResult(of: hand, to: .Won)
    } else if hand.isBreaking {
      setResult(of: hand, to: .Lost)
    }
  }
  
  private func settle(_ hand: BettedHand, against anotherHand: Hand) {
    if anotherHand.isBreaking {
      setResult(of: hand, to: .Won)
    } else {
      settleByComparingValueOf(hand, againstValueOf: anotherHand)
    }
  }
  
  private func settleByComparingValueOf(_ hand: BettedHand, againstValueOf anotherHand: Hand) {
    var result = BettedHand.Result.Unsettled
    if hand.maxTotal > anotherHand.maxTotal {
      result = .Won
    } else if hand.maxTotal == anotherHand.maxTotal {
      result = .Tied
    } else {
      result = .Lost
    }
    setResult(of: hand, to: result)
  }
  
  private func setResult(of hand: BettedHand, to result: BettedHand.Result) {
    hand.result = result
    setAmountPaid(for: hand)
  }
  
  private func setAmountPaid(for hand: BettedHand) {
    var rate: Double!
    switch hand.result {
    case .Won:
      rate = hand.isBlackjack ? ReturnRate.WonWithBlackjack : ReturnRate.Won
    case .Tied:
      rate = ReturnRate.Tied
    default:
      rate = ReturnRate.Lost
    }
    hand.paid = hand.stakes * rate
  }
  
  private func completeDealerHand() {
    while dealerHand.maxTotal < 17 {
      addCard(to: dealerHand)
    }
  }
  
  func hit(hand: BettedHand) {
    let card = dealer.deal()
    try! hand.hit(with: card)
    settle()
  }
  
  func stand(hand: BettedHand) {
    try! hand.stand()
    settle()
  }
  
  func double(hand: BettedHand) {
    hand.stakes = hand.stakes * 2
    try! hand.double(withTheThirdCard: dealer.deal())
    settle()
  }
  
  func split(hand: BettedHand) {
    let (firstHand, secondHand) = splitIntoTwoHands(from: hand)
    addCard(to: firstHand)
    addCard(to: secondHand)
    settle()
  }
  
  private func splitIntoTwoHands(from originalHand: BettedHand) -> (BettedHand, BettedHand) {
    let newHand = try! originalHand.split()
    insert(hand: newHand, after: originalHand)
    return (originalHand, newHand)
  }
  
  private func insert(hand: BettedHand, after existingHand: BettedHand) {
    let index = playerHands.index(){ $0 === existingHand }
    playerHands.insert(hand, at: index!.advanced(by: 1))
  }
}
