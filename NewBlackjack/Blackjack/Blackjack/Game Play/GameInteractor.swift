//
//  GameInteractor.swift
//  Blackjack
//
//  Created by Feng Xiong on 16/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

class GameInteractor {
  var game: Game?
  
  init() {
  }
  
  func startNewGame(with bets: [(AnyObject, Money)]) {
    game = createNewGame(with: bets)
    observeGame()
  }
  
  func createNewGame(with bets: [(AnyObject, Money)]) -> Game {
    return Game(bets: bets)
  }
  
  func observeGame() {
    
  }
  
  func updateGameState() {
    
  }
  
  func handleCommand(command: GameCommand) {
    if let game = game {
      command.execute(by: game)
    }
  }
}