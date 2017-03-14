//
//  BlackjackGameTests.swift
//  Blackjack
//
//  Created by Feng Xiong on 07/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import XCTest
@testable import Blackjack

class Player {
  
}

class BlackjackGameTests: XCTestCase {
  var game: Game!
  
  override func setUp() {
    super.setUp()
    
    game = Game(bets: [("Player", GBP(10))])
  }
  
  func testPlayerWinWithBlackjack() {
    game.dealer = FixedCardsDealer(with: [queen, ace, king])
    
    game.dealStartingHands()
    
    verifyPlayerWon(25)
  }
  
  func testPlayerIsBreaking() {
    game.dealer = FixedCardsDealer(with: [queen, six, seven, ten])
    
    game.dealStartingHands()
    game.hit(playerHand)
    
    verifyPlayerLost()
  }
  
  func testDealerStandsAt17() {
    game.dealer = FixedCardsDealer(with: [queen, ten, eight, seven])
    
    game.dealStartingHands()
    game.stand(playerHand)
    
    verifyPlayerWon(20)
  }
  
  func testDealerHitsAt16() {
    game.dealer = FixedCardsDealer(with: [eight, two, three, eight, six])
    
    game.dealStartingHands()
    game.stand(playerHand)
    
    verifyPlayerWon(20)
  }
  
  func testPlayerDoubles() {
    game.dealer = FixedCardsDealer(with: [seven, six, four, eight, nine, two])
    
    game.dealStartingHands()
    game.double(playerHand)
    
    verifyPlayerTiedAndGetBack(20)
  }
  
  func testPlayerSplit() {
    game.dealer = FixedCardsDealer(with: [seven, jack, queen, ace, five, seven])
    
    game.dealStartingHands()
    game.split(playerHand)
    let secondHand = game.playerHands.last!
    game.hit(secondHand)
    
    verifyPlayerWon(25)
    verifyPlayerLost(with: secondHand)
  }
  
  func testGameOutput() {
    game.dealer = FixedCardsDealer(with: [queen, ace, king])
    
    game.dealStartingHands()
  }
  
  // MARK: helpers
  
  var playerHand: BettedHand {
    return game.playerHands.first!
  }
  
  func verifyPlayerWon(amount: Double) {
    verifyPlayerWon(amount, with: playerHand)
  }
  
  func verifyPlayerWon(amount: Double, with hand: BettedHand, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(hand.result, BettedHand.Result.Won)
    XCTAssertEqual(hand.paid.amount, amount)
  }
  
  func verifyPlayerLost() {
    verifyPlayerLost(with: playerHand)
  }
  
  func verifyPlayerLost(with hand: BettedHand, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(hand.result, BettedHand.Result.Lost)
  }
  
  func verifyPlayerTiedAndGetBack(amount: Double, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(playerHand.result, BettedHand.Result.Tied)
    XCTAssertEqual(playerHand.paid.amount, amount)
  }
  
  func verifyOutput(of game: Game, is event: [Event]) {
    
  }
}

class BlackjackMultiHandsGameTests: BlackjackGameTests {
  override func setUp() {
    super.setUp()
  }
}
