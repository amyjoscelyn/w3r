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
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var aiPlayerScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    let gameDataStore = GameDataStore.sharedInstance
    
    class func fontSizeForScreenWidth() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width / 19
    }
    
    var fontSize: CGFloat = { return GameOver.fontSizeForScreenWidth() }()
    
    func displayLabelsWithInfo()
    {
        let playerScore = self.gameDataStore.totalPlayerScore
        let aiPlayerScore = self.gameDataStore.totalAIScore
        
        var winnerMessage = "The game is tied!"
        
        if playerScore > aiPlayerScore
        {
            winnerMessage = "You're winning the war!"
        }
        else if aiPlayerScore > playerScore
        {
            winnerMessage = "You're losing the war."
        }
        else
        {
            winnerMessage = "This war is head to head!"
        }
        
        self.playerScoreLabel.text = "You: \(playerScore)"
        self.aiPlayerScoreLabel.text = "Opponent: \(aiPlayerScore)"
        self.winnerLabel.text = "\(winnerMessage)"
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
