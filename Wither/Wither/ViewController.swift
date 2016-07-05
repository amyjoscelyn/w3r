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
        
        self.aiWar1View.card = nil
        self.aiWar2View.card = nil
        self.aiWar3View.card = nil
        
        self.playerWar1View.card = nil
        self.playerWar2View.card = nil
        self.playerWar3View.card = nil
        
        self.aiDiscardView.card = nil;
        self.playerDiscardView.card = nil;
        
        let deckTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.deckTapped))
        self.playerDeckView.addGestureRecognizer(deckTapGesture)

        self.playerDeckView.userInteractionEnabled = true
        
        self.game.deal()
    }

    func deckTapped()
    {
        print("Deck has been tapped!")
        self.newRound()
    }

    func newRound()
    {
        //decks are not getting instantiated
        self.game.round()
        
        if self.game.player.hand.count == 3
        {
            self.playerWar1View.card = self.game.player.hand[0]
            self.playerWar2View.card = self.game.player.hand[1]
            self.playerWar3View.card = self.game.player.hand[2]
            
            self.game.player.hand.removeAll()
        }
        
        if self.game.ai.hand.count == 3
        {
            self.aiWar1View.card = self.game.ai.hand[0]
            self.aiWar2View.card = self.game.ai.hand[1]
            self.aiWar3View.card = self.game.ai.hand[2]
            
            self.game.ai.hand.removeAll()
        }
    }

    @IBAction func playGameButtonTapped(sender: AnyObject)
    {
        
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject)
    {
        
    }
}

