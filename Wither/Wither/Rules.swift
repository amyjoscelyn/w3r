//
//  Rules.swift
//  Wither
//
//  Created by Amy Joscelyn on 9/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class Rules: UIView
    
{
    @IBOutlet private var contentView: UIView?
    @IBOutlet weak var rulesLine1: UILabel!
    
    let gameDataStore = GameDataStore.sharedInstance
    
    class func fontSizeForScreenWidth() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width / 19
    }
    
    var fontSize: CGFloat = { return Rules.fontSizeForScreenWidth() }()
    
    let rule1 = "w3r is a variant of the card game War, with a dash of Rock-Paper-Scissors mixed in."
    let rule2 = "Each player starts with a full deck (tap or drag the deck up toward the middle bar to begin the round).  As in War, cards are flipped from each deck and pitted against each other."
    let rule3 = "Unlike War, each player in w3r is dealt a hand of three cards.  These three cards can be reordered (hold and drag to swap their positions); where will you play your best card?  Your worst?  When satisfied, tap and the opponent's cards will be revealed."
    let rule4 = "Cards are evaluated one column at a time, left to right.  If your card is higher, you win that column (\(winning_emoji)).  If your card is lower, you've lost that column (\(loss_emoji)).  If both cards are the same (\(war_emoji)), there's a war!"
    let rule5 = "Wars are resolved immediately (with a tap) by drawing the first card from the top of the deck.  These new cards are evaluated again - win, loss, or war?  Once all columns are either a win or a loss, the round's winner is determined!"
    let rule6 = "Best two of three decides the winner.  The winner keeps the cards that outright won their column (including all cards involved in a war) and add them back to their deck.  The cards in a column the winner lost are discarded."
    let rule7 = "The loser discards all their cards, regardless if any had beat the other player.  Each player possesses their own deck, and the decks never mix."
    let rule8 = "Play continues until a player no longer has three cards in their deck to deal a full hand, or any cards to resolve a war.  Whoever has the most cards remaining wins the battle."
    let rule9 = "Play on to see who will win the war!"
    
    func displayRules()
    {
        if self.gameDataStore.pageOfRulesDisplayed == 0
        {
            self.rulesLine1.font = self.rulesLine1.font.fontWithSize(self.fontSize)
            self.rulesLine1.text = self.rule1
            self.gameDataStore.pageOfRulesDisplayed = 1
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 1
        {
            self.rulesLine1.text = self.rule2
            self.gameDataStore.pageOfRulesDisplayed = 2
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 2
        {
            self.rulesLine1.text = self.rule3
            self.gameDataStore.pageOfRulesDisplayed = 3
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 3
        {
            self.rulesLine1.text = self.rule4
            self.gameDataStore.pageOfRulesDisplayed = 4
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 4
        {
            self.rulesLine1.text = self.rule5
            self.gameDataStore.pageOfRulesDisplayed = 5
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 5
        {
            self.rulesLine1.text = self.rule6
            self.gameDataStore.pageOfRulesDisplayed = 6
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 6
        {
            self.rulesLine1.text = self.rule7
            self.gameDataStore.pageOfRulesDisplayed = 7
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 7
        {
            self.rulesLine1.text = self.rule8
            self.gameDataStore.pageOfRulesDisplayed = 8
        }
        else if self.gameDataStore.pageOfRulesDisplayed == 8
        {
            self.rulesLine1.text = self.rule9
            self.gameDataStore.pageOfRulesDisplayed = 9
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit()
    {
        let content = NSBundle.mainBundle().loadNibNamed("Rules", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
