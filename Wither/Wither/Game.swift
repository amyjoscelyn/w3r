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
            print("PLAYERS HAVE THREE OR MORE CARDS IN HAND")
            self.player.fillHand()
            self.aiPlayer.fillHand()
        }
        else if playerDeckCount > 0 && aiPlayerDeckCount > 0
        {
            print("IT'S DOWN TO THE END!!!! (less than three cards in a player's hand)")
            self.player.fillHandWithSingleCard()
            self.aiPlayer.fillHandWithSingleCard()
        }
        else
        {
            print("[inside drawHands()] PLAYER DECK COUNT: \(playerDeckCount) || AI DECK COUNT: \(aiPlayerDeckCount)")
            print("~~==ooo==~~ game is over! ~~==ooo==~~")
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
    {//what happens when there are no many cards left to draw?
        self.player.dealCardForWar()
        self.aiPlayer.dealCardForWar()
    }
    
    func warIsDone()
    {
        self.player.clearCardsForWar()
        self.aiPlayer.clearCardsForWar()
    }
}