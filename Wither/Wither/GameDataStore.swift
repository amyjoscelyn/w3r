//
//  GameDataStore.swift
//  Wither
//
//  Created by Amy Joscelyn on 8/19/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

class GameDataStore
{   
    static let sharedInstance = GameDataStore()
    private init() {}
    
    var totalPlayerScore = 0
    var totalAIScore = 0
    var currentPlayerScore = 0
    var currentAIScore = 0
    
    var hasDisplayedScores = false
    
    func updateScores(scores: [Int])
    {
        self.currentPlayerScore = scores.first!
        self.currentAIScore = scores.last!
        
        totalPlayerScore += self.currentPlayerScore
        totalAIScore += self.currentAIScore
    }
    
    var playerCardTrackerArray: [Int] = []
    
//    func trackColumn(column: Int)
//    {
//        if self.playerCardTrackerArray.count > 5
//        {
//            self.playerCardTrackerArray.removeFirst()
//        }
//        self.playerCardTrackerArray.append(column)
//        
//        print("GameDataStore tracked columns: \(self.playerCardTrackerArray)")
//    }
}
