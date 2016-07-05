//
//  Game.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import Foundation

let deck_size = 52

class Game
{
    let deck1: Deck
    let deck2: Deck
    let player: Player
    let ai: AIPlayer
    var cardsInPlay: [Card] = []
    
//    let aiDeck: Deck
//    let playerDeck: Deck
//    let aiPlayer: AIPlayer
//    let player: Player
//    var cardsInPlay: [Card] = []
    
    init()
    {
        self.deck1 = Deck.init()
        self.deck2 = Deck.init()
        self.player = Player.init(name: "Player")
        self.ai = AIPlayer.init(name: "AI")
    }
    
//    init()
//    {
//        self.aiDeck = Deck.init()
//        self.playerDeck = Deck.init()
//        self.aiPlayer = AIPlayer.init(name: "AI")
//        self.player = Player.init(name: "Player")
//    }
    
    func deal()
    {
        self.player.deck.removeAll()
        
        self.deck1.shuffle()
        self.deck2.shuffle()
        
        for i in 0..<deck_size
        { //change this!!!  it doesn't need to alternate
            //can I do a card in deck kind of loop?
            if i % 2 == 0
            {
                self.player.deck.append(self.deck1.drawCard())
                self.ai.deck.append(self.deck2.drawCard())
            }
            else
            {
                self.player.deck.append(self.deck1.drawCard())
                self.ai.deck.append(self.deck2.drawCard())
            }
        }
        print("cards dealt out: \(self.player.deck.count)")
        print("cards dealt out: \(self.ai.deck.count)")
    }
    
//    func deal()
//    {
//        self.aiDeck.shuffle()
//        self.playerDeck.shuffle()
//        
//        for _ in 0..<52
//        {
//            self.aiPlayer.deck.append(self.aiDeck.drawCard())
//            self.player.deck.append(self.playerDeck.drawCard())
//        }
//        print("player deck contains \(self.playerDeck) cards")
//        print("but the player's deck has \(self.player.deck.count) cards in it")
//        print("card 1: \(self.player.deck[0])")
//    }
    
    func round()
    {//as long as there is still at least a single card left in their deck this can be called
        if self.ai.hand.count == 0
        {
            self.ai.drawCardsToHand()
        }
        
        if self.player.hand.count == 0
        {
            self.player.drawCardsToHand()
        }
    }

    /*
     W3r ?? w3r ?? W3R [Wither] or {Wither}
     
     Variants:
     Attrition (basic variant, cards face-up for wars, cards placed three at a time)
     Assassins (Jokers join in, can kill any face cards, killed by numbered cards)
     Duels (wars between equal face cards are "duels", where a toss of the die simulates a shot)
     
     Jokers can be switched on and off.
     
     Cards at the end less than three can be played one at a time to reduce the points of the other player.
     
     Play comes in Campaigns: Short, Medium, and Long.
     
     Short-13 points
     Medium-26 points
     Long-52 points
     
     Points are the amount of cards remaining at the end of the battle.  The winner and loser can both have points remaining.
     
     Duels: the winner survives, the loser is killed, and for ties both are taken back into the hand.
     
     Hands are played best two out of three--loser discards all cards from the round.  Winner keeps all cards unless one hand was beaten out, in which case that single card (or war) is destroyed.
     
     When there's a war, the outcome is treated as the outcome for a normal hand, once it's been resolved.
     
     Classes:
     Card (sets up card labels)
     Deck (puts the deck together in an OrderedSet)
     Player (play methods)
     AI (inherited from Player, logic automated)
     Dealer (shuffle method)
     
     Playfield: the winning line.  The cards in play go right outside the line.  They're animated to show they've won, winning cards crossing the line to cover the losing card.  Wars stay head to head, one card then placed halfway over it and judged.
     
     If a game ends in a war, but one player cannot follow through, that player automatically loses.
     */
}