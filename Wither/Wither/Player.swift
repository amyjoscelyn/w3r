//
//  Player.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let cards_allowed_in_hand = 3

class Player
{
    let name: String
    var deck: [Card] = []
    var hand: [Card] = []
    var cardsInPlay: [Card] = []
    var cardForWar: Card?
    
    init(name: String)
    {
        self.name = name
    }
    //there's very little point to having this functionality if the player never gets to choose their own name
    
    func drawCardsToHand()
    {
        if self.deck.count >= cards_allowed_in_hand
        {
            for i in 0..<cards_allowed_in_hand
            {
                self.hand.append(self.deck.removeAtIndex(i))
            }
        }
        else
        {
            for i in 0..<self.deck.count
            {
                self.hand.append(self.deck.removeAtIndex(i))
            }
        }
        //does this cover what happens if there are no cards left?  i feel like that condition should be satisfied elsewhere, in a gameIsOver kind of way
    }
    
    //    func supportingCardForWar()
    //    {
    //        if self.deck.count > 1
    //        {
    //            self.cardForWar = self.deck.removeFirst()
    //        }
    //    }
    
        func didWin(cards: [Card])
        {
            self.deck.appendContentsOf(cards)
        }
}
