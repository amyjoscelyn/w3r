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
    
    @IBOutlet weak var aiDeckView: CardView!
    @IBOutlet weak var aiDiscardView: CardView!
    
    @IBOutlet weak var playerWar1View: CardView!
    @IBOutlet weak var playerWar2View: CardView!
    @IBOutlet weak var playerWar3View: CardView!
    
    @IBOutlet weak var aiWar1View: CardView!
    @IBOutlet weak var aiWar2View: CardView!
    @IBOutlet weak var aiWar3View: CardView!
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let game: Game = Game.init()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.aiDeckView.faceUp = false
        self.playerDeckView.faceUp = false
        
        self.game.deal()
    }
    
    @IBAction func playGameButtonTapped(sender: AnyObject)
    {
        
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject)
    {
        
    }
}

