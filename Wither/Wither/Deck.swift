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
    var cards: [Card] = []
    
    init()
    {
        let suits = Card.allSuits()
        let ranks = Card.allRanks()
        
        for suit in suits
        {
            for rank in ranks
            {
                let card = (Card.init(suit: suit, rank: rank))
                cards.append(card)
            }
        }
    }
    
    func shuffle()
    {
        var shuffledCards: [Card] = []
        
        while self.cards.count > 0
        {
            let lastIndex = self.cards.count - 1
            let i = Int(arc4random_uniform(UInt32(lastIndex)))
            shuffledCards.append(self.cards.removeAtIndex(i))
        }
        self.cards.appendContentsOf(shuffledCards)
    }
    
    func drawCard() -> Card
    {
        return self.cards.removeAtIndex(0)
    }
}
