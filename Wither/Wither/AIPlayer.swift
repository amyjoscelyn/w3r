//
//  AIPlayer.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/2/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let ace_value = 14

class AIPlayer: Player
{
    func shouldResolveWar(cardValue: Int) -> Bool
    {
        return cardValue == ace_value
    }
}
