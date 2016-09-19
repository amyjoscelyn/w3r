//
//  GameOver.swift
//  Wither
//
//  Created by Amy Joscelyn on 8/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class GameOver: UIView
{
    @IBOutlet private var contentView: UIView?
    
    @IBOutlet weak var winnerEmojiLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currentPlayerScoreLabel: UILabel!
    @IBOutlet weak var currentAIPlayerScoreLabel: UILabel!
    @IBOutlet weak var totalPlayerScoreLabel: UILabel!
    @IBOutlet weak var totalAIPlayerScoreLabel: UILabel!
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var aiPlayerLabel: UILabel!
    @IBOutlet weak var playAgainLabel: UILabel!
    
    let gameDataStore = GameDataStore.sharedInstance
    
    class func fontSizeForScreenWidth() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width / 19
    }
    
    var fontSize: CGFloat = { return GameOver.fontSizeForScreenWidth() }()
    
    //okay.
    //I need a displayMethod that hides all but the winner labels
    //then i need to add a tap gesture--when tapped, it should fade the winner labels and show the hidden ones
    //which means they shoudln't be hidden, they should have their alphas set to 0
    //in order to know this, i need to figure out the scores and then the winner
    //once i know the winner, i can display the proper label info--We won! and a crown emoji, They won. and an X emoji (or maybe a sad one, or a white flag?), or Stalemate (maybe this should have the white flag?  Signifying a surrender from each side?)
    //set the info for the rest of the labels too--current score (from remaining cards in deck), total score (from singleton data store), and determine campaign winner so far: We're winning!  They're winning.  It's head to head...
    //maybe the button should say something like Keep on!  Battle on!  Or Fight on!  Or Battle Again! or something to that effect.
    //along with that, the rest of the labels and button are alpha'd out
    //then the tap comes
    //alpha out the winner labels, fade back in the rest
    
    func displayLabelsWithInfo()
    {
        self.populateLabelsWithInfo()
        
        self.resultLabel.alpha = 0
        self.currentPlayerScoreLabel.alpha = 0
        self.currentAIPlayerScoreLabel.alpha = 0
        self.totalPlayerScoreLabel.alpha = 0
        self.totalAIPlayerScoreLabel.alpha = 0
        self.playerLabel.alpha = 0
        self.aiPlayerLabel.alpha = 0
        self.playAgainLabel.alpha = 0
        
        self.winnerEmojiLabel.alpha = 1
        self.winnerLabel.alpha = 1
        
//        let playerScore = self.gameDataStore.totalPlayerScore
//        let aiPlayerScore = self.gameDataStore.totalAIScore
//        
//        var winnerMessage = "The game is tied!"
//        
//        if playerScore > aiPlayerScore
//        {
//            winnerMessage = "You're winning the war!"
//        }
//        else if aiPlayerScore > playerScore
//        {
//            winnerMessage = "You're losing the war."
//        }
//        else
//        {
//            winnerMessage = "This war is head to head!"
//        }
//        
//        self.currentPlayerScoreLabel.text = "\(playerScore)"
//        self.currentAIPlayerScoreLabel.text = "\(aiPlayerScore)"
//        
//        self.resultLabel.text = "\(winnerMessage)"
    }
    
    func populateLabelsWithInfo()
    {
        let currentPlayerScore = self.gameDataStore.currentPlayerScore
        let currentAIPlayerScore = self.gameDataStore.currentAIScore
        
        self.currentPlayerScoreLabel.text = "\(currentPlayerScore)"
        self.currentAIPlayerScoreLabel.text = "\(currentAIPlayerScore)"
        
        var winnerMessage = "Round is over."
        var winnerEmoji = "🤔"
        
        if currentPlayerScore > currentAIPlayerScore
        {
            winnerMessage = "We won!"
            winnerEmoji = "👑"
        }
        if currentAIPlayerScore > currentPlayerScore
        {
            winnerMessage = "They won."
            winnerEmoji = "🤕"
        }
        else
        {
            winnerMessage = "Stalemate"
            winnerEmoji = "🏳"
        }
        self.winnerLabel.text = winnerMessage
        self.winnerEmojiLabel.text = winnerEmoji
        
        let totalPlayerScore = self.gameDataStore.totalPlayerScore
        let totalAIPlayerScore = self.gameDataStore.totalAIScore
        
        self.totalPlayerScoreLabel.text = "\(totalPlayerScore)"
        self.totalAIPlayerScoreLabel.text = "\(totalAIPlayerScore)"
        
        var resultMessage = "Game is over"
        
        if totalPlayerScore > totalAIPlayerScore
        {
            resultMessage = "We're winning the war!"
        }
        else if totalAIPlayerScore > totalPlayerScore
        {
            resultMessage = "They're winning the war."
        }
        else
        {
            resultMessage = "It's head to head..."
        }
        
        self.resultLabel.text = resultMessage
    }
    
    func displayScores()
    {
        let duration: NSTimeInterval = 0.25
        UIView.animateWithDuration(duration, animations:
            {
            self.resultLabel.alpha = 1;
            self.currentPlayerScoreLabel.alpha = 1;
            self.currentAIPlayerScoreLabel.alpha = 1;
            self.totalPlayerScoreLabel.alpha = 1;
            self.totalAIPlayerScoreLabel.alpha = 1;
            self.playerLabel.alpha = 1;
            self.aiPlayerLabel.alpha = 1;
            self.playAgainLabel.alpha = 1;
            
            self.winnerEmojiLabel.alpha = 0;
            self.winnerLabel.alpha = 0
        })
        
        self.gameDataStore.hasDisplayedScores = true
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
        let content = NSBundle.mainBundle().loadNibNamed("GameOver", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
