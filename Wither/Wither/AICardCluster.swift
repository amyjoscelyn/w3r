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
    private var player: String = ""
    private var column: String = ""
    private var cardViews: [CardView] { return [ self.baseCardView, self.cardViewA, self.cardViewB, self.cardViewC ] }
    
    func customizeCardViews()
    {
        for card in self.cardViews
        {
            card.layer.cornerRadius = 6
            card.layer.borderWidth = 3
            //        card.layer.borderColor =
            card.clipsToBounds = true
        }
    }
    
    func setPlayerAndColumn(player: String, column: String)
    {
        self.player = player
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
    
    //    func placeCardJustDealtOnTop(cardView: CardView)
    //    {
    //        self.bringSubviewToFront(cardView)
    //    }
    
    func populateCardViews()
    {
        if self.baseCardView.card == nil
        {
            self.baseCardView.card = self.cards.first
        }
        
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
            self.bringSubviewToFront(cardView)
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
