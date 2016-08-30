//
//  Game.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let win_result_string = "Win"
let loss_result_string = "Loss"
let war_result_string = "War"

class Game
{
    let player: Player
    let aiPlayer: AIPlayer
    let gameDataStore = GameDataStore.sharedInstance
    
    var savePlayerCards: [Card] = []
    var saveAICards: [Card] = []
    var discardPlayerCards: [Card] = []
    var discardAICards: [Card] = []
    
    var playerColumnWins: Int = 0
    
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
    
    //resultOfBattle? Skirmish? ColumnWar?
    func resultOfColumnResolution(cards: [Card]) -> String
    {
        var result = ""
        
        let playerCard = cards.first!
        let aiPlayerCard = cards.last!
        
        if playerCard.cardValue > aiPlayerCard.cardValue
        {
            result = win_result_string
        }
        else if playerCard.cardValue < aiPlayerCard.cardValue
        {
            result = loss_result_string
        }
        else
        {
            result = war_result_string
        }
        
        return result
    }
    
    func twoCardFaceOff(playerCard: Card, aiPlayerCard: Card) -> String
    {
        var cardWinner = ""
        
        if playerCard.cardValue > aiPlayerCard.cardValue
        {
            cardWinner = "Player"
            self.playerColumnWins += 1
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
    {//what happens when there are no more cards left to draw?
        self.player.dealCardForWar()
        self.aiPlayer.dealCardForWar()
    }
    
    func warIsDone()
    {
        self.player.clearCardsForWar()
        self.aiPlayer.clearCardsForWar()
    }
    
    func winnerOfHand() -> String
    {
        if self.playerColumnWins >= 2
        {
            //player wins hand
            self.discardAICards.appendContentsOf(self.saveAICards)
            self.saveAICards.removeAll()
            
            return player_string
        }
        else
        {
            //AI wins hand
            self.discardPlayerCards.appendContentsOf(self.savePlayerCards)
            self.savePlayerCards.removeAll()
            
            return ai_string
        }
    }
    
    func endRound()
    {
//        self.player.clearHandValues()
        self.aiPlayer.clearHandValues() //not using this right now...
        
        self.playerColumnWins = 0
        
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
    
    func canPlayWar() -> Bool
    {
        var canPlayWar = true
        
        let playerDeck = self.player.deck.cards
        let aiDeck = self.aiPlayer.deck.cards
        
        if playerDeck.count < 1 || aiDeck.count < 1
        {
            //game is over
            canPlayWar = false
        }
        
        return canPlayWar
    }
    
    func isGameOver() -> Bool
    {
        var gameIsOver = false
        
        let playerDeck = self.player.deck.cards
        let aiDeck = self.aiPlayer.deck.cards
        
        if playerDeck.count < 3 || aiDeck.count < 3
        {
            //game is over
            gameIsOver = true
        }
        
        return gameIsOver
    }
    
    func resetGame()
    {
        self.player.replenishDeck()
        self.aiPlayer.replenishDeck()
    }
}