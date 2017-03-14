//
//  Card.swift
//  Blackjack
//
//  Created by Feng Xiong on 06/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import UIKit

struct Card {
  enum Suit: String {
    case Spade   = "♠"
    case Heart   = "♥"
    case Club    = "♣"
    case Diamond = "♦"
    
    static let allValues = [Spade, Heart, Club, Diamond]
  }
  
  enum Symbol: String {
    case Two   = "2"
    case Three = "3"
    case Four  = "4"
    case Five  = "5"
    case Six   = "6"
    case Seven = "7"
    case Eight = "8"
    case Nine  = "9"
    case Ten   = "10"
    case Jack  = "J"
    case Queen = "Q"
    case King  = "K"
    case Ace   = "A"
    
    static let allValues = [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace]
  }
  
  let suit: Suit
  let symbol: Symbol
  
  init(suit: Suit, symbol: Symbol) {
    self.suit = suit
    self.symbol = symbol
  }
}

extension Card: Equatable {}

func == (lhs: Card, rhs: Card) -> Bool {
  return lhs.suit == rhs.suit && lhs.symbol == rhs.symbol
}

extension Card: CustomStringConvertible {
  var printableString: String {
    return suit.rawValue + symbol.rawValue
  }
  
  var description: String {
    return printableString
  }
}

extension Card {
  var speakableString: String {
    return speakableStringOfSymbol + " of " + speakableStringOfSuit
  }
  
  var speakableStringOfSuit: String {
    switch suit {
    case .Spade:
      return "Spade"
    case .Heart:
      return "Heart"
    case .Club:
      return "Club"
    case .Diamond:
      return "Diamond"
    }
  }
  
  var speakableStringOfSymbol: String {
    switch symbol {
    case .Ten:
      return "Ten"
    case .Jack:
      return "Jack"
    case .Queen:
      return "Queen"
    case .King:
      return "King"
    case .Ace:
      return "Ace"
    default:
      return symbol.rawValue
    }
  }
}

extension Card {
  static func random() -> Card {
    let randomSuit = randomElementOf(array: Suit.allValues)
    let randomSymbol = randomElementOf(array: Symbol.allValues)
    return Card(suit: randomSuit, symbol: randomSymbol)
  }
  
  static func deck() -> [Card] {
    var deck = [Card]()
    for suit in Suit.allValues {
      for symbol in Symbol.allValues {
        deck.append(Card(suit: suit, symbol: symbol))
      }
    }
    return deck
  }
}

func randomElementOf<T>(array: [T]) -> T {
  let index = Int(arc4random_uniform(UInt32(array.count)))
  return array[index]
}

let ace = Card(suit: .Spade, symbol: .Ace)
let king = Card(suit: .Spade, symbol: .King)
let queen = Card(suit: .Heart, symbol: .Queen)
let jack = Card(suit: .Heart, symbol: .Jack)
let ten = Card(suit: .Heart, symbol: .Ten)
let nine = Card(suit: .Club, symbol: .Nine)
let eight = Card(suit: .Club, symbol: .Eight)
let seven = Card(suit: .Club, symbol: .Seven)
let six = Card(suit: .Diamond, symbol: .Six)
let five = Card(suit: .Diamond, symbol: .Five)
let four = Card(suit: .Diamond, symbol: .Four)
let three = Card(suit: .Diamond, symbol: .Three)
let two = Card(suit: .Diamond, symbol: .Two)
