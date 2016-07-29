//
//  CardCluster.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/22/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class CardCluster: UIView
{   
    @IBOutlet private var contentView: UIView?
    @IBOutlet weak var baseCardView: CardView!
    @IBOutlet weak var cardViewA: CardView!
    @IBOutlet weak var cardViewB: CardView!
    @IBOutlet weak var cardViewC: CardView!
    
    private var cards: [Card] = []
    private var column: String = ""
    private var cardViews: [CardView] { return [ self.baseCardView, self.cardViewA, self.cardViewB, self.cardViewC ] }
    
//    func setWidthOfCardView()
//    {
//        let width = CardView.widthForScreenWidth()
//        let height = width / 3 * 4
//        
//        self.baseCardView.frame = CGRectMake(0, 0, width, height)
//    }
    
    func getCardViews() -> [CardView]
    {
        return self.cardViews
    }
    
    func rotateCardViews()
    {
        switch self.column
        {
        case first_column:
            self.cardViewA.transform = CGAffineTransformMakeRotation(6)
            self.cardViewB.transform = CGAffineTransformMakeRotation(0.5)
            self.cardViewC.transform = CGAffineTransformMakeRotation(0.05)
        case second_column:
            self.cardViewA.transform = CGAffineTransformMakeRotation(0.5)
            self.cardViewB.transform = CGAffineTransformMakeRotation(6)
            self.cardViewC.transform = CGAffineTransformMakeRotation(0.2)
        default:
            self.cardViewA.transform = CGAffineTransformMakeRotation(6.1)
            self.cardViewB.transform = CGAffineTransformMakeRotation(0.1)
            self.cardViewC.transform = CGAffineTransformMakeRotation(0.7)
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
//        self.populateCardViews()
        
        return arrayOfCards
    }
    
    func cardToJudge() -> Card
    {
        return self.cards.last! //sometimes this causes crash
    }
    
//    func placeCardJustDealtOnTop(cardView: CardView)
//    {
//        self.bringSubviewToFront(cardView)
//    }
    
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
            //why isn't this working?
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
        let content = NSBundle.mainBundle().loadNibNamed("CardCluster", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
