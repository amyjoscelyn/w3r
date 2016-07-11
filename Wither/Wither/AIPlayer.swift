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
    func shouldResolveWar(cardValue: Int) -> Bool
    {
        if self.deck.cards.count > half_deck_count
        {
            return cardValue == king_value
        }
        else
        {
            return cardValue == ace_value
        }
    }
}
