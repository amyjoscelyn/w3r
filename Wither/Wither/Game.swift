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
    let deck2: Deck //two decks are only used when longer gameplay is requested
    let player: Player
    let ai: AIPlayer
    var cardsInPlay: [Card] = []
    
    init()
    {
        self.deck1 = Deck.init()
        self.deck2 = Deck.init()
        self.player = Player.init(name: "Player")
        self.ai = AIPlayer.init(name: "AI")
    }
    
    func deal()
    {
        self.player.deck.removeAll()
        
        self.deck1.shuffle()
        self.deck2.shuffle()
        
        for i in 0..<deck_size
        { //change this!!!  it doesn't need to alternate
            //except when shorter gameplay is requested
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
     
     Jokers can be played as Assassins or Berserkers.
     Assassins can kill any face card they come across, but are killed by numbered cards.  When two jokers face off, it can either be treated as they cross paths in the night (safely, both jokers returned and each war hand resolved individually) or they cancel each other out.
     Berserkers play like superpowered Aces--they kill any card they face, but are discarded at the end of the round.  Two jokers facing each other would negate each other and both be discarded, the remaining faceoffs resolved individually.
     
     Cards at the end less than three can be played one at a time to reduce the points of the other player.
     
     Play comes in Campaigns: Short, Medium, and Long.
     
     Short-13 points
     Medium-26 points
     Long-52 points
     
     Points are the amount of cards remaining at the end of the battle.  The winner and loser can both have points remaining.  Cumulative until the campaign point total is reached or surpassed by one player.
     
     Duels: the winner survives, the loser is killed, and for ties both are taken back into the hand.  Can be played with the One-Shot variant, or To The Death.  Also the Challenger/Upstart mode.
     One-Shot: with the roll of a single die per face-card duel, the winner of the roll wins the duel, getting their shot off successfully.  In a tie, both would be misfires, returning the cards back into their players' deck, or they would both hit.  An option.  In a tie, the other faceoffs would be resolved individually.
     To The Death: Same as above, but in a tie, the dice are rolled again until there is a clear winner.  This means there will always be best 2/3 for each round.
     Upstart: Duels are played whenever face cards are played against each other.  Dice are awarded based on face card value: 1 for J, 2 for Q, 3 for K, 4 for A.  All appropriate dice are rolled at the same time, and the collective total dice value for each side is pitted against the other.  This is weighted towards the higher value card side, but with a really good roll, there is a possibility for a J to take an A.  Tied values can have the same options of play as One-Shot.
     
     Hands are played best two out of three--loser discards all cards from the round.  Winner keeps all cards unless one hand was beaten out, in which case that single card (or war) is destroyed.
     
     When there's a war, the outcome is treated as the outcome for a normal hand, once it's been resolved.
     
     If the war isn't needed to determine the winner of the round, the round's loser gets to decide whether they want to push for the war.  Logically, it only makes sense if the war is for good cards--the loser is going to lose that card regardless of how the war turns out, but if they win the war it means the round's winner must discard that card.
     
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