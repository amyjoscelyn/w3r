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