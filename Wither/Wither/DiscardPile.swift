//
//  DiscardPile.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/28/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class DiscardPile: UIView
{
    @IBOutlet private var contentView: UIView?
    
    @IBOutlet weak var discardCardViewE: CardView!
    @IBOutlet weak var discardCardViewD: CardView!
    @IBOutlet weak var discardCardViewC: CardView!
    @IBOutlet weak var discardCardViewB: CardView!
    @IBOutlet weak var discardCardViewA: CardView!
    
    private var cardViews: [CardView] { return [ self.discardCardViewA, self.discardCardViewB, self.discardCardViewC, self.discardCardViewD, self.discardCardViewE ] }
    private var cards: [Card] = []
    private var player: String = ""
    
    func setPlayer(player: String)
    {
        self.player = player
    }
    
    func clearCards()
    {
        self.discardCardViewA.card = nil
        self.discardCardViewB.card = nil
        self.discardCardViewC.card = nil
        self.discardCardViewD.card = nil
        self.discardCardViewE.card = nil
    }
    
    func getViews() -> [CardView]
    {
        return self.cardViews
    }
    
    func rotateViews()
    {
        
        if self.player == player_string
        {
            self.discardCardViewA.transform = CGAffineTransformMakeRotation(1.5)
            self.discardCardViewB.transform = CGAffineTransformMakeRotation(5.1)
            self.discardCardViewC.transform = CGAffineTransformMakeRotation(2)
            self.discardCardViewD.transform = CGAffineTransformMakeRotation(0.9)
            self.discardCardViewE.transform = CGAffineTransformMakeRotation(0)
        }
        else
        {
            self.discardCardViewA.transform = CGAffineTransformMakeRotation(0)
            self.discardCardViewB.transform = CGAffineTransformMakeRotation(4.3)
            self.discardCardViewC.transform = CGAffineTransformMakeRotation(0.9)
            self.discardCardViewD.transform = CGAffineTransformMakeRotation(6.1)
            self.discardCardViewE.transform = CGAffineTransformMakeRotation(0.5)
        }
    }
    
    func addCards(cards: [Card])
    {
        self.cards.appendContentsOf(cards)
    }
    
    func populateCardViews()
    {
        var currentDiscardCount = self.cards.count
        //this is alwyas going to be the count of cards just discarded, never what it was before they were
        
        for card in self.cards
        {
            currentDiscardCount += 1
            
            switch currentDiscardCount % 5
            {
            case 1:
                self.discardCardViewA.card = card
                self.contentView?.bringSubviewToFront(self.discardCardViewA)
            case 2:
                self.discardCardViewB.card = card
                self.contentView?.bringSubviewToFront(self.discardCardViewB)
            case 3:
                self.discardCardViewC.card = card
                self.contentView?.bringSubviewToFront(self.discardCardViewC)
            case 4:
                self.discardCardViewD.card = card
                self.contentView?.bringSubviewToFront(self.discardCardViewD)
            default:
                self.discardCardViewE.card = card
                self.contentView?.bringSubviewToFront(self.discardCardViewE)
            }
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
        let content = NSBundle.mainBundle().loadNibNamed("DiscardPile", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
