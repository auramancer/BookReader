//
//  Hand.swift
//  Blackjack
//
//  Created by Feng Xiong on 07/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

class Hand {
  enum ActionError: Error {
    case cannotBeHitted
    case cannotBeStood
    case cannotDouble
    case cannotSplit
  }
  
  struct State {
    let isStartingHand: Bool
    let isBlackjack: Bool
    let isBreaking: Bool
    let isStood: Bool
    let isDoubled: Bool
    let canHitOrStand: Bool
    let canDouble: Bool
    let canSplit: Bool
  }
  
  struct Total {
    let min: Int
    let max: Int
  }
  
  static let bestTotal = 21
  let owner: AnyObject
  var cards = [Card]()
  var isStood = false
  var isDoubled = false
  
  init(owner: AnyObject) {
    self.owner = owner
  }
  
  var isStartingHand: Bool {
    return cards.count == 2
  }
  
  var isBlackjack: Bool {
    return isStartingHand && maxTotal == Hand.bestTotal
  }
  
  var isBreaking: Bool {
    return minTotal > Hand.bestTotal
  }
  
  var isComplete: Bool {
    return isBlackjack || isStood || isDoubled || isBreaking
  }
  
  var canHitOrStand: Bool {
    return !isComplete && minTotal < Hand.bestTotal
  }
  
  var canDouble: Bool {
    return !isComplete && isStartingHand
  }
  
  var canSplit: Bool {
    return !isComplete && isAPair
  }
  
  var isAPair: Bool {
    return cards.count == 2 && value(of: cards[0]) == value(of: cards[1])
  }
  
  var state: State {
    let stateList: [State?] = [isStartingHand ? .isStartingHand : nil,
                               isBlackjack ? .isBlackjack : nil,
                               isBreaking ? .isBreaking : nil,
                               isStood ? .isStood : nil,
                               isDoubled ? .isDoubled : nil,
                               canHitOrStand ? .canHitOrStand : nil,
                               canDouble ? .canDouble : nil,
                               canSplit ? .canSplit : nil];
    let state: State = stateList.flatMap { $0 }
    return state
  }

  func add(_ card: Card) {
    cards.append(card)
  }
  
  func hit(with card: Card) throws {
    guard canHitOrStand else {
      throw ActionError.cannotBeHitted
    }
    
    add(card)
  }
  
  func stand() throws {
    guard canHitOrStand else {
      throw ActionError.cannotBeHitted
    }
    
    isStood = true
  }
  
  func double(withTheThirdCard card: Card) throws {
    guard canDouble else {
      throw ActionError.cannotBeHitted
    }
    
    isDoubled = true
    add(card)
  }
  
  func split() throws -> Hand {
    guard canSplit else {
      throw ActionError.cannotBeHitted
    }
    
    let splittedCard = cards.removeLast()
    return createHandForSameOwner(with: splittedCard)
  }
  
  private func createHandForSameOwner(with card: Card) -> Hand {
    let newHand = Hand(owner: owner)
    newHand.add(card)
    return newHand
  }
}

extension Hand {
  var containsAce: Bool {
    for card in cards {
      if card.symbol == .Ace {
        return true
      }
    }
    return false
  }
  
  var minTotal: Int {
    var total = 0
    for card in cards {
      total += value(of: card)
    }
    return total
  }
  
  var maxTotal: Int {
    if containsAce && minTotal <= 11 {
      return minTotal + 10
    }
    return minTotal
  }
  
  private func value(of card: Card) -> Int {
    switch card.symbol {
    case .Ace:
      return 1
    case .Two:
      return 2
    case .Three:
      return 3
    case .Four:
      return 4
    case .Five:
      return 5
    case .Six:
      return 6
    case .Seven:
      return 7
    case .Eight:
      return 8
    case .Nine:
      return 9
    case .Ten, .Jack, .Queen, .King:
      return 10
    }
  }
}

extension Hand: CustomStringConvertible {
  var printableString: String {
    let strings = cards.map() { $0.printableString }
    return strings.joined(separator: ",")
  }
  
  var description: String {
    return "[" + printableString + "]"
  }
}
