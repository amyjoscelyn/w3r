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
    @IBOutlet weak var rulesLine2: UILabel!
    @IBOutlet weak var rulesLine3: UILabel!
    @IBOutlet weak var rulesLine4: UILabel!
    
    let gameDataStore = GameDataStore.sharedInstance
    
    class func fontSizeForScreenWidth() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width / 19
    }
    
    var fontSize: CGFloat = { return Rules.fontSizeForScreenWidth() }()
    
    func displayFirstSetOfRules()
    {
        print(self.fontSize)
        self.rulesLine1.font = self.rulesLine1.font.fontWithSize(self.fontSize)
        self.rulesLine2.font = self.rulesLine2.font.fontWithSize(self.fontSize)
        self.rulesLine3.font = self.rulesLine3.font.fontWithSize(self.fontSize)
        self.rulesLine4.font = self.rulesLine4.font.fontWithSize(self.fontSize)
        
        self.rulesLine1.text = "Each player begins with a full deck"
        self.rulesLine2.text = "Deal hand by dragging your deck toward the middle bar"
        self.rulesLine3.text = "Hands consist of three cards each"
        self.rulesLine4.text = "Tap to reveal opponents cards"
        
        self.gameDataStore.pageOfRulesDisplayed = 1
    }
    
    func displaySecondSetOfRules()
    {
        self.rulesLine1.text = "Play goes left to right"
        self.rulesLine2.text = "Each card evaluates as a win (👑), loss (❌), or war (⚔)"
        self.rulesLine3.text = "Wars are immediately resolved"
        self.rulesLine4.text = "Round ends when all cards have been judged"
        
        self.gameDataStore.pageOfRulesDisplayed = 2
    }
    
    func displayThirdSetOfRules()
    {
        self.rulesLine1.text = "Beat two of three cards to win hand"
        self.rulesLine2.text = "Loser discards all cards in play"
        self.rulesLine3.text = "Winner keeps the cards that won outright"
        self.rulesLine4.text = "Tap to clear hands"
        
        self.gameDataStore.pageOfRulesDisplayed = 3
    }
    
    func displayFourthSetOfRules()
    {
        self.rulesLine1.text = "Play continues until the game ends:"
        self.rulesLine2.text = "When a player doesn't have enough cards"
        self.rulesLine3.text = "To fill out a new hand or resolve a war"
        self.rulesLine4.text = ""
        
        self.gameDataStore.pageOfRulesDisplayed = 4
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
