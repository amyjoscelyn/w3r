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
    let gameDataStore = GameDataStore.sharedInstance
    
    var savePlayerCards: [Card] = []
    var saveAICards: [Card] = []
    var discardPlayerCards: [Card] = []
    var discardAICards: [Card] = []
    
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
//            print("PLAYERS HAVE THREE OR MORE CARDS IN HAND")
            self.player.fillHand()
            self.aiPlayer.fillHand()
        }
        else if playerDeckCount > 0 && aiPlayerDeckCount > 0
        {
//            print("IT'S DOWN TO THE END!!!! (less than three cards in a player's hand)")
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
    
    func trackCard()
    {
        let column = self.player.columnOfHighestCard()
        print("GameVC column with highest card: \(column)")
        self.gameDataStore.playerCardTrackerArray.append(column)
    }
    
    func war()
    {//what happens when there are no more cards left to draw?
        self.player.dealCardForWar()
        self.aiPlayer.dealCardForWar()
    }
    
    func warIsDone()
    {
        self.player.clearCardsForWar()
        self.aiPlayer.clearCardsForWar()
    }
    
    func endRound()
    {
        self.player.clearHandValues()
        self.aiPlayer.clearHandValues()
        
        self.discardCards()
        self.saveCards()   
    }
    
    func discardCards()
    {
        self.player.discard.appendContentsOf(self.discardPlayerCards)
        self.aiPlayer.discard.appendContentsOf(self.discardAICards)
        
        self.discardPlayerCards.removeAll()
        self.discardAICards.removeAll()
    }
    
    func saveCards()
    {
        self.player.deck.cards.appendContentsOf(self.savePlayerCards)
        self.aiPlayer.deck.cards.appendContentsOf(self.saveAICards)
        
        self.savePlayerCards.removeAll()
        self.saveAICards.removeAll()
    }
}