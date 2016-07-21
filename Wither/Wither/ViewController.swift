//
//  ViewController.swift
//  Wither
//
//  Created by Amy Joscelyn on 6/29/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit
import QuartzCore //I imported this to rotate the cards a bit.  Is this how this works?

let winning_emoji = "👑"
let loss_emoji = "❌"
let war_emoji = "⚔"

let first_column = "1"
let second_column = "2"
let third_column = "3"

let player_string = "Player"
let ai_string = "AI"

let play_game_string = "BEGIN GAME"
let ready_string = "READY!"
let war_string = "WAR!"
let end_round_string = "END ROUND"
let game_over_string = "GAME OVER"

class ViewController: UIViewController
{
    var lastLocation: CGPoint = CGPointMake(0, 0)
    var deckOriginalCenter: CGPoint = CGPointMake(0, 0)
    
    @IBOutlet weak var playerDeckView: CardView!
    @IBOutlet weak var playerDiscardView: CardView!
    @IBOutlet weak var playerDiscardViewA: CardView!
    @IBOutlet weak var playerDiscardViewB: CardView!
    @IBOutlet weak var playerDiscardViewC: CardView!
    @IBOutlet weak var playerDiscardViewD: CardView!
    @IBOutlet weak var aiDeckView: CardView!
    @IBOutlet weak var aiDiscardView: CardView!
    @IBOutlet weak var aiDiscardViewA: CardView!
    @IBOutlet weak var aiDiscardViewB: CardView!
    @IBOutlet weak var aiDiscardViewC: CardView!
    @IBOutlet weak var aiDiscardViewD: CardView!
    
    var savePlayerCards: [Card] = []
    var saveAICards: [Card] = []
    var discardPlayerCards: [Card] = []
    var discardAICards: [Card] = []
    
    @IBOutlet weak var playerWar1View: CardView!
    @IBOutlet weak var playerWar2View: CardView!
    @IBOutlet weak var playerWar3View: CardView!
    @IBOutlet weak var aiWar1View: CardView!
    @IBOutlet weak var aiWar2View: CardView!
    @IBOutlet weak var aiWar3View: CardView!
    @IBOutlet weak var playerWar1AView: CardView!
    @IBOutlet weak var playerWar2AView: CardView!
    @IBOutlet weak var playerWar3AView: CardView!
    @IBOutlet weak var aiWar1AView: CardView!
    @IBOutlet weak var aiWar2AView: CardView!
    @IBOutlet weak var aiWar3AView: CardView!
    @IBOutlet weak var playerWar1BView: CardView!
    @IBOutlet weak var playerWar2BView: CardView!
    @IBOutlet weak var playerWar3BView: CardView!
    @IBOutlet weak var aiWar1BView: CardView!
    @IBOutlet weak var aiWar2BView: CardView!
    @IBOutlet weak var aiWar3BView: CardView!
    @IBOutlet weak var playerWar1CView: CardView!
    @IBOutlet weak var playerWar2CView: CardView!
    @IBOutlet weak var playerWar3CView: CardView!
    @IBOutlet weak var aiWar1CView: CardView!
    @IBOutlet weak var aiWar2CView: CardView!
    @IBOutlet weak var aiWar3CView: CardView!
    
    var cardViews: [CardView] = []
    
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
    
    var columnOfWar: String = ""
    var isWar1 = false
    var isWar2 = false
    var isWar3 = false
    var roundHasBegun = false
    var warSkippedByPlayer = false
    
    let game = Game.init()
    
    override func viewDidLoad()
    {
//        print("#1 (viewDidLoad)")
        super.viewDidLoad()
        
        self.cardViewArray()
        self.createGameSpace()
        self.startGame()
//        self.prepButtonWithTitle(play_game_string)
    }
    
    func cardViewArray()
    {
        self.cardViews = [
            self.aiDeckView,
            self.playerDeckView,
            self.aiDiscardView,
            self.aiDiscardViewA,
            self.aiDiscardViewB,
            self.aiDiscardViewC,
            self.aiDiscardViewD,
            self.playerDiscardView,
            self.playerDiscardViewA,
            self.playerDiscardViewB,
            self.playerDiscardViewC,
            self.playerDiscardViewD,
            self.aiWar1View,
            self.aiWar1AView,
            self.aiWar1BView,
            self.aiWar1CView,
            self.aiWar2View,
            self.aiWar2AView,
            self.aiWar2BView,
            self.aiWar2CView,
            self.aiWar3View,
            self.aiWar3AView,
            self.aiWar3BView,
            self.aiWar3CView,
            self.playerWar1View,
            self.playerWar1AView,
            self.playerWar1BView,
            self.playerWar1CView,
            self.playerWar2View,
            self.playerWar2AView,
            self.playerWar2BView,
            self.playerWar2CView,
            self.playerWar3View,
            self.playerWar3AView,
            self.playerWar3BView,
            self.playerWar3CView ]
    }
    
    func createGameSpace()
    {
        //THIS SHOULD ONLY GET CALLED ONCE
//        print("#2 (createGameSpace)")
        self.view.backgroundColor = UIColor.blackColor()
        
        self.customizeButton(self.playGameButton)
        self.customizeButton(self.settingsButton)
        self.customizeButton(self.swapCards1And2Button)
        self.customizeButton(self.swapCards2And3Button)
        self.customizeButton(self.swapCards1And3Button)
        self.customizeButton(self.skipWarButton)
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.rotateCardViews()
        
        for cardView in self.cardViews
        {
            self.customizeCardView(cardView)
        }
    }
    
    func customizeButton(button: UIButton)
    {
        //        print("#3 (customizeButton)")
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.clipsToBounds = true
    }
    
    func panGestures()
    {
        //        print("#4 (panGestures)")
        let deckPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleDeckPanGesture))
        self.playerDeckView.addGestureRecognizer(deckPanGesture)
        self.playerDeckView.userInteractionEnabled = true
    }
    
    func rotateCardViews()
    {
        self.playerDiscardView.transform = CGAffineTransformMakeRotation(0.05)
        self.playerDiscardViewA.transform = CGAffineTransformMakeRotation(5.4)
        self.playerDiscardViewB.transform = CGAffineTransformMakeRotation(2)
        self.playerDiscardViewC.transform = CGAffineTransformMakeRotation(0.9)
        self.playerDiscardViewD.transform = CGAffineTransformMakeRotation(0)
        
        self.aiDiscardView.transform = CGAffineTransformMakeRotation(0)
        self.aiDiscardViewA.transform = CGAffineTransformMakeRotation(4.3)
        self.aiDiscardViewB.transform = CGAffineTransformMakeRotation(0.9)
        self.aiDiscardViewC.transform = CGAffineTransformMakeRotation(6.1)
        self.playerDiscardViewD.transform = CGAffineTransformMakeRotation(0.5)
        
        self.playerWar1AView.transform = CGAffineTransformMakeRotation(6)
        self.playerWar1BView.transform = CGAffineTransformMakeRotation(0.5)
        self.playerWar1CView.transform = CGAffineTransformMakeRotation(0.05)
        
        self.playerWar2AView.transform = CGAffineTransformMakeRotation(0.5)
        self.playerWar2BView.transform = CGAffineTransformMakeRotation(6)
        self.playerWar2CView.transform = CGAffineTransformMakeRotation(0.2)
        
        self.playerWar3AView.transform = CGAffineTransformMakeRotation(6.1)
        self.playerWar3BView.transform = CGAffineTransformMakeRotation(0.1)
        self.playerWar3CView.transform = CGAffineTransformMakeRotation(0.7)
        
        self.aiWar1AView.transform = CGAffineTransformMakeRotation(6.2)
        self.aiWar1BView.transform = CGAffineTransformMakeRotation(0.3)
        self.aiWar1CView.transform = CGAffineTransformMakeRotation(0.04)
        
        self.aiWar2AView.transform = CGAffineTransformMakeRotation(0.2)
        self.aiWar2BView.transform = CGAffineTransformMakeRotation(6.1)
        self.aiWar2CView.transform = CGAffineTransformMakeRotation(6.23)
        
        self.aiWar3AView.transform = CGAffineTransformMakeRotation(0.5)
        self.aiWar3BView.transform = CGAffineTransformMakeRotation(6.05)
        self.aiWar3CView.transform = CGAffineTransformMakeRotation(0)
        
        // 0.5 points at 1:00
        // 1-top points at 2:00, maybe 2:30
        // 3 makes it upside down, top pointing at 5:00, maybe 4:30
        // 5 points just after 9:00, like 9:30
        // 6 - points at 11:00
        //I can probably make these magic numbers constants--left, right, topleft... or maybe SW, SE, N, NNW...
    }
    
    func customizeCardView(card: CardView)
    {
        card.layer.cornerRadius = 6
        card.layer.borderWidth = 3
        //        card.layer.borderColor =
        card.clipsToBounds = true
    }
    
    
                //Everything above here is game setup.
    
    
    func startGame()
    {
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.resetGame()
        self.game.startGame()
    }
    
    func resetGame()
    {
        //        print("#6 (resetGame)")
        self.aiDeckView.faceUp = false
        self.playerDeckView.faceUp = false
        
        self.clearAllWarCardViewsAndTempHands()
        
        self.war1ResultLabel.hidden = true
        self.war2ResultLabel.hidden = true
        self.war3ResultLabel.hidden = true
        self.resolveWarGuideLabel.hidden = true
        self.skipWarButton.hidden = true
        self.swapCards1And2Button.hidden = true
        self.swapCards2And3Button.hidden = true
        self.swapCards1And3Button.hidden = true
        
        self.aiDiscardView.card = nil;
        self.aiDiscardViewA.card = nil;
        self.aiDiscardViewB.card = nil;
        self.aiDiscardViewC.card = nil;
        self.aiDiscardViewD.card = nil;
        self.playerDiscardView.card = nil;
        self.playerDiscardViewA.card = nil;
        self.playerDiscardViewB.card = nil;
        self.playerDiscardViewC.card = nil;
        self.playerDiscardViewD.card = nil;
    }
    
    func clearAllWarCardViewsAndTempHands()
    {
        //        print("#7 (clearAllWarCardViewsAndTempHands)")
        self.playerWar1View.card = nil
        self.playerWar2View.card = nil
        self.playerWar3View.card = nil
        self.aiWar1View.card = nil
        self.aiWar2View.card = nil
        self.aiWar3View.card = nil
        
        self.playerWar1AView.card = nil
        self.playerWar2AView.card = nil
        self.playerWar3AView.card = nil
        self.aiWar1AView.card = nil
        self.aiWar2AView.card = nil
        self.aiWar3AView.card = nil
        
        self.playerWar1BView.card = nil
        self.playerWar2BView.card = nil
        self.playerWar3BView.card = nil
        self.aiWar1BView.card = nil
        self.aiWar2BView.card = nil
        self.aiWar3BView.card = nil
        
        self.playerWar1CView.card = nil
        self.playerWar2CView.card = nil
        self.playerWar3CView.card = nil
        self.aiWar1CView.card = nil
        self.aiWar2CView.card = nil
        self.aiWar3CView.card = nil
        
        self.discardPlayerCards.removeAll()
        self.discardAICards.removeAll()
        self.savePlayerCards.removeAll()
        self.saveAICards.removeAll()
        
        self.game.warIsDone()
    }
    
    
                //Above here is how to start a new game.
    
    
    func handleDeckPanGesture(panGesture: UIPanGestureRecognizer)
    {
//        print("#5 (handlePanGesture)")
        if panGesture.state == UIGestureRecognizerState.Began
        {
            self.playerDeckView?.bringSubviewToFront(self.view) //is this right???
            self.lastLocation = self.playerDeckView.center
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            let translation = panGesture.translationInView(self.view!)
            self.playerDeckView.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            
            if self.playerDeckView.center.y <= 450.0 && self.playerWar2View.hidden == true && self.roundHasBegun == false
            {
                self.newRound()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            self.playerDeckView.center = self.deckOriginalCenter
        }
    }
    
    func newRound()
    {
//        print("#8 (newRound)")
        self.roundHasBegun = true
        self.game.drawHands()
        self.cardsRemaining()
        
        if self.game.player.hand.count == 3 && self.game.aiPlayer.hand.count == 3
        {
            self.populateHandWithCards()
            
            self.swapCards1And2Button.hidden = false
            self.swapCards2And3Button.hidden = false
            self.swapCards1And3Button.hidden = false
            
            self.prepButtonWithTitle(ready_string)
            
            self.playerDeckView.userInteractionEnabled = false
            
            //***************************************
            //for testing purposes, this code can be commented out
            self.aiWar1View.faceUp = false
            self.aiWar2View.faceUp = false
            self.aiWar3View.faceUp = false
            //***************************************
        }
        else if self.game.player.hand.count > 0 || self.game.aiPlayer.hand.count > 0
        {
            //just draw a single card--fight down to the last
            self.populateHandWithSingleCard()
            
            self.prepButtonWithTitle(ready_string)
        }
        else
        {
            //game is over!!
            print("game is over :(")
            print("newRound deemed this game OVER!!!!!!!!!")
            self.prepButtonWithTitle(game_over_string)
        }
    }
    
    func cardsRemaining()
    {
        //        print("#11 (cardsRemaining)")
        let playerDeckCount = self.game.player.deck.cards.count
        let aiDeckCount = self.game.aiPlayer.deck.cards.count
        
        self.playerCardsRemainingInDeckLabel.text = "Cards: \(playerDeckCount/* + self.game.player.hand.count*/)"
        self.aiCardsRemainingInDeckLabel.text = "Cards: \(aiDeckCount/* + self.game.aiPlayer.hand.count*/)"
        
        if playerDeckCount > 0
        {
            self.playerDeckView.hidden = false
        }
        else
        {
            self.playerDeckView.hidden = true
        }
        if aiDeckCount > 0
        {
            self.aiDeckView.hidden = false
        }
        else
        {
            self.aiDeckView.hidden = true
        }
        
        //        let playerDeckAndHandCount = playerDeckCount + self.game.player.hand.count
        //        let aiDeckAndHandCount = aiDeckCount + self.game.aiPlayer.hand.count
        //
        //        if playerDeckAndHandCount == 0 || aiDeckAndHandCount == 0
        //        {
        //            print("cardsRemaining deemed this game OVER!!!!!!!")
        //            self.prepButtonWithTitle(game_over_string)
        //        }
    }
    
    func populateHandWithCards()
    {
//        print("#9 (populateHandWithCards)")
        self.aiWar1View.card = self.game.aiPlayer.hand[0]
        self.aiWar2View.card = self.game.aiPlayer.hand[1]
        self.aiWar3View.card = self.game.aiPlayer.hand[2]
        self.playerWar1View.card = self.game.player.hand[0]
        self.playerWar2View.card = self.game.player.hand[1]
        self.playerWar3View.card = self.game.player.hand[2]
        
        self.game.aiPlayer.hand.removeAll()
        self.game.player.hand.removeAll()
    }
    
    func prepButtonWithTitle(title: String)
    {
        //        print("#27 (prepButtonWithTitle)")
        self.playGameButton.setTitle(title, forState: UIControlState.Normal)
        self.playGameButton.enabled = true
    }
    
    func populateHandWithSingleCard()
    {
        //        print("#10 (populateHandWithSingleCard)")
        print("[populateHandWithSingleCard] player has \(self.game.player.deck.cards.count) cards in deck, AI has \(self.game.aiPlayer.deck.cards.count) cards")
        self.aiWar2View.card = self.game.aiPlayer.hand[0]
        self.playerWar2View.card = self.game.player.hand[0] //maybe new cardView here instead?
        
        self.aiWar1View.card = nil
        self.aiWar3View.card = nil
        self.playerWar1View.card = nil //set 2 as nil... or they should already be nil, because of the endRound, right?
        self.playerWar3View.card = nil
        
        self.game.aiPlayer.hand.removeAll()
        self.game.player.hand.removeAll()
    }
    
    
                //Above handles a new round
    
    
    @IBAction func playGameButtonTapped(button: UIButton)
    {
        let label = button.titleLabel?.text
//        print("#12 (playGameButtonTapped)")
        if label == play_game_string
        {
            self.startGame()
        }
        else if label == ready_string
        {
            self.aiWar1View.faceUp = true
            self.aiWar2View.faceUp = true
            self.aiWar3View.faceUp = true
            
            self.judgeRound()
        }
        else if label == war_string
        {
            self.hideWarLabel(self.columnOfWar)
            self.playWarInColumn(self.columnOfWar)
        }
        else if label == end_round_string
        {
            self.endRound() //√
        }
        else if label == game_over_string
        {
            self.endGame()
        }
    }
    
    
                //Above is the pivot point of the game, methodically going through the different sections of the game
    
    
    func judgeRound()
    {
        //        print("#14 (judgeRound)")
        if self.playerWar1View.card != nil
        {
            let cardsToJudge1 = self.cardsToJudge(first_column)
            let cardsToJudge2 = self.cardsToJudge(second_column)
            let cardsToJudge3 = self.cardsToJudge(third_column)
            
            let winnerOf1 = self.resolveWar(cardsToJudge1)
            let winnerOf2 = self.resolveWar(cardsToJudge2)
            let winnerOf3 = self.resolveWar(cardsToJudge3)
            
//            print("\(winnerOf1) won 1, \(winnerOf2) won 2, \(winnerOf3) won 3")
            
            self.awardRoundWithResult(winnerOf1, cardResult2: winnerOf2, cardResult3: winnerOf3)
        }
        else
        {
            //there is only one card up, #2
            
            let cardsToJudge = self.cardsToJudge(second_column)
            let winner = self.resolveWar(cardsToJudge)
            
            print("\(winner) won!!")
            
            self.awardFinalRoundWithResult(winner)
        }
    }
    
    func cardsToJudge(column: String) -> [Card]
    {
        var playerCard: Card = Card.init(suit: "X", rank: "0")
        var aiCard: Card = Card.init(suit: "X", rank: "0")
        
        switch column
        {
        case first_column:
            if !isWar1
            {
                playerCard = self.playerWar1View.card!
                aiCard = self.aiWar1View.card!
            }
            else
            {
                let aViewZIndex = self.view.subviews.indexOf(self.playerWar1AView)
                let bViewZIndex = self.view.subviews.indexOf(self.playerWar1BView)
                let cViewZIndex = self.view.subviews.indexOf(self.playerWar1CView)
                
                if aViewZIndex > bViewZIndex
                {
                    playerCard = self.playerWar1AView.card!
                    aiCard = self.aiWar1AView.card!
                }
                else if bViewZIndex > cViewZIndex
                {
                    playerCard = self.playerWar1BView.card!
                    aiCard = self.aiWar1BView.card!
                }
                else
                {
                    playerCard = self.playerWar1CView.card!
                    aiCard = self.aiWar1CView.card!
                }
            }
        case second_column:
            if !isWar2
            {
                playerCard = self.playerWar1View.card!
                aiCard = self.aiWar2View.card!
            }
            else
            {
                let aViewZIndex = self.view.subviews.indexOf(self.playerWar2AView)
                let bViewZIndex = self.view.subviews.indexOf(self.playerWar2BView)
                let cViewZIndex = self.view.subviews.indexOf(self.playerWar2CView)
                
                if aViewZIndex > bViewZIndex
                {
                    playerCard = self.playerWar2AView.card!
                    aiCard = self.aiWar2AView.card!
                }
                else if bViewZIndex > cViewZIndex
                {
                    playerCard = self.playerWar2BView.card!
                    aiCard = self.aiWar2BView.card!
                }
                else
                {
                    playerCard = self.playerWar2CView.card!
                    aiCard = self.aiWar2CView.card!
                }
            }
        default:
            if !isWar3
            {
                playerCard = self.playerWar1View.card!
                aiCard = self.aiWar3View.card!
            }
            else
            {
                let aViewZIndex = self.view.subviews.indexOf(self.playerWar3AView)
                let bViewZIndex = self.view.subviews.indexOf(self.playerWar3BView)
                let cViewZIndex = self.view.subviews.indexOf(self.playerWar3CView)
                
                if aViewZIndex > bViewZIndex
                {
                    playerCard = self.playerWar3AView.card!
                    aiCard = self.aiWar3AView.card!
                }
                else if bViewZIndex > cViewZIndex
                {
                    playerCard = self.playerWar3BView.card!
                    aiCard = self.aiWar3BView.card!
                }
                else
                {
                    playerCard = self.playerWar3CView.card!
                    aiCard = self.aiWar3CView.card!
                }
            }
        }
        return [ playerCard, aiCard ]
    }
    
    func resolveWar(cards: [Card]) -> String
    {
        let playerCard = cards.first!
        let aiPlayerCard = cards.last!
        
        return self.game.twoCardFaceOff(playerCard, aiPlayerCard: aiPlayerCard)
    }
    
    func awardRoundWithResult(cardResult1: String, cardResult2: String, cardResult3: String)
    {
        //        print("#16 (awardRoundWithResult)")
        let results = [cardResult1, cardResult2, cardResult3]
        let resultLabels = [self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel]
        
        for i in 0..<results.count
        {
            let result = results[i]
            
            switch result
            {
            case player_string:
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
        
        self.prepButtonWithTitle("")
        
        self.roundSpoils()
    }
    
    func roundSpoils()
    {
        //        print("#18 (roundSpoils)")
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
            print("case #1 (player wins all!)")
            self.saveAllCards(player_string)
            self.discardAllCards(ai_string)
            
            self.prepButtonWithTitle(end_round_string)
        }
        else if lossCount == 3
        {
            print("case #2 (AI wins all)")
            self.discardAllCards(player_string)
            self.saveAllCards(ai_string)
            
            self.prepButtonWithTitle(end_round_string)
        }
        else if winCount == 2
        {
            print("case #3 (player wins two)")
            if lossCount == 1
            {
                column = self.columnOfResult(loss_emoji)
                
                switch column
                {
                case first_column:
                    self.discardSingleCard(player_string, column: first_column)
                    self.saveSingleCard(player_string, column: second_column)
                    self.saveSingleCard(player_string, column: third_column)
                case second_column:
                    self.saveSingleCard(player_string, column: first_column)
                    self.discardSingleCard(player_string, column: second_column)
                    self.saveSingleCard(player_string, column: third_column)
                default:
                    self.saveSingleCard(player_string, column: first_column)
                    self.saveSingleCard(player_string, column: second_column)
                    self.discardSingleCard(player_string, column: third_column)
                }
                
                self.discardAllCards(ai_string)
                
                self.prepButtonWithTitle(end_round_string)
            }
            else //war //DOES THIS GET CALLED WHEN WAR IS TIED?
            {
                column = self.columnOfResult(war_emoji)
                let warValue = self.cardValueOfWar(column) //only good for initial wars...
                print("AI has lost, but gets to pass on the war.")
                let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue)
                
                if willResolveWar
                {
                    self.columnOfWar = column
                    self.prepForWar(column)
                }
                else
                {
                    print("AI PASSES ON WAR.")
                    
                    self.saveAllCards(player_string)
                    
                    switch column
                    {
                    case first_column:
                        self.saveSingleCard(ai_string, column: first_column)
                        self.discardSingleCard(ai_string, column: second_column)
                        self.discardSingleCard(ai_string, column: third_column)
                    case second_column:
                        self.discardSingleCard(ai_string, column: first_column)
                        self.saveSingleCard(ai_string, column: second_column)
                        self.discardSingleCard(ai_string, column: third_column)
                    default:
                        self.discardSingleCard(ai_string, column: first_column)
                        self.discardSingleCard(ai_string, column: second_column)
                        self.saveSingleCard(ai_string, column: third_column)
                    }
                    
                    self.prepButtonWithTitle(end_round_string)
                }
            }
        }
        else if lossCount == 2
        {
            print("case #4 (player loses 2)")
            if winCount == 1
            {
                column = self.columnOfResult(winning_emoji)
                
                switch column
                {
                case first_column:
                    self.discardSingleCard(ai_string, column: first_column)
                    self.saveSingleCard(ai_string, column: second_column)
                    self.saveSingleCard(ai_string, column: third_column)
                case second_column:
                    self.saveSingleCard(ai_string, column: first_column)
                    self.discardSingleCard(ai_string, column: second_column)
                    self.saveSingleCard(ai_string, column: third_column)
                default:
                    self.saveSingleCard(ai_string, column: first_column)
                    self.saveSingleCard(ai_string, column: second_column)
                    self.discardSingleCard(ai_string, column: third_column)
                }
                
                self.discardAllCards(player_string)
                
                self.prepButtonWithTitle(end_round_string)
            }
            else if warSkippedByPlayer
            {
                print("war has been skipped!--in method")
                
                self.saveAllCards(ai_string)
                
                column = self.columnOfResult(war_emoji)
                
                switch column
                {
                case first_column:
                    self.saveSingleCard(player_string, column: first_column)
                    self.discardSingleCard(player_string, column: second_column)
                    self.discardSingleCard(player_string, column: third_column)
                case second_column:
                    self.discardSingleCard(player_string, column: first_column)
                    self.saveSingleCard(player_string, column: second_column)
                    self.discardSingleCard(player_string, column: third_column)
                default:
                    self.discardSingleCard(player_string, column: first_column)
                    self.discardSingleCard(player_string, column: second_column)
                    self.saveSingleCard(player_string, column: third_column)
                }
//                self.endRound() //why is this called here, and not in the button???
                self.prepButtonWithTitle(end_round_string)
            }
            else //war
            {
                print("playing the war now...")
                column = self.columnOfResult(war_emoji)
                
                self.skipWarButton.hidden = false
                self.resolveWarGuideLabel.hidden = false
                
                self.prepForWar(column)
            }
        }
        else //there is at least one war that needs to be resolved in order to determine a clear winner
        {
//            print("case #5 (no clear winner... yet)")
            if warCount == 1
            {
                column = self.columnOfResult(war_emoji)
                self.prepForWar(column)
            }
            else if warCount == 2
            {
                if winCount == 1
                {
                    column = self.columnOfResult(winning_emoji)
                }
                else
                {
                    column = self.columnOfResult(loss_emoji)
                }
                
                var firstWar = 0
                var secondWar = 0
                
                switch column
                {
                case first_column:
                    //wars are 2 and 3
                    firstWar = self.cardValueOfWar(second_column)
                    secondWar = self.cardValueOfWar(third_column)
                    
                    if firstWar > secondWar //>=?
                    {
                        self.prepForWar(second_column)
                    }
                    else
                    {
                        self.prepForWar(third_column)
                    }
                case second_column:
                    //wars are 1 and 3
                    firstWar = self.cardValueOfWar(first_column)
                    secondWar = self.cardValueOfWar(third_column)
                    
                    if firstWar > secondWar //>=?
                    {
                        self.prepForWar(first_column)
                    }
                    else
                    {
                        self.prepForWar(third_column)
                    }
                default:
                    //wars are 1 and 2
                    firstWar = self.cardValueOfWar(first_column)
                    secondWar = self.cardValueOfWar(second_column)
                    
                    if firstWar > secondWar //>=?
                    {
                        self.prepForWar(first_column)
                    }
                    else
                    {
                        self.prepForWar(second_column)
                    }
                }
            }
            else //there are three wars!  how rare :)
            {
                let firstWar = self.cardValueOfWar(first_column)
                let secondWar = self.cardValueOfWar(second_column)
                let thirdWar = self.cardValueOfWar(third_column)
                
                let warValues = [ firstWar, secondWar, thirdWar ]
                
                if warValues.maxElement() == firstWar
                {
                    self.prepForWar(first_column)
                }
                else if warValues.maxElement() == secondWar
                {
                    self.prepForWar(second_column)
                }
                else
                {
                    self.prepForWar(third_column)
                }
            }
        }
    }
    
    func saveAllCards(player: String)
    {
        //        print("#21 (saveAllCards)")
        var cardsToSave: [Card] = []
        
        if player == player_string
        {
            cardsToSave = [ self.playerWar1View.card!, self.playerWar2View.card!, self.playerWar3View.card! ]
            cardsToSave.appendContentsOf(self.game.player.warCards)
            
            self.savePlayerCards.appendContentsOf(cardsToSave)
        }
        else if player == ai_string
        {
            cardsToSave = [ self.aiWar1View.card!, self.aiWar2View.card!, self.aiWar3View.card! ]
            cardsToSave.appendContentsOf(self.game.aiPlayer.warCards)
            
            self.saveAICards.appendContentsOf(cardsToSave)
        }
    }
    
    func discardAllCards(player: String)
    {
        //        print("#22 (discardAllCards)")
        var cardsToDiscard: [Card] = []
        
        if player == player_string
        {
            cardsToDiscard = [ self.playerWar1View.card!, self.playerWar2View.card!, self.playerWar3View.card! ]
            cardsToDiscard.appendContentsOf(self.game.player.warCards)
            
            self.discardPlayerCards.appendContentsOf(cardsToDiscard)
        }
        else if player == ai_string
        {
            cardsToDiscard = [ self.aiWar1View.card!, self.aiWar2View.card!, self.aiWar3View.card! ]
            cardsToDiscard.appendContentsOf(self.game.aiPlayer.warCards)
            
            self.discardAICards.appendContentsOf(cardsToDiscard)
        }
    }
    
    func columnOfResult(result: String) -> String
    {
        //        print("#20 (columnOfResult)")
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
    
    func saveSingleCard(player: String, column: String)
    {
        //        print("#23 (saveSingleCard)")
        if player == player_string
        {
            switch column
            {
            case first_column:
                self.savePlayerCards.append(self.playerWar1View.card!)
                
                if let warCard1A = self.playerWar1AView.card
                {
                    self.savePlayerCards.append(warCard1A)
                }
                if let warCard1B = self.playerWar1BView.card
                {
                    self.savePlayerCards.append(warCard1B)
                }
                if let warCard1C = self.playerWar1CView.card
                {
                    self.savePlayerCards.append(warCard1C)
                }
            case second_column:
                self.savePlayerCards.append(self.playerWar2View.card!)
                
                if let warCard2A = self.playerWar2AView.card
                {
                    self.savePlayerCards.append(warCard2A)
                }
                if let warCard2B = self.playerWar2BView.card
                {
                    self.savePlayerCards.append(warCard2B)
                }
                if let warCard2C = self.playerWar2CView.card
                {
                    self.savePlayerCards.append(warCard2C)
                }
            default:
                self.savePlayerCards.append(self.playerWar3View.card!)
                
                if let warCard3A = self.playerWar3AView.card
                {
                    self.savePlayerCards.append(warCard3A)
                }
                if let warCard3B = self.playerWar3BView.card
                {
                    self.savePlayerCards.append(warCard3B)
                }
                if let warCard3C = self.playerWar3CView.card
                {
                    self.savePlayerCards.append(warCard3C)
                }
            }
        }
        else if player == ai_string
        {
            switch column
            {
            case first_column:
                self.saveAICards.append(self.aiWar1View.card!)
                
                if let warCard1A = self.aiWar1AView.card
                {
                    self.saveAICards.append(warCard1A)
                }
                if let warCard1B = self.aiWar1BView.card
                {
                    self.saveAICards.append(warCard1B)
                }
                if let warCard1C = self.aiWar1CView.card
                {
                    self.saveAICards.append(warCard1C)
                }
            case second_column:
                self.saveAICards.append(self.aiWar2View.card!)
                
                if let warCard2A = self.aiWar2AView.card
                {
                    self.saveAICards.append(warCard2A)
                }
                if let warCard2B = self.aiWar2BView.card
                {
                    self.saveAICards.append(warCard2B)
                }
                if let warCard2C = self.aiWar2CView.card
                {
                    self.saveAICards.append(warCard2C)
                }
            default:
                self.saveAICards.append(self.aiWar3View.card!)
                
                if let warCard3A = self.aiWar3AView.card
                {
                    self.saveAICards.append(warCard3A)
                }
                if let warCard3B = self.aiWar3BView.card
                {
                    self.saveAICards.append(warCard3B)
                }
                if let warCard3C = self.aiWar3CView.card
                {
                    self.saveAICards.append(warCard3C)
                }
            }
        }
    }
    
    func discardSingleCard(player: String, column: String)
    {
        //        print("#24 (discardSingleCard)")
        if player == player_string
        {
            switch column
            {
            case first_column:
                self.discardPlayerCards.append(self.playerWar1View.card!)
                
                if let warCard1A = self.playerWar1AView.card
                {
                    self.discardPlayerCards.append(warCard1A)
                }
                if let warCard1B = self.playerWar1BView.card
                {
                    self.discardPlayerCards.append(warCard1B)
                }
                if let warCard1C = self.playerWar1CView.card
                {
                    self.discardPlayerCards.append(warCard1C)
            }
            case second_column:
                self.discardPlayerCards.append(self.playerWar2View.card!)
                
                if let warCard2A = self.playerWar2AView.card
                {
                    self.discardPlayerCards.append(warCard2A)
                }
                if let warCard2B = self.playerWar2BView.card
                {
                    self.discardPlayerCards.append(warCard2B)
                }
                if let warCard2C = self.playerWar2CView.card
                {
                    self.discardPlayerCards.append(warCard2C)
                }
            default:
                self.discardPlayerCards.append(self.playerWar3View.card!)
                
                if let warCard3A = self.playerWar3AView.card
                {
                    self.discardPlayerCards.append(warCard3A)
                }
                if let warCard3B = self.playerWar3BView.card
                {
                    self.discardPlayerCards.append(warCard3B)
                }
                if let warCard3C = self.playerWar3CView.card
                {
                    self.discardPlayerCards.append(warCard3C)
                }
            }
        }
        else if player == ai_string
        {
            switch column
            {
            case first_column:
                self.discardAICards.append(self.aiWar1View.card!)
                
                if let warCard1A = self.aiWar1AView.card
                {
                    self.discardAICards.append(warCard1A)
                }
                if let warCard1B = self.aiWar1BView.card
                {
                    self.discardAICards.append(warCard1B)
                }
                if let warCard1C = self.aiWar1CView.card
                {
                    self.discardAICards.append(warCard1C)
            }
            case second_column:
                self.discardAICards.append(self.aiWar2View.card!)
                
                if let warCard2A = self.aiWar2AView.card
                {
                    self.discardAICards.append(warCard2A)
                }
                if let warCard2B = self.aiWar2BView.card
                {
                    self.discardAICards.append(warCard2B)
                }
                if let warCard2C = self.aiWar2CView.card
                {
                    self.discardAICards.append(warCard2C)
                }
            default:
                self.discardAICards.append(self.aiWar3View.card!)
                
                if let warCard3A = self.aiWar3AView.card
                {
                    self.discardAICards.append(warCard3A)
                }
                if let warCard3B = self.aiWar3BView.card
                {
                    self.discardAICards.append(warCard3B)
                }
                if let warCard3C = self.aiWar3CView.card
                {
                    self.discardAICards.append(warCard3C)
                }
            }
        }
    }

    func cardValueOfWar(column: String) -> Int
    {
        //        print("#25 (cardValueOfWar)")
        switch column
        {
        case first_column:
            return (self.aiWar1View.card?.cardValue)! //what about wars on ABC?
        case second_column:
            return (self.aiWar2View.card?.cardValue)!
        default:
            return (self.aiWar3View.card?.cardValue)!
        }
    }
    
    func prepForWar(column: String)
    {
        //        print("#26 (prepForWar)")
        self.columnOfWar = column
        
        switch column
        {
        case first_column:
            self.isWar1 = true
        case second_column:
            self.isWar2 = true
        default:
            self.isWar3 = true
        }
        
        self.prepButtonWithTitle(war_string)
    }
    
    
                //Above contains the heart of each round
    
    
    func hideWarLabel(column: String)
    {
        //        print("#13 (hideWarLabel)")
        switch column
        {
        case first_column:
            self.war1ResultLabel.hidden = true
        case second_column:
            self.war2ResultLabel.hidden = true
        default:
            self.war3ResultLabel.hidden = true
        }
    }
    
    func playWarInColumn(column: String)
    {
        //        print("#29 (playWarInColumn)")
        if self.game.player.deck.cards.count > 0 && self.game.aiPlayer.deck.cards.count > 0
        {
            self.game.war()
            
            var playerWarView: CardView
            var aiWarView: CardView
            
            switch self.game.player.warCards.count % 3
            {
            case 1:
                switch column
                {
                case first_column:
                    playerWarView = self.playerWar1AView
                    aiWarView = self.aiWar1AView
                case second_column:
                    playerWarView = self.playerWar2AView
                    aiWarView = self.aiWar2AView
                default:
                    playerWarView = self.playerWar3AView
                    aiWarView = self.aiWar3AView
                }
            case 2:
                switch column
                {
                case first_column:
                    playerWarView = self.playerWar1BView
                    aiWarView = self.aiWar1BView
                case second_column:
                    playerWarView = self.playerWar2BView
                    aiWarView = self.aiWar2BView
                default:
                    playerWarView = self.playerWar3BView
                    aiWarView = self.aiWar3BView
                }
            default:
                switch column
                {
                case first_column:
                    playerWarView = self.playerWar1CView
                    aiWarView = self.aiWar1CView
                case second_column:
                    playerWarView = self.playerWar2CView
                    aiWarView = self.aiWar2CView
                default:
                    playerWarView = self.playerWar3CView
                    aiWarView = self.aiWar3CView
                }
            }
            
            playerWarView.card = self.game.player.warCards.last
            aiWarView.card = self.game.aiPlayer.warCards.last
            
            self.view.bringSubviewToFront(playerWarView)
            self.view.bringSubviewToFront(aiWarView)
            
            self.playGameButton.setTitle(ready_string, forState: UIControlState.Normal)
        }
        else
        {
            print("playWarInColumn deemed this game OVER!!!!!!!!!")
            self.prepButtonWithTitle(game_over_string)
        }
        self.cardsRemaining()
    }
    
    
                //Above deals with wars
    
    
    func endRound()
    {
        //        print("#28 (endRound)")
        self.war1ResultLabel.text = ""
        self.war2ResultLabel.text = ""
        self.war3ResultLabel.text = ""
        
        self.warSkippedByPlayer = false
        self.skipWarButton.hidden = true
        self.resolveWarGuideLabel.hidden = true
        
        self.isWar1 = false
        self.isWar2 = false
        self.isWar3 = false
        
        print("Player saves \(self.savePlayerCards.count) cards and discards \(self.discardPlayerCards.count) cards, AI saves \(self.saveAICards.count) cards and discards \(self.discardAICards.count) cards.")
        
        self.discardToPiles()
        
        self.game.player.discard.appendContentsOf(self.discardPlayerCards)
        self.game.aiPlayer.discard.appendContentsOf(self.discardAICards)
        self.game.player.deck.cards.appendContentsOf(self.savePlayerCards)
        self.game.aiPlayer.deck.cards.appendContentsOf(self.saveAICards)
        
        self.clearAllWarCardViewsAndTempHands()
        self.cardsRemaining()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.roundHasBegun = false
        self.playerDeckView.userInteractionEnabled = true
    }
    
    func discardToPiles()
    {
        if self.discardPlayerCards.count > 0
        {
            var currentDiscardCount = self.game.player.discard.count
            
            for card in self.discardPlayerCards
            {
                currentDiscardCount += 1
                
                switch currentDiscardCount % 5
                {
                case 1:
                    self.playerDiscardView.card = card
                    self.view.bringSubviewToFront(self.playerDiscardView)
                case 2:
                    self.playerDiscardViewA.card = card
                    self.view.bringSubviewToFront(self.playerDiscardViewA)
                case 3:
                    self.playerDiscardViewB.card = card
                    self.view.bringSubviewToFront(self.playerDiscardViewB)
                case 4:
                    self.playerDiscardViewC.card = card
                    self.view.bringSubviewToFront(self.playerDiscardViewC)
                default:
                    self.playerDiscardViewD.card = card
                    self.view.bringSubviewToFront(self.playerDiscardViewD)
                }
            }
        }
        
        if self.discardAICards.count > 0
        {
            var currentDiscardCount = self.game.aiPlayer.discard.count
            
            for card in self.discardAICards
            {
                currentDiscardCount += 1
                
                switch currentDiscardCount % 5
                {
                case 1:
                    self.aiDiscardView.card = card
                    self.view.bringSubviewToFront(self.aiDiscardView)
                case 2:
                    self.aiDiscardViewA.card = card
                    self.view.bringSubviewToFront(self.aiDiscardViewA)
                case 3:
                    self.aiDiscardViewB.card = card
                    self.view.bringSubviewToFront(self.aiDiscardViewB)
                case 4:
                    self.aiDiscardViewC.card = card
                    self.view.bringSubviewToFront(self.aiDiscardViewC)
                default:
                    self.aiDiscardViewD.card = card
                    self.view.bringSubviewToFront(self.aiDiscardViewD)
                }
            }
        }
    }
    
    func awardFinalRoundWithResult(cardResult: String)
    {
        //        print("#17 (awardFinalRoundWithResult)")
        switch cardResult
        {
        case player_string:
            self.war2ResultLabel.text = winning_emoji
        case "AI":
            self.war2ResultLabel.text = loss_emoji
        default:
            self.war2ResultLabel.text = war_emoji
        }
        self.war2ResultLabel.hidden = false
        
        self.prepButtonWithTitle("")
        
        self.finalRoundSpoils(cardResult)
    }
    
    func finalRoundSpoils(result: String)
    {
        //        print("#19 (finalRoundSpoils)")
        switch result
        {
        case winning_emoji:
            self.saveSingleCard(player_string, column: second_column)
            self.discardSingleCard(ai_string, column: second_column)
        case loss_emoji:
            self.saveSingleCard(ai_string, column: second_column)
            self.discardSingleCard(player_string, column: second_column)
        default:
            if self.game.player.deck.cards.count > 1 && self.game.aiPlayer.deck.cards.count > 1
            {
                self.prepForWar(second_column)
                //repeat this method!!
            }
            if self.game.player.deck.cards.count == 1 && self.game.aiPlayer.deck.cards.count == 1
            {
                self.saveSingleCard(player_string, column: second_column)
                self.saveSingleCard(ai_string, column: second_column)
                //tie!  retreat or both lose?  I like the thought of them shaking hands and suspending the war
                print("Both soldiers shake hands, knowing there is no backup.  The war has been suspended.")
                //GAME IS OVER
                print("GAME IS OVER. NO BACKUP FOR WAR BY BOTH PLAYERS.  TIE!")
                print("finalRoundSpoils deemed this game OVER!!!!!!!!")
                self.prepButtonWithTitle(game_over_string)
            }
            if self.game.player.deck.cards.count == 1
            {
                //automatically lose
                self.saveSingleCard(player_string, column: second_column)
                self.discardSingleCard(ai_string, column: second_column)
                //GAME IS OVER
                print("GAME IS OVER. PLAYER ONLY HAS ONE CARD LEFT.")
                print("finalRoundSpoils deemed this game OVER!!!!!!!!")
                self.prepButtonWithTitle(game_over_string)
            }
            if self.game.aiPlayer.deck.cards.count == 1
            {
                //automatically win
                self.saveSingleCard(ai_string, column: second_column)
                self.discardSingleCard(player_string, column: second_column)
                //GAME IS OVER
                print("GAME IS OVER.  AI ONLY HAS ONE CARD LEFT.")
                print("finalRoundSpoils deemed this game OVER!!!!!!!!")
                self.prepButtonWithTitle(game_over_string)
            }
            
            //war!  if you have at least 2 cards, put down the card for the war and repeat this method
            //if you have only one card, you immediately lose
            //if AI has only one card, they immediately lose
        }
    }
    
    
                //Above handles the round's end
    
    
    func endGame()
    {
        //        print("#31 (endGame)")
        print("The game is over.")
        
        let playerPoints = self.game.player.deck.cards.count
        let aiPoints = self.game.aiPlayer.deck.cards.count
        
        var winner = ""
        
        if playerPoints > aiPoints
        {
            winner = player_string
        }
        else if aiPoints > playerPoints
        {
            winner = ai_string
        }
        else
        {
            winner = "There is no winner."
        }
        
        print("Player has \(playerPoints) points, AI has \(aiPoints) points.  The winner is: \(winner)")
        
        self.prepButtonWithTitle(play_game_string)
    }
    
    
                //Above wraps up an individual game
    
    
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
        self.warSkippedByPlayer = true
        self.judgeRound()
    }
    
    
    //Above are IBActions for swapping cards, skipping wars, and the settings button

}
