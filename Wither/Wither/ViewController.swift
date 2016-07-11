//
//  ViewController.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/29/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

let winning_emoji = "👑"
let loss_emoji = "❌"
let war_emoji = "⚔"

let first_column = "1"
let second_column = "2"
let third_column = "3"

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
    
    @IBOutlet weak var swapCards1And2Button: UIButton!
    @IBOutlet weak var swapCards2And3Button: UIButton!
    @IBOutlet weak var swapCards1And3Button: UIButton!
    
    @IBOutlet weak var war1ResultLabel: UILabel!
    @IBOutlet weak var war2ResultLabel: UILabel!
    @IBOutlet weak var war3ResultLabel: UILabel!
    
    @IBOutlet weak var playerCardsRemainingInDeckLabel: UILabel!
    @IBOutlet weak var aiCardsRemainingInDeckLabel: UILabel!
    
    @IBOutlet weak var resolveWarGuideLabel: UILabel!
    @IBOutlet weak var skipWarButton: UIButton!
    
    
    var lastLocation: CGPoint = CGPointMake(0, 0)
    var deckOriginalCenter: CGPoint = CGPointMake(0, 0)
    
    let game = Game.init()
    
    var savePlayerCards: [Card] = []
    var saveAICards: [Card] = []
    var discardPlayerCards: [Card] = []
    var discardAICards: [Card] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.createGameSpace()
        self.resetGame()
        self.game.startGame()
    }
    
    func createGameSpace()
    {
        self.view.backgroundColor = UIColor.blackColor()
        
        self.customizeButton(self.playGameButton)
        self.customizeButton(self.settingsButton)
        self.customizeButton(self.swapCards1And2Button)
        self.customizeButton(self.swapCards2And3Button)
        self.customizeButton(self.swapCards1And3Button)
        self.customizeButton(self.skipWarButton)
        
        self.swapCards1And2Button.hidden = true
        self.swapCards2And3Button.hidden = true
        self.swapCards1And3Button.hidden = true
        
        self.skipWarButton.hidden = true
        self.resolveWarGuideLabel.hidden = true
        
        self.war1ResultLabel.hidden = true
        self.war2ResultLabel.hidden = true
        self.war3ResultLabel.hidden = true
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
    }
    
    func customizeButton(button: UIButton)
    {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.clipsToBounds = true
    }
    
    func panGestures()
    {
        let deckPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleDeckPanGesture))
        self.playerDeckView.addGestureRecognizer(deckPanGesture)
        self.playerDeckView.userInteractionEnabled = true
    }
    
    func handleDeckPanGesture(panGesture: UIPanGestureRecognizer)
    {
        if panGesture.state == UIGestureRecognizerState.Began
        {
            self.playerDeckView?.bringSubviewToFront(self.view)
            self.lastLocation = self.playerDeckView.center
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            let translation = panGesture.translationInView(self.view!)
            self.playerDeckView.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            //            print("chaaannnggiiinnngg.... \(lastLocation.y + translation.y)")
            
            if self.playerDeckView.center.y <= 450.0 && self.playerWar1View.hidden == true
            {
                //deal the hand, snap deck back to original center
                self.newRound()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            self.playerDeckView.center = self.deckOriginalCenter
        }
    }
    
    func resetGame()
    {
        self.aiDeckView.faceUp = false
        self.playerDeckView.faceUp = false
        
        self.clearAllWarCardViewsAndTempHands()
        
        self.aiDiscardView.card = nil;
        self.playerDiscardView.card = nil;
    }
    
    func clearAllWarCardViewsAndTempHands()
    {
        self.playerWar1View.card = nil
        self.playerWar2View.card = nil
        self.playerWar3View.card = nil
        self.aiWar1View.card = nil
        self.aiWar2View.card = nil
        self.aiWar3View.card = nil
        
        self.discardPlayerCards.removeAll()
        self.discardAICards.removeAll()
        self.savePlayerCards.removeAll()
        self.saveAICards.removeAll()
    }
    
    func newRound()
    {
        self.game.drawHands()
        self.cardsRemaining()
        
        if self.game.player.hand.count == 3 && self.game.aiPlayer.hand.count == 3
        {
            self.aiWar1View.card = self.game.aiPlayer.hand[0]
            self.aiWar2View.card = self.game.aiPlayer.hand[1]
            self.aiWar3View.card = self.game.aiPlayer.hand[2]
            self.playerWar1View.card = self.game.player.hand[0]
            self.playerWar2View.card = self.game.player.hand[1]
            self.playerWar3View.card = self.game.player.hand[2]
            
            self.game.aiPlayer.hand.removeAll()
            self.game.player.hand.removeAll()
            
            self.swapCards1And2Button.hidden = false
            self.swapCards2And3Button.hidden = false
            self.swapCards1And3Button.hidden = false
            
            self.playGameButton.setTitle("READY!", forState: UIControlState.Normal)
            self.playGameButton.enabled = true
            
            self.playerDeckView.userInteractionEnabled = false
            
            //***************************************
            //for testing purposes, this code can be commented out
//            self.aiWar1View.faceUp = false
//            self.aiWar2View.faceUp = false
//            self.aiWar3View.faceUp = false
            //***************************************
        }
    }
    
    func cardsRemaining()
    {
        self.playerCardsRemainingInDeckLabel.text = "Cards: \(self.game.player.deck.cards.count + self.game.player.hand.count)"
        self.aiCardsRemainingInDeckLabel.text = "Cards: \(self.game.aiPlayer.deck.cards.count + self.game.aiPlayer.hand.count)"
    }
    
    @IBAction func playGameButtonTapped(button: UIButton)
    {
        if button.titleLabel?.text == "READY!"
        {
            self.aiWar1View.faceUp = true
            self.aiWar2View.faceUp = true
            self.aiWar3View.faceUp = true
            
            self.judgeRound()
        }
        else if button.titleLabel?.text == "END ROUND"
        {
            self.endRound()
        }
    }
    
    func judgeRound()
    {
        let winnerOf1 = self.game.twoCardFaceOff(self.playerWar1View.card!, aiPlayerCard: self.aiWar1View.card!)
        let winnerOf2 = self.game.twoCardFaceOff(self.playerWar2View.card!, aiPlayerCard: self.aiWar2View.card!)
        let winnerOf3 = self.game.twoCardFaceOff(self.playerWar3View.card!, aiPlayerCard: self.aiWar3View.card!)
        
        print("\(winnerOf1) won 1, \(winnerOf2) won 2, \(winnerOf3) won 3")
        
        self.awardRoundWithResult(winnerOf1, cardResult2: winnerOf2, cardResult3: winnerOf3)
    }
    
    func awardRoundWithResult(cardResult1: String, cardResult2: String, cardResult3: String)
    {
        let results = [cardResult1, cardResult2, cardResult3]
        let resultLabels = [self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel]
        
        for i in 0..<results.count
        {
            let result = results[i]
            
            switch result
            {
            case "Player":
                resultLabels[i].text = winning_emoji
            case "AI":
                resultLabels[i].text = loss_emoji
            default:
                resultLabels[i].text = war_emoji
            }
        }
        
        self.war1ResultLabel.hidden = false
        self.war2ResultLabel.hidden = false
        self.war3ResultLabel.hidden = false
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.roundSpoils()
    }
    
    func roundSpoils()
    {
        self.swapCards1And2Button.hidden = true
        self.swapCards2And3Button.hidden = true
        self.swapCards1And3Button.hidden = true
        
        let resultsArray = [self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel]
        
        var winCount = 0
        var lossCount = 0
        var warCount = 0
        
        for result in resultsArray
        {
            if result.text == winning_emoji
            {
                winCount += 1
            }
            else if result.text == loss_emoji
            {
                lossCount += 1
            }
            else if result.text == war_emoji
            {
                warCount += 1
            }
        }
        
        print("crowns: \(winCount), X's: \(lossCount), swords: \(warCount)")
        
        var column = ""
        
        if winCount == 3
        {
            self.savePlayerCards.append(self.playerWar1View.card!)
            self.savePlayerCards.append(self.playerWar2View.card!)
            self.savePlayerCards.append(self.playerWar3View.card!)
            
            self.discardAICards.append(self.aiWar1View.card!)
            self.discardAICards.append(self.aiWar2View.card!)
            self.discardAICards.append(self.aiWar3View.card!)
            
            self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
            self.playGameButton.enabled = true
            
            //COMPLETE
        }
        if lossCount == 3
        {
            self.discardPlayerCards.append(self.playerWar1View.card!)
            self.discardPlayerCards.append(self.playerWar2View.card!)
            self.discardPlayerCards.append(self.playerWar3View.card!)
            
            self.saveAICards.append(self.aiWar1View.card!)
            self.saveAICards.append(self.aiWar2View.card!)
            self.saveAICards.append(self.aiWar3View.card!)
            
            self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
            self.playGameButton.enabled = true
            
            //COMPLETE
        }
        if winCount == 2
        {
            //player wins
            if lossCount == 1
            {
                column = self.columnOfResult(loss_emoji)
                
                if column == first_column
                {
                    self.savePlayerCards.append(self.playerWar2View.card!)
                    self.savePlayerCards.append(self.playerWar3View.card!)
                    
                    self.discardPlayerCards.append(self.playerWar1View.card!)
                }
                if column == second_column
                {
                    self.savePlayerCards.append(self.playerWar1View.card!)
                    self.savePlayerCards.append(self.playerWar3View.card!)
                    
                    self.discardPlayerCards.append(self.playerWar2View.card!)
                }
                if column == third_column
                {
                    self.savePlayerCards.append(self.playerWar1View.card!)
                    self.savePlayerCards.append(self.playerWar2View.card!)
                    
                    self.discardPlayerCards.append(self.playerWar3View.card!)
                }
                
                self.discardAICards.append(self.aiWar1View.card!)
                self.discardAICards.append(self.aiWar2View.card!)
                self.discardAICards.append(self.aiWar3View.card!)
                
                self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
                self.playGameButton.enabled = true
                
                //COMPLETE
            }
            if warCount == 1
            {
                column = self.columnOfResult(war_emoji)
                
                if column == first_column
                {
                    let warValue = self.aiWar1View.card?.cardValue
                    let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue!)
                    
                    self.savePlayerCards.append(self.playerWar2View.card!)
                    self.savePlayerCards.append(self.playerWar3View.card!)
                    
                    if willResolveWar
                    {
                        self.war1ResultLabel.backgroundColor = UIColor.greenColor()
                        //this means the war will be played out
                        //and should be resolved right here
                        //if resolved right here, I can add that extra card here
                        
                        //make the background label green for the sword, indicating you must tap it in order to resolve the war
                        //upon tappage, a war method will run, and at the end of that method this judge() will be called again
                    }
                    else
                    {
                        self.savePlayerCards.append(self.playerWar1View.card!)
                        
                        self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
                        self.playGameButton.enabled = true
                        
                        //COMPLETE
                    }
                }
                if column == second_column
                {
                    let warValue = self.aiWar2View.card?.cardValue
                    let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue!)
                    
                    self.savePlayerCards.append(self.playerWar1View.card!)
                    self.savePlayerCards.append(self.playerWar3View.card!)
                    
                    if willResolveWar
                    {
                        self.war2ResultLabel.backgroundColor = UIColor.greenColor()
                        //this means the war will be played out
                    }
                    else
                    {
                        self.savePlayerCards.append(self.playerWar2View.card!)
                        
                        self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
                        self.playGameButton.enabled = true
                        
                        //COMPLETE
                    }
                }
                if column == third_column
                {
                    let warValue = self.aiWar3View.card?.cardValue
                    let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue!)
                    
                    self.savePlayerCards.append(self.playerWar1View.card!)
                    self.savePlayerCards.append(self.playerWar2View.card!)
                    
                    if willResolveWar
                    {
                        self.war3ResultLabel.backgroundColor = UIColor.greenColor()
                        //this means the war will be played out
                    }
                    else
                    {
                        self.savePlayerCards.append(self.playerWar3View.card!)
                        
                        self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
                        self.playGameButton.enabled = true
                        
                        //COMPLETE
                    }
                }
                self.discardAICards.append(self.aiWar1View.card!)
                self.discardAICards.append(self.aiWar2View.card!)
                self.discardAICards.append(self.aiWar3View.card!)
            }
        }
        if lossCount == 2
        {
            //player loses
            if winCount == 1
            {
                column = self.columnOfResult(loss_emoji)
                
                if column == first_column
                {
                    self.saveAICards.append(self.aiWar2View.card!)
                    self.saveAICards.append(self.aiWar3View.card!)
                    
                    self.discardAICards.append(self.aiWar1View.card!)
                }
                else if column == second_column
                {
                    self.saveAICards.append(self.aiWar1View.card!)
                    self.saveAICards.append(self.aiWar3View.card!)
                    
                    self.discardAICards.append(self.aiWar2View.card!)
                }
                else if column == third_column
                {
                    self.saveAICards.append(self.aiWar1View.card!)
                    self.saveAICards.append(self.aiWar2View.card!)
                    
                    self.discardAICards.append(self.aiWar3View.card!)
                }
                self.discardPlayerCards.append(self.playerWar1View.card!)
                self.discardPlayerCards.append(self.playerWar2View.card!)
                self.discardPlayerCards.append(self.playerWar3View.card!)
                
                self.playGameButton.setTitle("END ROUND", forState: UIControlState.Normal)
                self.playGameButton.enabled = true
                
                //COMPLETE
            }
            if warCount == 1
            {
                self.skipWarButton.hidden = false
                self.resolveWarGuideLabel.hidden = false
                
                column = self.columnOfResult(war_emoji)
                
                let warTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleWarTapGesture))
                
                if column == first_column
                {
                    self.war1ResultLabel.backgroundColor = UIColor.greenColor()
                    
                    self.war1ResultLabel.addGestureRecognizer(warTapGesture)
                    self.war1ResultLabel.userInteractionEnabled = true
                }
                if column == second_column
                {
                    self.war2ResultLabel.backgroundColor = UIColor.greenColor()
                    
                    self.war2ResultLabel.addGestureRecognizer(warTapGesture)
                    self.war2ResultLabel.userInteractionEnabled = true
                }
                if column == third_column
                {
                    self.war3ResultLabel.backgroundColor = UIColor.greenColor()
                    
                    self.war3ResultLabel.addGestureRecognizer(warTapGesture)
                    self.war3ResultLabel.userInteractionEnabled = true
                }
                
                //player decides whether to press the war--maybe with a tap of the main button?  No, another button should show up for now, asking if you specifically want to play the war for that column
                //if no, AI saves that card
                //if yes, resolve the war.  Player still loses card, but AI might lose theirs too with another crown
            }
        }
        if warCount == 1
        {
            //resolve it.  at this point there's one win and one loss
        }
        if warCount >= 2
        {
            //do highest war
            //repeat this method
        }
    }
    
    func columnOfResult(result: String) -> String
    {
        var column = ""
        
        if self.war1ResultLabel.text == result
        {
            column = first_column
        }
        if self.war2ResultLabel.text == result
        {
            column = second_column
        }
        if self.war3ResultLabel.text == result
        {
            column = third_column
        }
        
        return column
    }
    
    func handleWarTapGesture()
    {
        print("WAR SHALL SOON COMMENCE!!!")
    }
    
    //call this when there is a clear winner and all wars have been dealt with
    func endRound()
    {
        self.war1ResultLabel.text = ""
        self.war2ResultLabel.text = ""
        self.war3ResultLabel.text = ""
        
        print("Player saves \(self.savePlayerCards.count) cards and discards \(self.discardPlayerCards.count) cards, AI saves \(self.saveAICards.count) cards and discards \(self.discardAICards.count) cards.")
        
        self.game.player.discard.appendContentsOf(self.discardPlayerCards)
        self.game.aiPlayer.discard.appendContentsOf(self.discardAICards)
        self.game.player.deck.cards.appendContentsOf(self.savePlayerCards)
        self.game.aiPlayer.deck.cards.appendContentsOf(self.saveAICards)
        
        self.clearAllWarCardViewsAndTempHands()
        self.cardsRemaining()
        
        if let lastAICardDiscarded = self.game.aiPlayer.discard.last
        {
            self.aiDiscardView.card = lastAICardDiscarded
        }
        
        if let lastPlayerCardDiscarded = self.game.player.discard.last
        {
            self.playerDiscardView.card = lastPlayerCardDiscarded
        }
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.playerDeckView.userInteractionEnabled = true
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject)
    {
        
    }
    
    @IBAction func swapCards1And2ButtonTapped(sender: AnyObject)
    {
        let card1 = self.playerWar1View.card
        self.playerWar1View.card = self.playerWar2View.card
        self.playerWar2View.card = card1
    }
    
    @IBAction func swapCards2And3ButtonTapped(sender: AnyObject)
    {
        let card2 = self.playerWar2View.card
        self.playerWar2View.card = self.playerWar3View.card
        self.playerWar3View.card = card2
    }
    
    @IBAction func swapCards1And3ButtonTapped(sender: AnyObject)
    {
        let card1 = self.playerWar1View.card
        self.playerWar1View.card = self.playerWar3View.card
        self.playerWar3View.card = card1
    }
    
    @IBAction func skipWarButtonTapped(sender: AnyObject)
    {
        print("WE'RE SKIPPING THIS WAR...")
        //the player chooses not to worry about the war.  They lose this card and the AI gets to keep it.  Maybe a property should be currentWarColumn and it has 1, 2, or 3... so if 1, save that card for AI...
    }
    
    func resolveWar(playerCard: Card, aiPlayerCard: Card) -> String
    {
        return self.game.twoCardFaceOff(playerCard, aiPlayerCard: aiPlayerCard)
    }
    
}
