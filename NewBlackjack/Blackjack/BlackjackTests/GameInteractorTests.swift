//
//  GameInteractorTests.swift
//  Blackjack
//
//  Created by Feng Xiong on 16/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import XCTest
@testable import Blackjack

class GameSpy: Game {
  var willHit = false
  var willStand = false
  var willDouble = false
  var willSplit = false
  
  init() {
    super.init(bets: [("Player", GBP(10))])
  }
  
  override func hit(hand: BettedHand) {
    willHit = true
  }
  
  override func stand(hand: BettedHand) {
    willStand = true
  }
  
  override func double(hand: BettedHand) {
    willDouble = true
  }
  
  override func split(hand: BettedHand) {
    willSplit = true
  }
}

class GameInteractorSpy: GameInteractor {
  var gameStateDidChange = false
  
  override func createNewGame(with bets: [(AnyObject, Money)]) -> Game {
    return GameSpy()
  }
  
  override func updateGameState() {
    gameStateDidChange = true
  }
}

class GameInteractorTests: XCTestCase {
  var interactor: GameInteractorSpy!
  var game: GameSpy!
  
  override func setUp() {
    super.setUp()
    
    interactor = GameInteractorSpy()
    interactor.startNewGame(with: [])
    game = interactor.game as! GameSpy
  }
  
  func testHandleHitCommand() {
    let command = HitCommand()
    
    interactor.handleCommand(command)
    
    XCTAssertTrue(game.willHit)
    XCTAssertTrue(interactor.gameStateDidChange)
  }
  
  func testHandleStandCommand() {
    let game = interactor.game as! GameSpy
    let command = StandCommand()
    
    interactor.handleCommand(command)
    
    XCTAssertTrue(game.willStand)
  }
  
  func testHandleDoubleCommand() {
    let game = interactor.game as! GameSpy
    let command = DoubleCommand()
    
    interactor.handleCommand(command)
    
    XCTAssertTrue(game.willDouble)
  }
  
  func testHandleSplitCommand() {
    let game = interactor.game as! GameSpy
    let command = SplitCommand()
    
    interactor.handleCommand(command)
    
    XCTAssertTrue(game.willSplit)
  }
}
