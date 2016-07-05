//
//  Deck.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

class Deck
{
    private var dealtCards: [Card] = []
    private var undealtCards: [Card] = []
    var description: String {
        return "Cards Remaining: \(undealtCards.count) Cards Dealt: \(dealtCards.count)"
    }
    
    init()
    {
        let suits = Card.validSuits()
        let ranks = Card.validRanks()
        
        var card: Card
        
        for suit in suits
        {
            for rank in ranks
            {
                card = Card.init(suit: suit, rank: rank)
                self.undealtCards.append(card)
            }
        }
    }
    
    func drawCard() -> Card
    {
        let lastIndex = self.undealtCards.count - 1
        let card = self.undealtCards.removeAtIndex(lastIndex)
        self.dealtCards.append(card)
        return card
    }
    
    func shuffle()
    {
        self.dealtCards.appendContentsOf(self.undealtCards)
        self.undealtCards.removeAll()
        
        while self.dealtCards.count > 0
        {
            let lastIndex = self.dealtCards.count - 1
            
            let randomIndex = arc4random_uniform(UInt32(lastIndex))
            
            let card = self.dealtCards.removeAtIndex(Int(randomIndex))
            
            self.undealtCards.append(card)
        }
    }
}
