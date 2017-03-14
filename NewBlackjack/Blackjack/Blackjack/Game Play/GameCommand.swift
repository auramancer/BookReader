//
//  GameCommand.swift
//  Blackjack
//
//  Created by Feng Xiong on 16/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

protocol GameCommand {
  func execute(by game: Game)
}

class HitCommand: GameCommand {
  func execute(by game: Game) {
    game.hit(hand: game.playerHands.first!)
  }
}

class StandCommand: GameCommand {
  func execute(by game: Game) {
    game.stand(hand: game.playerHands.first!)
  }
}

class DoubleCommand: GameCommand {
  func execute(by game: Game) {
    game.double(hand: game.playerHands.first!)
  }
}

class SplitCommand: GameCommand {
  func execute(by game: Game) {
    game.split(hand: game.playerHands.first!)
  }
}

