//
//  AICardCluster.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/28/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class AICardCluster: UIView
{
    @IBOutlet private var contentView: UIView?
    @IBOutlet weak var baseCardView: CardView!
    @IBOutlet weak var cardViewA: CardView!
    @IBOutlet weak var cardViewB: CardView!
    @IBOutlet weak var cardViewC: CardView!
    
    private var cards: [Card] = []
    private var column: String = ""
    private var cardViews: [CardView] { return [ self.baseCardView, self.cardViewA, self.cardViewB, self.cardViewC ] }
    
    func getCardViews() -> [CardView]
    {
        return self.cardViews
    }
    
    func rotateCardViews()
    {
        switch self.column
        {
        case first_column:
            self.cardViewA.transform = CGAffineTransformMakeRotation(6.2)
            self.cardViewB.transform = CGAffineTransformMakeRotation(0.3)
            self.cardViewC.transform = CGAffineTransformMakeRotation(0.04)
        case second_column:
            self.cardViewA.transform = CGAffineTransformMakeRotation(0.2)
            self.cardViewB.transform = CGAffineTransformMakeRotation(6.1)
            self.cardViewC.transform = CGAffineTransformMakeRotation(6.23)
        default:
            self.cardViewA.transform = CGAffineTransformMakeRotation(0.5)
            self.cardViewB.transform = CGAffineTransformMakeRotation(6.05)
            self.cardViewC.transform = CGAffineTransformMakeRotation(0)
        }
    }
    
    func setColumn(column: String)
    {
        self.column = column
    }
    
    func addCard(card: Card)
    {
        self.cards.append(card)
    }
    
    func removeCards() -> [Card]
    {
        let arrayOfCards = self.cards
        self.cards.removeAll()
        return arrayOfCards
    }
    
    func cardToJudge() -> Card
    {
        return self.cards.last!
    }
    
    func faceDown()
    {
        self.baseCardView.faceUp = false
    }
    
    func showCard()
    {
        self.baseCardView.faceUp = true
    }
    
    func populateCardViews()
    {
        self.baseCardView.card = self.cards.first
        
        if self.cards.count > 1
        {
            let count = self.cards.count - 1
            let cardView: CardView
            
            switch count % 3
            {
            case 1:
                cardView = self.cardViewA
            case 2:
                cardView = self.cardViewB
            default:
                cardView = self.cardViewC
            }
            
            cardView.card = self.cards.last
            self.contentView?.bringSubviewToFront(cardView)
        }
        else
        {
            self.cardViewA.card = nil
            self.cardViewB.card = nil
            self.cardViewC.card = nil
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
        let content = NSBundle.mainBundle().loadNibNamed("AICardCluster", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
