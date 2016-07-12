//
//  Player.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let max_hand_size = 3

class Player
{
    var deck: Deck
    var hand: [Card] = []
    var discard: [Card] = []
//    var warCard: Card?
    var warCards: [Card] = []
    
    init()
    {
        self.deck = Deck.init()
    }
    
    func fillHand()
    {
        if self.deck.cards.count >= max_hand_size
        {
            for _ in 0..<max_hand_size
            {
                self.hand.append(self.deck.drawCard())
            }
        }
    }
    
    func fillHandWithSingleCard()
    {
        self.hand.append(self.deck.drawCard())
    }
    
    func dealCardForWar()
    {
        self.warCards.append(self.deck.drawCard())
    }
    
    func clearCardsForWar()
    {
        self.warCards.removeAll()
    }
}
