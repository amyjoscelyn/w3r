//
//  GameViewController.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/26/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

let winning_emoji = "👑"
let loss_emoji = "❌"
let war_emoji = "⚔"

let first_column = "1"
let second_column = "2"
let third_column = "3"

let player_string = "Player"
let ai_string = "AI"

let save_string = "Save"
let discard_string = "Discard"

let play_game_string = "BEGIN GAME"
let ready_string = "READY!"
let war_string = "WAR!"
let end_round_string = "END ROUND"
let game_over_string = "GAME OVER"

let corner_radius: CGFloat = 8
let border_width: CGFloat = 3

class GameViewController: UIViewController
{
    var lastLocation: CGPoint = CGPointMake(0, 0)
    var deckOriginalCenter: CGPoint = CGPointMake(0, 0)
    
    @IBOutlet weak var playerDeckView: CardView!
    @IBOutlet weak var playerDiscardView: DiscardPile!
    
    @IBOutlet weak var aiDeckView: CardView!
    @IBOutlet weak var aiDiscardView: DiscardPile!
    
    var cardViews: [CardView] = []
    
    var savePlayerCards: [Card] = []
    var saveAICards: [Card] = []
    var discardPlayerCards: [Card] = []
    var discardAICards: [Card] = []
    
    @IBOutlet weak var player1ClusterView: CardCluster!
    @IBOutlet weak var player2ClusterView: CardCluster!
    @IBOutlet weak var player3ClusterView: CardCluster!
    @IBOutlet weak var ai1ClusterView: AICardCluster!
    @IBOutlet weak var ai2ClusterView: AICardCluster!
    @IBOutlet weak var ai3ClusterView: AICardCluster!
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var war1ResultLabel: UILabel!
    @IBOutlet weak var war2ResultLabel: UILabel!
    @IBOutlet weak var war3ResultLabel: UILabel!
    
    //settings button, swap buttons, deck labels, resolveWarGuide and skipWarButton
    @IBOutlet weak var centerGameView: UIView!
    
    var columnOfWar: String = ""
    var isWar1 = false
    var isWar2 = false
    var isWar3 = false
    var roundHasBegun = false
    
    let game = Game.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.cardViewArray()
        self.createGameSpace()
        self.startGame()
    }
    
    func cardViewArray()
    {
        self.cardViews = [
            self.playerDeckView,
            self.aiDeckView ]
        self.cardViews.appendContentsOf(self.playerDiscardView.getViews())
        self.cardViews.appendContentsOf(self.aiDiscardView.getViews())
        
        self.cardViews.appendContentsOf(self.player1ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.player2ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.player3ClusterView.getCardViews())
        
        self.cardViews.appendContentsOf(self.ai1ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.ai2ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.ai3ClusterView.getCardViews())
    }
    
    func createGameSpace()
    {
        //THIS SHOULD ONLY GET CALLED ONCE
        //        print("#2 (createGameSpace)")        
        self.setCardClusters()
        
        self.customizeButton(self.playGameButton)
//        self.customizeButton(self.settingsButton)
//        self.customizeButton(self.swapCards1And2Button)
//        self.customizeButton(self.swapCards2And3Button)
//        self.customizeButton(self.swapCards1And3Button)
//        self.customizeButton(self.skipWarButton)
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.centerGameView.layer.cornerRadius = corner_radius
        self.centerGameView.clipsToBounds = true
        
//        self.rotateCardViews()
        
        for cardView in self.cardViews
        {
            self.customizeCardView(cardView)
        }
    }
    
    func setCardClusters()
    {
        self.player1ClusterView.setPlayerAndColumn("Player", column: "1")
        self.player2ClusterView.setPlayerAndColumn("Player", column: "2")
        self.player3ClusterView.setPlayerAndColumn("Player", column: "3")
        
        self.ai1ClusterView.setPlayerAndColumn("AI", column: "1")
        self.ai2ClusterView.setPlayerAndColumn("AI", column: "2")
        self.ai3ClusterView.setPlayerAndColumn("AI", column: "3")
        
//        self.player1ClusterView.setWidthOfCardView()
        
//        self.player1ClusterView.autoresizesSubviews = true
//        self.player2ClusterView.autoresizesSubviews = true
//        self.player3ClusterView.autoresizesSubviews = true
//        
//        self.ai1ClusterView.autoresizesSubviews = true
//        self.ai2ClusterView.autoresizesSubviews = true
//        self.ai3ClusterView.autoresizesSubviews = true
        
        self.populateCardClusters()
    }
    
    func populateCardClusters()
    {
        self.player1ClusterView.populateCardViews()
        self.player2ClusterView.populateCardViews()
        self.player3ClusterView.populateCardViews()
        
        self.ai1ClusterView.populateCardViews()
        self.ai2ClusterView.populateCardViews()
        self.ai3ClusterView.populateCardViews()
    }
    
    func customizeButton(button: UIButton)
    {
        //        print("#3 (customizeButton)")
        button.layer.cornerRadius = corner_radius
        button.layer.borderWidth = border_width
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.clipsToBounds = true //why isn't this working?
    }
    
    func panGestures()
    {
        //        print("#4 (panGestures)")
        let deckPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleDeckPanGesture))
        self.playerDeckView.addGestureRecognizer(deckPanGesture)
        self.playerDeckView.userInteractionEnabled = true
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
//        self.resolveWarGuideLabel.hidden = true
//        self.skipWarButton.hidden = true
//        self.swapCards1And2Button.hidden = true
//        self.swapCards2And3Button.hidden = true
//        self.swapCards1And3Button.hidden = true
        
//        self.aiDiscardView.card = nil;
//        self.aiDiscardViewA.card = nil;
//        self.aiDiscardViewB.card = nil;
//        self.aiDiscardViewC.card = nil;
//        self.aiDiscardViewD.card = nil;
//        self.playerDiscardView.card = nil;
//        self.playerDiscardViewA.card = nil;
//        self.playerDiscardViewB.card = nil;
//        self.playerDiscardViewC.card = nil;
//        self.playerDiscardViewD.card = nil;
    }
    
    func clearAllWarCardViewsAndTempHands()
    {
        //        print("#7 (clearAllWarCardViewsAndTempHands)")
        
        //should be enough to clear the cards
        self.populateCardClusters()
        
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
            self.view.bringSubviewToFront(self.playerDeckView)
            self.lastLocation = self.playerDeckView.center
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            let translation = panGesture.translationInView(self.view!)
            self.playerDeckView.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            
            if self.playerDeckView.center.y <= 450.0 && self.player2ClusterView.baseCardView.hidden == true && self.roundHasBegun == false
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
            
//            self.swapCards1And2Button.hidden = false
//            self.swapCards2And3Button.hidden = false
//            self.swapCards1And3Button.hidden = false
            
            self.prepButtonWithTitle(ready_string)
            
            self.playerDeckView.userInteractionEnabled = false
            
            //***************************************
            //for testing purposes, this code can be commented out
            //            self.aiWar1View.faceUp = false
            //            self.aiWar2View.faceUp = false
            //            self.aiWar3View.faceUp = false
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
        
//        self.playerCardsRemainingInDeckLabel.text = "Cards: \(playerDeckCount/* + self.game.player.hand.count*/)"
//        self.aiCardsRemainingInDeckLabel.text = "Cards: \(aiDeckCount/* + self.game.aiPlayer.hand.count*/)"
        
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
        self.player1ClusterView.addCard(self.game.player.hand[0])
        self.player2ClusterView.addCard(self.game.player.hand[1])
        self.player3ClusterView.addCard(self.game.player.hand[2])
        
        self.ai1ClusterView.addCard(self.game.aiPlayer.hand[0])
        self.ai2ClusterView.addCard(self.game.aiPlayer.hand[1])
        self.ai3ClusterView.addCard(self.game.aiPlayer.hand[2])
        
        self.populateCardClusters()
        
//        self.aiWar1View.card = self.game.aiPlayer.hand[0]
//        self.aiWar2View.card = self.game.aiPlayer.hand[1]
//        self.aiWar3View.card = self.game.aiPlayer.hand[2]
//        self.playerWar1View.card = self.game.player.hand[0]
//        self.playerWar2View.card = self.game.player.hand[1]
//        self.playerWar3View.card = self.game.player.hand[2]
        
        self.game.aiPlayer.hand.removeAll()
        self.game.player.hand.removeAll()
    }
    
    func prepButtonWithTitle(title: String)
    {
        //        print("#27 (prepButtonWithTitle)")
        self.playGameButton.setTitle(title, forState: UIControlState.Normal)
        self.playGameButton.enabled = true
    }
    
    //THIS METHOD ISN'T ACTIVE YET!!!!!
    func populateHandWithSingleCard()
    {
        //        print("#10 (populateHandWithSingleCard)")
        print("[populateHandWithSingleCard] player has \(self.game.player.deck.cards.count) cards in deck, AI has \(self.game.aiPlayer.deck.cards.count) cards")
//        self.aiWar2View.card = self.game.aiPlayer.hand[0]
//        self.playerWar2View.card = self.game.player.hand[0] //maybe new cardView here instead?
//        
//        self.aiWar1View.card = nil
//        self.aiWar3View.card = nil
//        self.playerWar1View.card = nil //set 2 as nil... or they should already be nil, because of the endRound, right?
//        self.playerWar3View.card = nil
        
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
//            self.aiWar1View.faceUp = true
//            self.aiWar2View.faceUp = true
//            self.aiWar3View.faceUp = true
            
            self.judgeRound()
        }
        else if label == war_string
        {
//            self.skipWarButton.hidden = true
//            self.resolveWarGuideLabel.hidden = true
            self.hideWarLabel(self.columnOfWar)
            self.playWarInColumn(self.columnOfWar)
        }
        else if label == end_round_string
        {
            self.endRound()
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
        if self.player1ClusterView.baseCardView != nil
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
            playerCard = self.player1ClusterView.cardToJudge()
            aiCard = self.ai1ClusterView.cardToJudge()
//            if !isWar1
//            {
//                playerCard = self.player1ClusterView.baseCardView.card!
//                aiCard = self.ai1ClusterView.baseCardView.card!
//            }
//            else
//            {
//                let aViewZIndex = self.view.subviews.indexOf(self.playerWar1AView)
//                let bViewZIndex = self.view.subviews.indexOf(self.playerWar1BView)
//                let cViewZIndex = self.view.subviews.indexOf(self.playerWar1CView)
//                
//                if aViewZIndex > bViewZIndex
//                {
//                    playerCard = self.playerWar1AView.card!
//                    aiCard = self.aiWar1AView.card!
//                }
//                else if bViewZIndex > cViewZIndex
//                {
//                    playerCard = self.playerWar1BView.card!
//                    aiCard = self.aiWar1BView.card!
//                }
//                else
//                {
//                    playerCard = self.playerWar1CView.card!
//                    aiCard = self.aiWar1CView.card!
//                }
//            }
        case second_column:
            playerCard = self.player2ClusterView.cardToJudge()
            aiCard = self.ai2ClusterView.cardToJudge()
//            if !isWar2
//            {
//                playerCard = self.playerWar2View.card!
//                aiCard = self.aiWar2View.card!
//            }
//            else
//            {
//                let aViewZIndex = self.view.subviews.indexOf(self.playerWar2AView)
//                let bViewZIndex = self.view.subviews.indexOf(self.playerWar2BView)
//                let cViewZIndex = self.view.subviews.indexOf(self.playerWar2CView)
//                
//                if aViewZIndex > bViewZIndex
//                {
//                    playerCard = self.playerWar2AView.card!
//                    aiCard = self.aiWar2AView.card!
//                }
//                else if bViewZIndex > cViewZIndex
//                {
//                    playerCard = self.playerWar2BView.card!
//                    aiCard = self.aiWar2BView.card!
//                }
//                else
//                {
//                    playerCard = self.playerWar2CView.card!
//                    aiCard = self.aiWar2CView.card!
//                }
//            }
        default:
            playerCard = self.player3ClusterView.cardToJudge()
            aiCard = self.ai3ClusterView.cardToJudge()
//            if !isWar3
//            {
//                playerCard = self.playerWar3View.card!
//                aiCard = self.aiWar3View.card!
//            }
//            else
//            {
//                let aViewZIndex = self.view.subviews.indexOf(self.playerWar3AView)
//                let bViewZIndex = self.view.subviews.indexOf(self.playerWar3BView)
//                let cViewZIndex = self.view.subviews.indexOf(self.playerWar3CView)
//                
//                if aViewZIndex > bViewZIndex
//                {
//                    playerCard = self.playerWar3AView.card!
//                    aiCard = self.aiWar3AView.card!
//                }
//                else if bViewZIndex > cViewZIndex
//                {
//                    playerCard = self.playerWar3BView.card!
//                    aiCard = self.aiWar3BView.card!
//                }
//                else
//                {
//                    playerCard = self.playerWar3CView.card!
//                    aiCard = self.aiWar3CView.card!
//                }
//            }
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
//        self.swapCards1And2Button.hidden = true
//        self.swapCards2And3Button.hidden = true
//        self.swapCards1And3Button.hidden = true
        
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
                    self.playerHandActions([ discard_string, save_string, save_string ])
                case second_column:
                    self.playerHandActions([ save_string, discard_string, save_string ])
                default:
                    self.playerHandActions([ save_string, save_string, discard_string ])
                }
                
                self.discardAllCards(ai_string)
                
                self.prepButtonWithTitle(end_round_string)
            }
            else //war
            {
                column = self.columnOfResult(war_emoji)
                let warValue = self.cardValueOfWar(column) //only good for initial wars... right?
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
                        self.aiHandActions([ save_string, discard_string, discard_string ])
                    case second_column:
                        self.aiHandActions([ discard_string, save_string, discard_string ])
                    default:
                        self.aiHandActions([ discard_string, discard_string, save_string ])
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
                    self.aiHandActions([ discard_string, save_string, save_string ])
                case second_column:
                    self.aiHandActions([ save_string, discard_string, save_string ])
                default:
                    self.aiHandActions([ save_string, save_string, discard_string ])
                }
                
                self.discardAllCards(player_string)
                
                self.prepButtonWithTitle(end_round_string)
            }
            else //war
            {
                print("playing the war now...")
                column = self.columnOfResult(war_emoji)
                
//                self.skipWarButton.hidden = false
//                self.resolveWarGuideLabel.hidden = false
                
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
                    
                    if firstWar >= secondWar
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
                    
                    if firstWar >= secondWar
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
                    
                    if firstWar >= secondWar
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
        //I don't think I need this new array.  I can just use the property it eventually gets added to
        
        if player == player_string
        {
//            cardsToSave = [ self.playerWar1View.card!, self.playerWar2View.card!, self.playerWar3View.card! ]
            cardsToSave.appendContentsOf(self.player1ClusterView.removeCards())
            cardsToSave.appendContentsOf(self.player2ClusterView.removeCards())
            cardsToSave.appendContentsOf(self.player3ClusterView.removeCards())
//            cardsToSave.appendContentsOf(self.game.player.warCards)
            
            self.savePlayerCards.appendContentsOf(cardsToSave)
        }
        else if player == ai_string
        {
//            cardsToSave = [ self.aiWar1View.card!, self.aiWar2View.card!, self.aiWar3View.card! ]
//            cardsToSave.appendContentsOf(self.game.aiPlayer.warCards)

            cardsToSave.appendContentsOf(self.ai1ClusterView.removeCards())
            cardsToSave.appendContentsOf(self.ai2ClusterView.removeCards())
            cardsToSave.appendContentsOf(self.ai3ClusterView.removeCards())
            
            self.saveAICards.appendContentsOf(cardsToSave)
        }
    }
    
    func discardAllCards(player: String)
    {
        //        print("#22 (discardAllCards)")
        var cardsToDiscard: [Card] = []
        
        if player == player_string
        {
//            cardsToDiscard = [ self.playerWar1View.card!, self.playerWar2View.card!, self.playerWar3View.card! ]
//            cardsToDiscard.appendContentsOf(self.game.player.warCards)
            //WHAT AM I USING THIS GAME.WARCARDS METHOD FOR THEN?!?!?!?!

            cardsToDiscard.appendContentsOf(self.player1ClusterView.removeCards())
            cardsToDiscard.appendContentsOf(self.player2ClusterView.removeCards())
            cardsToDiscard.appendContentsOf(self.player3ClusterView.removeCards())
            
            self.discardPlayerCards.appendContentsOf(cardsToDiscard)
        }
        else if player == ai_string
        {
//            cardsToDiscard = [ self.aiWar1View.card!, self.aiWar2View.card!, self.aiWar3View.card! ]
//            cardsToDiscard.appendContentsOf(self.game.aiPlayer.warCards)
            cardsToDiscard.appendContentsOf(self.ai1ClusterView.removeCards())
            cardsToDiscard.appendContentsOf(self.ai2ClusterView.removeCards())
            cardsToDiscard.appendContentsOf(self.ai3ClusterView.removeCards())
            
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
    
    func playerHandActions(actions: [String])
    {
        let action1 = actions[0]
        let action2 = actions[1]
        let action3 = actions[2]
        
        switch action1
        {
        case save_string:
            saveSingleCard(player_string, column: first_column)
        default:
            discardSingleCard(player_string, column: first_column)
        }
        switch action2
        {
        case save_string:
            saveSingleCard(player_string, column: second_column)
        default:
            discardSingleCard(player_string, column: second_column)
        }
        switch action3
        {
        case save_string:
            saveSingleCard(player_string, column: third_column)
        default:
            discardSingleCard(player_string, column: third_column)
        }
    }
    
    func aiHandActions(actions: [String])
    {
        let action1 = actions[0]
        let action2 = actions[1]
        let action3 = actions[2]
        
        switch action1
        {
        case save_string:
            saveSingleCard(ai_string, column: first_column)
        default:
            discardSingleCard(ai_string, column: first_column)
        }
        switch action2
        {
        case save_string:
            saveSingleCard(ai_string, column: second_column)
        default:
            discardSingleCard(ai_string, column: second_column)
        }
        switch action3
        {
        case save_string:
            saveSingleCard(ai_string, column: third_column)
        default:
            discardSingleCard(ai_string, column: third_column)
        }
    }
    
    func saveSingleCard(player: String, column: String)
    {
        //        print("#23 (saveSingleCard)")
        if player == player_string
        {
            switch column
            {
            case first_column:
                self.savePlayerCards.appendContentsOf(self.player1ClusterView.removeCards())
            case second_column:
                self.savePlayerCards.appendContentsOf(self.player2ClusterView.removeCards())
            default:
                self.savePlayerCards.appendContentsOf(self.player3ClusterView.removeCards())
            }
        }
        else if player == ai_string
        {
            switch column
            {
            case first_column:
                self.saveAICards.appendContentsOf(self.ai1ClusterView.removeCards())
            case second_column:
                self.saveAICards.appendContentsOf(self.ai2ClusterView.removeCards())
            default:
                self.saveAICards.appendContentsOf(self.ai3ClusterView.removeCards())
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
                self.discardPlayerCards.appendContentsOf(self.player1ClusterView.removeCards())
            case second_column:
                self.discardPlayerCards.appendContentsOf(self.player2ClusterView.removeCards())
            default:
                self.discardPlayerCards.appendContentsOf(self.player3ClusterView.removeCards())
            }
        }
        else if player == ai_string
        {
            switch column
            {
            case first_column:
                self.discardAICards.appendContentsOf(self.ai1ClusterView.removeCards())
            case second_column:
                self.discardAICards.appendContentsOf(self.ai2ClusterView.removeCards())
            default:
                self.discardAICards.appendContentsOf(self.ai3ClusterView.removeCards())
            }
        }
    }
    
    func cardValueOfWar(column: String) -> Int
    {
        //        print("#25 (cardValueOfWar)")
        switch column
        {
        case first_column:
//            return (self.aiWar1View.card?.cardValue)!
            return self.ai1ClusterView.cardToJudge().cardValue
        case second_column:
//            return (self.aiWar2View.card?.cardValue)!
            return self.ai2ClusterView.cardToJudge().cardValue
        default:
//            return (self.aiWar3View.card?.cardValue)!
            return self.ai3ClusterView.cardToJudge().cardValue
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
            
            let playerCardCluster: CardCluster
            let aiCardCluster: AICardCluster
            
            if self.isWar1
            {
                playerCardCluster = self.player1ClusterView
                aiCardCluster = self.ai1ClusterView
            }
            else if self.isWar2
            {
                playerCardCluster = self.player2ClusterView
                aiCardCluster = self.ai2ClusterView
            }
            else
            {
                playerCardCluster = self.player3ClusterView
                aiCardCluster = self.ai3ClusterView
            }
            
            playerCardCluster.addCard(self.game.player.warCards.last!)
            aiCardCluster.addCard(self.game.aiPlayer.warCards.last!)
            
            self.populateCardClusters()
            
//            var playerWarView: CardView
//            var aiWarView: CardView
//            
//            switch self.game.player.warCards.count % 3
//            {
//            case 1:
//                switch column
//                {
//                case first_column:
//                    playerWarView = self.playerWar1AView
//                    aiWarView = self.aiWar1AView
//                case second_column:
//                    playerWarView = self.playerWar2AView
//                    aiWarView = self.aiWar2AView
//                default:
//                    playerWarView = self.playerWar3AView
//                    aiWarView = self.aiWar3AView
//                }
//            case 2:
//                switch column
//                {
//                case first_column:
//                    playerWarView = self.playerWar1BView
//                    aiWarView = self.aiWar1BView
//                case second_column:
//                    playerWarView = self.playerWar2BView
//                    aiWarView = self.aiWar2BView
//                default:
//                    playerWarView = self.playerWar3BView
//                    aiWarView = self.aiWar3BView
//                }
//            default:
//                switch column
//                {
//                case first_column:
//                    playerWarView = self.playerWar1CView
//                    aiWarView = self.aiWar1CView
//                case second_column:
//                    playerWarView = self.playerWar2CView
//                    aiWarView = self.aiWar2CView
//                default:
//                    playerWarView = self.playerWar3CView
//                    aiWarView = self.aiWar3CView
//                }
//            }
//            
//            playerWarView.card = self.game.player.warCards.last
//            aiWarView.card = self.game.aiPlayer.warCards.last
//            
//            self.view.bringSubviewToFront(playerWarView)
//            self.view.bringSubviewToFront(aiWarView)
            
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
        
        //        self.warSkippedByPlayer = false
//        self.skipWarButton.hidden = true
//        self.resolveWarGuideLabel.hidden = true
        
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
//                
//                switch currentDiscardCount % 5
//                {
//                case 1:
//                    self.playerDiscardView.card = card
//                    self.view.bringSubviewToFront(self.playerDiscardView)
//                case 2:
//                    self.playerDiscardViewA.card = card
//                    self.view.bringSubviewToFront(self.playerDiscardViewA)
//                case 3:
//                    self.playerDiscardViewB.card = card
//                    self.view.bringSubviewToFront(self.playerDiscardViewB)
//                case 4:
//                    self.playerDiscardViewC.card = card
//                    self.view.bringSubviewToFront(self.playerDiscardViewC)
//                default:
//                    self.playerDiscardViewD.card = card
//                    self.view.bringSubviewToFront(self.playerDiscardViewD)
//                }
            }
        }
        
        if self.discardAICards.count > 0
        {
            var currentDiscardCount = self.game.aiPlayer.discard.count
            
            for card in self.discardAICards
            {
                currentDiscardCount += 1
                
//                switch currentDiscardCount % 5
//                {
//                case 1:
//                    self.aiDiscardView.card = card
//                    self.view.bringSubviewToFront(self.aiDiscardView)
//                case 2:
//                    self.aiDiscardViewA.card = card
//                    self.view.bringSubviewToFront(self.aiDiscardViewA)
//                case 3:
//                    self.aiDiscardViewB.card = card
//                    self.view.bringSubviewToFront(self.aiDiscardViewB)
//                case 4:
//                    self.aiDiscardViewC.card = card
//                    self.view.bringSubviewToFront(self.aiDiscardViewC)
//                default:
//                    self.aiDiscardViewD.card = card
//                    self.view.bringSubviewToFront(self.aiDiscardViewD)
//                }
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
                //                self.prepButtonWithTitle(game_over_string)
                //I think instead here should go another method, where it resolves the round--endRound?--and THEN sets the title to the game_over_string, so that we can see the card being discarded.
                //And maybe if there's at least a single card still left in one person's hand, MAYBE play can continue?  Or they can choose at that point whether they want to play it.
                //If, however, that single card was one they just won... maybe it's a one-use thing and then you get credited a point, or maybe they just keep going until a player has 0 cards?  But the longer you play that same card, the more likely you'll run into a war, and that's not desirable.
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
    
    
    /*
     HERE GO ALL OF THE @IBACTION METHODS
 */
}
