//
//  CardView.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/30/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class CardView: UIView
{
    @IBOutlet private var contentView: UIView?
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var topValueLabel: UILabel!
    @IBOutlet weak var bottomValueLabel: UILabel!
    @IBOutlet weak var cardBackgroundImage: UIImageView!
    
    var faceUp: Bool = true
        {
        didSet
        {
            if self.faceUp
            {
                self.cardLabel.text = self.card?.cardLabel
            }
            else
            {
                self.cardBackgroundImage.image = UIImage.init(named: "CardBackA")
                self.cardLabel.text = self.backIcon
                self.topValueLabel.hidden = true
                self.bottomValueLabel.hidden = true
            }
        }
    }
    
    var backIcon: String = "✪" //card_back //do i need all this duplicate code?
        {
        didSet
        {
            if !self.faceUp
            {
                self.cardLabel.text = self.backIcon
            }
        }
    }
    
    var card: Card?
        {
        didSet
        {
            if let card = self.card
            {
                self.hidden = false
                if (self.faceUp)
                {
                    self.cardLabel.text = card.cardLabel
                    self.topValueLabel.text = card.rank
                    self.bottomValueLabel.text = card.rank
                }
                else
                {
                    self.cardLabel.text = self.backIcon
                }
            }
            else
            {
                self.hidden = true
                //this only works if they're explicitly set as nil
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
        let content = NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil).first as! UIView
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView = content
        self.addSubview(content)
    }
}
