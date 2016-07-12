//
//  Game.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

class Game
{
    let player: Player
    let aiPlayer: AIPlayer
    
    init()
    {
        self.player = Player.init()
        self.aiPlayer = AIPlayer.init()
    }
    
    func startGame()
    {
        self.player.deck.shuffle()
        self.aiPlayer.deck.shuffle()
    }
    
    func drawHands()
    {
        let playerDeckCount = self.player.deck.cards.count
        let aiPlayerDeckCount = self.aiPlayer.deck.cards.count
        
        if playerDeckCount >= 3 && aiPlayerDeckCount >= 3
        {
            self.player.fillHand()
            self.aiPlayer.fillHand()
        }
        else
        {
            self.player.fillHandWithSingleCard()
            self.aiPlayer.fillHandWithSingleCard()
        }
    }
    
    func twoCardFaceOff(playerCard: Card, aiPlayerCard: Card) -> String
    {
        var cardWinner = ""
        
        if playerCard.cardValue > aiPlayerCard.cardValue
        {
            cardWinner = "Player"
        }
        else if playerCard.cardValue < aiPlayerCard.cardValue
        {
            cardWinner = "AI"
        }
        else
        {
            cardWinner = "War"
        }
        
        return cardWinner
    }
    
    func war()
    {
        self.player.dealCardForWar()
        self.aiPlayer.dealCardForWar()
    }
    
    func warIsDone()
    {
        self.player.clearCardsForWar()
        self.aiPlayer.clearCardsForWar()
    }
}