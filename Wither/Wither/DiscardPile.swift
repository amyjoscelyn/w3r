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
    
    func getViews() -> [CardView]
    {
        return self.cardViews
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
