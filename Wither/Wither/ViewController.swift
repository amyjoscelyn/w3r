//
//  ViewController.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/29/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var playerDeckView: CardView!
    @IBOutlet weak var playerDiscardView: CardView!
    @IBOutlet weak var playerHand1View: CardView!
    @IBOutlet weak var playerHand2View: CardView!
    @IBOutlet weak var playerHand3View: CardView!
    
    @IBOutlet weak var houseDeckView: CardView!
    @IBOutlet weak var houseDiscardView: CardView!
    @IBOutlet weak var houseHand1View: CardView!
    @IBOutlet weak var houseHand2View: CardView!
    @IBOutlet weak var houseHand3View: CardView!
    
    @IBOutlet weak var playerWar1View: CardView!
    @IBOutlet weak var playerWar2View: CardView!
    @IBOutlet weak var playerWar3View: CardView!
    
    @IBOutlet weak var houseWar1View: CardView!
    @IBOutlet weak var houseWar2View: CardView!
    @IBOutlet weak var houseWar3View: CardView!
    
    
    
    
    
    
    let game: Game = Game.init()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.houseDeckView.faceUp = false
        self.playerDeckView.faceUp = false
    }
}

