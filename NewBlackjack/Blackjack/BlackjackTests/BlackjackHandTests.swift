//
//  BlackjackTests.swift
//  BlackjackTests
//
//  Created by Feng Xiong on 06/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import XCTest
@testable import Blackjack

extension Hand {
  func setStartingHand(cards: [Card]) {
    for card in cards {
      addCard(card)
    }
  }
}

class BlackjackHandTests: XCTestCase {
  var hand: Hand!
  
  override func setUp() {
    super.setUp()
    hand = Hand(owner: self)
  }
  
  func testEmptyHand() {
    assertTotal(of: hand, min: 0, max: 0)
    assertState(of: hand, isBlackjack: false, isBreaking: false, canHit: false, canDouble: false, canSplit: false)
  }
  
  func testNoAceHand() {
    hand.setStartingHand([nine, eight])
    assertTotal(of: hand, min: 17, max: 17)
    assertState(of: hand, isBlackjack: false, isBreaking: false, canHit: true, canDouble: true, canSplit: false)
  }
  
  func testBlackjack() {
    hand.setStartingHand([ace, king])
    assertTotal(of: hand, min: 11, max: 21)
    assertState(of: hand, isBlackjack: true, isBreaking: false, canHit: false, canDouble: false, canSplit: false)
  }
  
  func testAPairOfAces() {
    hand.setStartingHand([ace, ace])
    assertTotal(of: hand, min: 2, max: 12)
    assertState(of: hand, isBlackjack: false, isBreaking: false, canHit: true, canDouble: true, canSplit: true)
  }
  
  func testTwoToSeven() {
    hand.setStartingHand([two, three, four, five, six, seven])
    assertTotal(of: hand, min: 27, max: 27)
    assertState(of: hand, isBlackjack: false, isBreaking: true, canHit: false, canDouble: false, canSplit: false)
  }
  
  func testSplitPair() {
    hand.setStartingHand([queen, ten])
    let newHand = try! hand.split()
    
    XCTAssertTrue(hand.owner === newHand.owner)
    XCTAssertEqual(hand.cards.count, 1)
    XCTAssertEqual(newHand.cards.count, 1)
    XCTAssertEqual(hand.cards[0], queen)
    XCTAssertEqual(newHand.cards[0], ten)
  }
  
  func testSplitNonPair() {
    hand.setStartingHand([ten, two])
    var didCatchError = false
    
    do {
      let _ = try hand.split()
    } catch Hand.Error.SplitWhenCannot {
      didCatchError = true
    } catch {
    }
    
    XCTAssertTrue(didCatchError)
  }
  
  func testDoubleWithTens() {
    hand.setStartingHand([queen, ten])
    try! hand.double(withTheThirdCard: ace)
    
    assertTotal(of: hand, min: 21, max: 21)
    assertState(of: hand, isBlackjack: false, isBreaking: false, canHit: false, canDouble: false, canSplit: false)
  }
  
  func testDoubleWithBlackjack() {
    hand.setStartingHand([ace, queen])
    var didCatchError = false
    
    do {
      let _ = try hand.double(withTheThirdCard: ace)
    } catch Hand.Error.DoubleWhenCannot {
      didCatchError = true
    } catch {
    }
    
    XCTAssertTrue(didCatchError)
  }
  
  // MARK: helpers
  
  func assertTotal(of hand: Hand, min: Int, max: Int) {
    XCTAssertEqual(hand.minTotal, min)
    XCTAssertEqual(hand.maxTotal, max)
  }
  
  func assertState(of hand: Hand,
                      isBlackjack: Bool,
                      isBreaking: Bool,
                      canHit: Bool,
                      canDouble: Bool,
                      canSplit: Bool) {
    XCTAssertEqual(isBlackjack, hand.isBlackjack)
    XCTAssertEqual(isBreaking, hand.isBreaking)
    XCTAssertEqual(canHit, hand.canHitOrStand)
    XCTAssertEqual(canDouble, hand.canDouble)
    XCTAssertEqual(canSplit, hand.canSplit)
  }
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
