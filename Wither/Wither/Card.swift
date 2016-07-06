//
//  Card.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/29/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

class Card
{
    class func allSuits() -> [String]
    {
        let spades = "♠️"
        let clubs = "♣️"
        let hearts = "♥️"
        let diamonds = "♦️"
        
        return [ spades, clubs, hearts, diamonds ]
    }
    
    class func allRanks() -> [String]
    {
        return [ "A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2" ]
    }
    
    let suit: String
    let rank: String
    let cardLabel: String
    let cardValue: Int
    
    init(suit: String, rank: String)
    {
        self.suit = suit
        self.rank = rank
        self.cardLabel = suit + rank
        
        switch rank
        {
        case "A":
            self.cardValue = 14
        case "K":
            self.cardValue = 13
        case "Q":
            self.cardValue = 12
        case "J":
            self.cardValue = 11
        default:
            self.cardValue = Int(rank)!
        }
    }
}
