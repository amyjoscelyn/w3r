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
    let gameDataStore = GameDataStore.sharedInstance
    
    override func fillHand()
    {
        super.fillHand()
        orderCards()
    }
    
    func orderCards()
    {
        print("=================================== \n order of cards: \(self.hand[0].rank) \(self.hand[1].rank) \(self.hand[2].rank)")
        let trackedArray = gameDataStore.playerCardTrackerArray
        print("AIPlayer array of tracked columns: \(trackedArray)")
        
        if trackedArray.count != 0
        {
            let index = self.indexOfColumnPlayerTendsToPlaceHighestCard()
            let column = self.columnOfCardToSwap()
            print("AIPlayer column of special card: \(column)")
            let card = self.hand.removeAtIndex(column)
            self.hand.insert(card, atIndex: index)
        }
    }
    
    func indexOfColumnPlayerTendsToPlaceHighestCard() -> Int
    {
        let trackedArray = gameDataStore.playerCardTrackerArray
        var column1Count = 0
        var column2Count = 0
        var column3Count = 0
        
        for column in trackedArray
        {
            if column == 0
            {
                column1Count += 1
            }
            else if column == 1
            {
                column2Count += 1
            }
            else
            {
                column3Count += 1
            }
        }
        
        let columnCountArray = [ column1Count, column2Count, column3Count ]
        print("AIPlayer column count array: \(columnCountArray)")
        let maxCount = columnCountArray.maxElement()
        let column = columnCountArray.indexOf(maxCount!)
        print("AIPlayer frequency column: \(column)")
        
        return column!
    }
    
    func columnOfCardToSwap() -> Int
    {
        var column: Int
        
        if self.handValues.contains(ace_value)
        {
            column = self.handValues.indexOf(ace_value)!
        }
        else
        {
            let minCardValue = self.handValues.minElement()
            column = self.handValues.indexOf(minCardValue!)!
            
        }
        return column
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
