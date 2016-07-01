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
                self.cardLabel.text = self.backIcon
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
