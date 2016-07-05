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
    
    var lastLocation: CGPoint = CGPointMake(0, 0)
    var deckOriginalCenter: CGPoint = CGPointMake(0, 0)
    
    let game: Game = Game.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.playGameButton.layer.cornerRadius = 8
        self.playGameButton.layer.borderWidth = 3
        self.playGameButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.playGameButton.clipsToBounds = true
        
        self.settingsButton.layer.cornerRadius = 8
        self.settingsButton.layer.borderWidth = 3
        self.settingsButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.settingsButton.clipsToBounds = true
        
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
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        
        self.game.deal()
    }
    
    func panGestures()
    {
        let deckPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleDeckPanGesture))
        self.playerDeckView.addGestureRecognizer(deckPanGesture)
        self.playerDeckView.userInteractionEnabled = true
        
        let war1PanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleWarPanGesture))
        self.playerWar1View.addGestureRecognizer(war1PanGesture)
        self.playerWar1View.userInteractionEnabled = true
    }
    
    func handleDeckPanGesture(panGesture: UIPanGestureRecognizer)
    {
        if panGesture.state == UIGestureRecognizerState.Began
        {
            print("pan gesture begun")
            self.playerDeckView?.bringSubviewToFront(self.view)
            self.lastLocation = self.playerDeckView.center
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            let translation = panGesture.translationInView(self.view!)
            self.playerDeckView.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            print("chaaannnggiiinnngg.... \(lastLocation.y + translation.y)")
            
            if self.playerDeckView.center.y <= 450.0 && self.playerWar1View.hidden == true
            {
                //deal the hand, snap deck back to original center
                self.newRound()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            print("pan gesture ended")
            self.playerDeckView.center = self.deckOriginalCenter
        }
        else
        {
            // or something when it's not moving
        }
    }
    
    func handleWarPanGesture(panGesture: UIPanGestureRecognizer)
    {
        if panGesture.state == UIGestureRecognizerState.Began
        {
            print("pan gesture begun")
            self.playerWar1View?.bringSubviewToFront(self.view)
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            let translation = panGesture.translationInView(self.view!)
            self.playerWar1View.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            print("chaaannnggiiinnngg.... \(lastLocation.y + translation.y)")
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            print("pan gesture ended")
        }
        else
        {
            // or something when it's not moving
        }
    }
    
    func newRound()
    {
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
            
            //***************************************
            //for testing purposes, this code can be commented out
            self.aiWar1View.faceUp = false
            self.aiWar2View.faceUp = false
            self.aiWar3View.faceUp = false
            //***************************************
        }
    }
    
    /*
     Next steps: more simple autolayout of views.
     Then put a pan gesture recognizer on a single view, adjusting its center point.
     Make sure it can be moved around.
     Play around with it.
     */
    
    @IBAction func playGameButtonTapped(sender: AnyObject)
    {
        //potentially disable this button until the player's hand is dealt (turn it on in newRound()
        
        //flip cards if they're not already
        self.aiWar1View.faceUp = true
        self.aiWar2View.faceUp = true
        self.aiWar3View.faceUp = true
        
        //if they're flipped (faceup = true), pit them against each other, determine the winners for each faceoff
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject)
    {
        
    }
}

