//
//  AIPlayer.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/2/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let king_value = 13
let ace_value = 14

let half_deck_count = 26

class AIPlayer: Player
{
    override func fillHand()
    {
        super.fillHand()
        //orderCards()
    }
    
    func orderCards()
    {
        let minCardValue = self.handValues.minElement()
        let column = self.handValues.indexOf(minCardValue!)
        
        let card = self.hand.removeAtIndex(column!)
//        self.hand.insert(card, atIndex: <#T##Int#>)
        
        //so I know the column of the minValue...
    }
    
    func shouldResolveWar(cardValue: Int) -> Bool
    {
        if self.deck.cards.count > 40
        {
            return cardValue >= 10
        }
        if self.deck.cards.count > half_deck_count
        {
            return cardValue >= king_value
        }
        else
        {
            return cardValue == ace_value
        }
    }
}
