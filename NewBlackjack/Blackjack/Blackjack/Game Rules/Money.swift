//
//  Money.swift
//  Blackjack
//
//  Created by Feng Xiong on 12/09/2016.
//  Copyright © 2016 FF. All rights reserved.
//

import Foundation

struct Money {
  enum Currency: String {
    case GBP = "GBP"
    case USD = "USD"
  }
  
  let currency: Currency
  var amount: Double
  
  init(currency: Currency, amount: Double) {
    self.currency = currency
    self.amount = amount
  }
}

func GBP(_ amount: Double) -> Money {
  return Money(currency: .GBP, amount: amount)
}

func GBP(_ amount: Int) -> Money {
  return GBP(Double(amount))
}

func * (money: Money, multiplier: Double) -> Money {
  return Money(currency: money.currency, amount: money.amount * multiplier)
}
