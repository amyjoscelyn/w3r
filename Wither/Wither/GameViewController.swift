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
let border_width: CGFloat = 2

class GameViewController: UIViewController, HorizontallyReorderableStackViewDelegate
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
    
    @IBOutlet weak var playerHandStackView: HorizontallyReorderableStackView!
    
    @IBOutlet weak var ai1ClusterView: AICardCluster!
    @IBOutlet weak var ai2ClusterView: AICardCluster!
    @IBOutlet weak var ai3ClusterView: AICardCluster!
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var war1ResultLabel: UILabel!
    @IBOutlet weak var war2ResultLabel: UILabel!
    @IBOutlet weak var war3ResultLabel: UILabel!
    @IBOutlet weak var playerCardsRemainingInDeckLabel: UILabel!
    @IBOutlet weak var aiCardsRemainingInDeckLabel: UILabel!
    
    //settings button, resolveWarGuide and skipWarButton
    @IBOutlet weak var centerGameView: UIView!
    
    var warsToBeResolved: [String] = []
    var columnOfWar: String = ""
    var isWar1 = false
    var isWar2 = false
    var isWar3 = false
    var roundHasBegun = false
    var firstTimeJudgingHand = true
    
    let gameDataStore = GameDataStore.sharedInstance
    let game = Game.init()
    
    //# MARK: - Game Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.cardViewArray()
        self.createGameSpace()
        self.startGame()
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func cardViewArray()
    {
        self.cardViews = [ self.playerDeckView, self.aiDeckView ]
        self.cardViews.appendContentsOf(self.playerDiscardView.getViews())
        self.cardViews.appendContentsOf(self.aiDiscardView.getViews())
        
        for subview in self.playerHandStackView.arrangedSubviews
        {
            let cardCluster = subview as! CardCluster
            self.cardViews.appendContentsOf(cardCluster.getCardViews())
        }
        
        self.cardViews.appendContentsOf(self.ai1ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.ai2ClusterView.getCardViews())
        self.cardViews.appendContentsOf(self.ai3ClusterView.getCardViews())
    }
    
    func createGameSpace()
    {
        //THIS SHOULD ONLY GET CALLED ONCE
        //        print("#2 (createGameSpace)")
        
        self.setCardClusters()
        
        self.playerDiscardView.setPlayer(player_string)
        self.aiDiscardView.setPlayer(ai_string)
        self.playerDiscardView.clearCards()
        self.aiDiscardView.clearCards()
        self.playerDiscardView.rotateViews()
        self.aiDiscardView.rotateViews()
        
        self.customizeButton(self.playGameButton)
        //        self.customizeButton(self.settingsButton)
        //        self.customizeButton(self.skipWarButton)
        
        self.war1ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22)
        self.war2ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22)
        self.war3ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22)
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.centerGameView.layer.cornerRadius = corner_radius
        self.centerGameView.clipsToBounds = true
        
        for cardView in self.cardViews
        {
            self.customizeCardView(cardView)
        }
    }
    
    func setCardClusters()
    {
        let columnsArray = [first_column, second_column, third_column]
        
        for i in 0..<3
        {
            let subview = self.playerHandStackView.arrangedSubviews[i]
            let cardCluster = subview as! CardCluster
            
            let column = columnsArray[i]
            
            cardCluster.setColumn(column)
        }
        
        self.ai1ClusterView.setColumn(first_column)
        self.ai2ClusterView.setColumn(second_column)
        self.ai3ClusterView.setColumn(third_column)
        
        self.populateCardClusters()
    }
    
    func populateCardClusters()
    {
        for subview in self.playerHandStackView.arrangedSubviews
        {
            let cardCluster = subview as! CardCluster
            cardCluster.populateCardViews()
        }
        
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
        button.clipsToBounds = true
        
        button.titleLabel?.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 17/22)
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
    
    
    //# MARK: - New Game
    
    
    func startGame()
    {
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.resetGame()
        //***************************************
        //for testing purposes, this code can be commented out
        //self.game.startGame()
        //***************************************
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
    }
    
    func clearAllWarCardViewsAndTempHands()
    {
        //        print("#7 (clearAllWarCardViewsAndTempHands)")
        self.populateCardClusters()
        
        self.discardPlayerCards.removeAll()
        self.discardAICards.removeAll()
        self.savePlayerCards.removeAll()
        self.saveAICards.removeAll()
        
        self.game.warIsDone()
    }
    
    
    //# MARK: - User Interaction
    
    
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
            
            let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
            
            if self.playerDeckView.center.y <= 450.0 && cardCluster2.baseCardView.hidden == true && self.roundHasBegun == false
            {
                self.newRound()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            self.playerDeckView.center = self.deckOriginalCenter
        }
    }
    
    func didReorderArrangedSubviews(arrangedSubviews: Array<UIView>)
    {
        var rearrangedBaseCards = Array<Card>()
        for subview in arrangedSubviews {
            let cardCluster = subview as! CardCluster
            if let card = cardCluster.baseCardView.card {
                rearrangedBaseCards.append(card)
            }
        }
    }
    
    func canReorderSubview(subview: UIView) -> Bool
    {
        //here is where I tell it that I can/'t reorder the subviews
        print("canReorderSubview called!!!!!")
        
        return true
    }
    
    
    //# MARK: - New Round
    
    
    func newRound()
    {
        //        print("#8 (newRound)")
        self.roundHasBegun = true
        self.game.drawHands()
        self.cardsRemaining()
        
        if self.game.player.hand.count == 3 && self.game.aiPlayer.hand.count == 3
        {
            self.populateHandWithCards()
            
            self.prepButtonWithTitle(ready_string)
            
            self.playerDeckView.userInteractionEnabled = false
            
            self.playerHandStackView.reorderingEnabled = true
            
            //***************************************
            //for testing purposes, this code can be commented out
            //            self.ai1ClusterView.faceDown()
            //            self.ai2ClusterView.faceDown()
            //            self.ai3ClusterView.faceDown()
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
        
        self.playerCardsRemainingInDeckLabel.text = "Cards: \(playerDeckCount)"
        self.aiCardsRemainingInDeckLabel.text = "Cards: \(aiDeckCount)"
        
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
        
        for i in 0..<3
        {
            let subview = self.playerHandStackView.arrangedSubviews[i]
            let cardCluster = subview as! CardCluster
            
            let card = self.game.player.hand[i]
            
            cardCluster.addCard(card)
        }
        
        self.ai1ClusterView.addCard(self.game.aiPlayer.hand[0])
        self.ai2ClusterView.addCard(self.game.aiPlayer.hand[1])
        self.ai3ClusterView.addCard(self.game.aiPlayer.hand[2])
        
        self.populateCardClusters()
        
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
        
        let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
        
        cardCluster2.addCard(self.game.player.hand[0])
        self.ai2ClusterView.addCard(self.game.aiPlayer.hand[0])
        
        self.populateCardClusters()
        
        self.game.aiPlayer.hand.removeAll()
        self.game.player.hand.removeAll()
    }
    
    
    //# MARK: - Pivot Point
    
    
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
            //helper method?
            self.ai1ClusterView.showCard()
            self.ai2ClusterView.showCard()
            self.ai3ClusterView.showCard()
            
            if self.firstTimeJudgingHand
            {
                self.firstTimeThroughHand()
            }
            self.determineWinnerOfHand()
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
    
    
    //# MARK: - Round Gameplay (Heart of each round, judging)
    
    
    
    func firstTimeThroughHand()
    {
        print("first time judging hand!!")
        
        //track here
        /*
         look at player handvalue, find max, index of
         index of translates to column
         save column in gamedatastore
         */
        
        let column = self.game.player.columnOfHighestCard()
        print("GameVC column with highest card: \(column)")
        self.gameDataStore.playerCardTrackerArray.append(column)
        
        self.firstTimeJudgingHand = false
    }
    
    func determineWinnerOfHand()
    {
        let cardCluster1 = self.playerHandStackView.arrangedSubviews[0] as! CardCluster
        
        if !cardCluster1.baseCardView.hidden
        {
            self.judgeRound()
        }
        else
        {
            self.judgeFinalRound()
        }
    }
    
    func judgeRound()
    {
        //        print("#14 (judgeRound)")
        let cardsToJudge1 = self.cardsToJudge(first_column)
        let cardsToJudge2 = self.cardsToJudge(second_column)
        let cardsToJudge3 = self.cardsToJudge(third_column)
        
        let winnerOf1 = self.resolveWar(cardsToJudge1)
        let winnerOf2 = self.resolveWar(cardsToJudge2)
        let winnerOf3 = self.resolveWar(cardsToJudge3)
        
        //            print("\(winnerOf1) won 1, \(winnerOf2) won 2, \(winnerOf3) won 3")
        
        self.awardRoundWithResult(winnerOf1, cardResult2: winnerOf2, cardResult3: winnerOf3)
    }
    
    func judgeFinalRound()
    {
        //there is only one card up, #2
        
        print("~~~~~~~~cards in player hand: \(self.game.player.hand.count) \n ~~~~~~~~cards in ai hand: \(self.game.aiPlayer.hand.count)")
        
        let cardsToJudge = self.cardsToJudge(second_column)
        let winner = self.resolveWar(cardsToJudge)
        
        print("\(winner) won!!")
        
        self.awardFinalRoundWithResult(winner)
    }
    
    func cardsToJudge(column: String) -> [Card]
    {
        var playerCard: Card = Card.init(suit: "X", rank: "0")
        var aiCard: Card = Card.init(suit: "X", rank: "0")
        
        let clusters = self.arrangedCardClusters()
        
        switch column
        {
        case first_column:
            playerCard = clusters[0].cardToJudge()
            aiCard = self.ai1ClusterView.cardToJudge()
        case second_column:
            playerCard = clusters[1].cardToJudge()
            aiCard = self.ai2ClusterView.cardToJudge()
        default:
            playerCard = clusters[2].cardToJudge()
            aiCard = self.ai3ClusterView.cardToJudge()
        }
        return [ playerCard, aiCard ]
    }
    
    func arrangedCardClusters() -> [CardCluster]
    {
        var clusters: [CardCluster] = []
        
        for subview in self.playerHandStackView.arrangedSubviews
        {
            let cardCluster = subview as! CardCluster
            clusters.append(cardCluster)
        }
        return clusters
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
        
        self.roundSpoils() //I need a much better name for this method
    }
    
    func roundSpoils()
    {
        //        print("#18 (roundSpoils)")
        
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
        
        if winCount == 3
        {
            self.outcomeOne()
        }
        else if lossCount == 3
        {
            self.outcomeTwo()
        }
        else if winCount == 2
        {
            if lossCount == 1
            {
                self.outcomeThree()
            }
            else
            {//has 1 war
                self.outcomeFour()
            }
        }
        else if lossCount == 2
        {
            if winCount == 1
            {
                self.outcomeFive()
            }
            else
            {//has 1 war
                self.outcomeSix()
            }
        }
        else
        {
            self.outcomeSeven(warCount, winCount: winCount)
        }
        
        //        print("crowns: \(winCount), X's: \(lossCount), swords: \(warCount)")
    }
    
    
    //# MARK: - Hand Outcomes
    
    
    func outcomeOne()
    {
//        print("case #1 (player wins all!)")
        self.saveAllCards(player_string)
        self.discardAllCards(ai_string)
        
        self.prepButtonWithTitle(end_round_string)
    }
    
    func outcomeTwo()
    {
//        print("case #2 (AI wins all)")
        self.discardAllCards(player_string)
        self.saveAllCards(ai_string)
        
        self.prepButtonWithTitle(end_round_string)
    }
    
    func outcomeThree()
    {
        let column = self.columnOfResult(loss_emoji)
        
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
    
    func outcomeFour()
    {
        let column = self.columnOfResult(war_emoji)
        let warValue = self.cardValueOfWar(column)
        //                print("AI has lost, but gets to pass on the war.")
        let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue)
        
        if willResolveWar
        {
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
    
    func outcomeFive()
    {
        let column = self.columnOfResult(winning_emoji)
        
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
    
    func outcomeSix()
    {
        //                print("playing the war now...")
        let column = self.columnOfResult(war_emoji)
        
        //                self.skipWarButton.hidden = false
        //                self.resolveWarGuideLabel.hidden = false
        
        self.prepForWar(column)
    }
    
    func outcomeSeven(warCount: Int, winCount: Int)
    {
        var column = ""
        
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
                
                //if firstWar is greater or equal to second war
                //if one of the wars is already on their second card...
                if firstWar >= secondWar || self.columnOfWar == second_column
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
                
                if firstWar >= secondWar || self.columnOfWar == first_column
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
                
                if firstWar >= secondWar || self.columnOfWar == first_column
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
    
    
    //# MARK: - Fate of Cards
    
    
    func saveAllCards(player: String)
    {
        //        print("#21 (saveAllCards)")
        var cardsToSave: [Card] = []
        
        if player == player_string
        {
            for subview in self.playerHandStackView.arrangedSubviews
            {
                let cardCluster = subview as! CardCluster
                cardsToSave.appendContentsOf(cardCluster.removeCards())
            }
            self.savePlayerCards.appendContentsOf(cardsToSave)
        }
        else if player == ai_string
        {
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
            //cardsToDiscard.appendContentsOf(self.game.player.warCards)
            //WHAT AM I USING THIS GAME.WARCARDS METHOD FOR THEN?!?!?!?!
            
            for subview in self.playerHandStackView.arrangedSubviews
            {
                let cardCluster = subview as! CardCluster
                cardsToDiscard.appendContentsOf(cardCluster.removeCards())
            }
            self.discardPlayerCards.appendContentsOf(cardsToDiscard)
        }
        else if player == ai_string
        {
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
        let clusters = self.arrangedCardClusters()
        
        if player == player_string
        {
            switch column
            {
            case first_column:
                let playerCluster1 = clusters[0]
                self.savePlayerCards.appendContentsOf(playerCluster1.removeCards())
            case second_column:
                let playerCluster2 = clusters[1]
                self.savePlayerCards.appendContentsOf(playerCluster2.removeCards())
            default:
                let playerCluster3 = clusters[2]
                self.savePlayerCards.appendContentsOf(playerCluster3.removeCards())
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
        let clusters = self.arrangedCardClusters()
        
        if player == player_string
        {
            switch column
            {
            case first_column:
                let playerCluster1 = clusters[0]
                self.discardPlayerCards.appendContentsOf(playerCluster1.removeCards())
            case second_column:
                let playerCluster2 = clusters[1]
                self.discardPlayerCards.appendContentsOf(playerCluster2.removeCards())
            default:
                let playerCluster3 = clusters[2]
                self.discardPlayerCards.appendContentsOf(playerCluster3.removeCards())
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
    
    
    //# MARK: - Wars
    
    
    func cardValueOfWar(column: String) -> Int
    {
        //        print("#25 (cardValueOfWar)")
        switch column
        {
        case first_column:
            return self.ai1ClusterView.cardToJudge().cardValue
        case second_column:
            return self.ai2ClusterView.cardToJudge().cardValue
        default:
            return self.ai3ClusterView.cardToJudge().cardValue
        }
    }
    
    func prepForWar(column: String)
    {
        //        print("#26 (prepForWar)")
        if self.columnOfWar != column
        {
            self.columnOfWar = column
        }
        
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
    
    func hideWarLabel(column: String)
    {
        //        print("#13 (hideWarLabel)")
        switch column
        {
        case first_column:
            self.war1ResultLabel.text = "  "
        case second_column:
            self.war2ResultLabel.text = "  "
        default:
            self.war3ResultLabel.text = "  "
        }
    }
    
    func playWarInColumn(column: String)
    {
        //        print("#29 (playWarInColumn)")
        if self.game.player.deck.cards.count > 0 && self.game.aiPlayer.deck.cards.count > 0
        {
            self.game.war()
            
            let clusters = self.arrangedCardClusters()
            
            let playerCardCluster: CardCluster
            let aiCardCluster: AICardCluster
            
            if self.isWar1
            {
                playerCardCluster = clusters[0]
                aiCardCluster = self.ai1ClusterView
                
                self.isWar1 = false
            }
            else if self.isWar2
            {
                playerCardCluster = clusters[1]
                aiCardCluster = self.ai2ClusterView
                
                self.isWar2 = false
            }
            else //self.isWar3
            {
                playerCardCluster = clusters[2]
                aiCardCluster = self.ai3ClusterView
                
                self.isWar3 = false
            }
            
            playerCardCluster.addCard(self.game.player.warCards.last!)
            aiCardCluster.addCard(self.game.aiPlayer.warCards.last!)
            self.populateCardClusters()
            
            self.playGameButton.setTitle(ready_string, forState: UIControlState.Normal)
            
            
            //I think I should make all self.isWar# false here
            self.isWar1 = false
            self.isWar2 = false
            self.isWar3 = false
        }
        else
        {
            print("playWarInColumn deemed this game OVER!!!!!!!!!")
            self.prepButtonWithTitle(game_over_string)
        }
        self.cardsRemaining()
    }
    
    
    //# MARK: - End of Round
    
    
    func endRound()
    {
        //        print("#28 (endRound)")
        self.war1ResultLabel.text = ""
        self.war2ResultLabel.text = ""
        self.war3ResultLabel.text = ""
        
        self.columnOfWar = ""
        
        //        self.warSkippedByPlayer = false
        //        self.skipWarButton.hidden = true
        //        self.resolveWarGuideLabel.hidden = true
        
        //        self.isWar1 = false
        //        self.isWar2 = false
        //        self.isWar3 = false
        
        //print("Player saves \(self.savePlayerCards.count) cards and discards \(self.discardPlayerCards.count) cards, AI saves \(self.saveAICards.count) cards and discards \(self.discardAICards.count) cards.")
        
        let cardsInPlay = [ self.discardPlayerCards, self.discardAICards, self.savePlayerCards, self.saveAICards ]
        
        self.discardToPiles()
        self.game.endRound(cardsInPlay)

        self.clearAllWarCardViewsAndTempHands()
        self.cardsRemaining()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false
        
        self.roundHasBegun = false
        self.playerDeckView.userInteractionEnabled = true
        
        self.firstTimeJudgingHand = true
    }
    
    func discardToPiles()
    {
        if self.discardPlayerCards.count > 0
        {
            self.playerDiscardView.addCards(self.discardPlayerCards)
            self.playerDiscardView.populateCardViews()
        }
        
        if self.discardAICards.count > 0
        {
            self.aiDiscardView.addCards(self.discardAICards)
            self.aiDiscardView.populateCardViews()
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
    
    
    //# MARK: - End of Game
    
    
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
    
    
    //# MARK: - IBAction
    
    
}
