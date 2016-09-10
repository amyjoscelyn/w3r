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
let blank_emoji = "  "

let first_column = "1"
let second_column = "2"
let third_column = "3"

let player_string = "Player"
let ai_string = "AI"

let save_string = "Save"
let discard_string = "Discard"

//hopefully I won't need any of these
let play_game_string = "BEGIN GAME"
let ready_string = "READY"
let ready2_string = "READY!"
let ready3_string = "READY!!"
let war_string = "WAR"
let war2_string = "WAR!"
let end_round_string = "END ROUND"
let game_over_string = "GAME OVER"

let corner_radius: CGFloat = 8
let border_width: CGFloat = 1.5

class GameViewController: UIViewController, HorizontallyReorderableStackViewDelegate
{
    var lastLocation: CGPoint = CGPointMake(0, 0)
    var deckOriginalCenter: CGPoint = CGPointMake(0, 0)
    
    @IBOutlet weak var playerDeckView: CardView!
    @IBOutlet weak var playerDiscardView: DiscardPile!
    @IBOutlet weak var aiDeckView: CardView!
    @IBOutlet weak var aiDiscardView: DiscardPile!
    
    var cardViews: [CardView] = []
    
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
    @IBOutlet weak var gameOverView: GameOver!
    
//    var currentWarColumnToResolve: String = ""
//    var columnOfWar: String = ""
//    var isWar1 = false
//    var isWar2 = false
//    var isWar3 = false
    var roundHasBegun = false
//    var firstTimeJudgingHand = true
    var winnerOfHand = ""
    var gameIsOver = false
    
    let gameDataStore = GameDataStore.sharedInstance
    let game = Game.init()
    
    //# MARK: - Game Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.cardViewArray()
        self.createGameSpace()
//        self.startGame()
        self.newGame()
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func createGameSpace()
    {
        //        print("#2 (createGameSpace)")
        
        self.setCardClusters()
        
        self.playerDiscardView.setPlayer(player_string)
        self.aiDiscardView.setPlayer(ai_string)
        self.playerDiscardView.clearCards()
        self.aiDiscardView.clearCards()
        self.playerDiscardView.rotateViews()
        self.aiDiscardView.rotateViews()
        
//        self.customizeButton(self.playGameButton) //hopefully I won't need this
        //        self.customizeButton(self.settingsButton)
        //        self.customizeButton(self.skipWarButton)
        
        self.war1ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22) //magic number
        self.war2ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22)
        self.war3ResultLabel.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 19/22)
        
        self.deckOriginalCenter = self.playerDeckView.center
        
        self.panGestures()
        self.tapGestures()
        
        self.playGameButton.setTitle("", forState: UIControlState.Normal)
        self.playGameButton.enabled = false //hopefully won't need this
        
        self.centerGameView.layer.cornerRadius = corner_radius
        self.centerGameView.clipsToBounds = true
        
        self.gameOverView.layer.cornerRadius = 6
        self.gameOverView.layer.borderWidth = 3
        self.gameOverView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.gameOverView.clipsToBounds = true
        self.gameOverView.hidden = true
        
        self.cardViewArray()
        
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
            
            cardCluster.rotateCardViews()
        }
        
        self.ai1ClusterView.setColumn(first_column)
        self.ai2ClusterView.setColumn(second_column)
        self.ai3ClusterView.setColumn(third_column)
        
        self.ai1ClusterView.rotateCardViews()
        self.ai2ClusterView.rotateCardViews()
        self.ai3ClusterView.rotateCardViews()
        
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
    
//    func customizeButton(button: UIButton)
//    {
//        //        print("#3 (customizeButton)")
//        button.layer.cornerRadius = corner_radius
//        button.layer.borderWidth = border_width
//        button.layer.borderColor = UIColor.whiteColor().CGColor
//        button.clipsToBounds = true
//        
//        button.titleLabel?.font = UIFont.systemFontOfSize(CardView.fontSizeForScreenWidth() * 17/22)
//    }
    
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
    
    func panGestures()
    {
        //        print("#4 (panGestures)")
        let deckPanGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handleDeckPanGesture))
        self.playerDeckView.addGestureRecognizer(deckPanGesture)
        self.playerDeckView.userInteractionEnabled = true
    }
    
    func tapGestures()
    {
        let generalTapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleGeneralTapGesture))
        generalTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(generalTapGesture)
        self.view.userInteractionEnabled = true
        
        let gameOverTapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleGameOverTapGesture))
        gameOverTapGesture.numberOfTapsRequired = 1
        self.gameOverView.addGestureRecognizer(gameOverTapGesture)
        self.gameOverView.userInteractionEnabled = true
    }
    
    func customizeCardView(card: CardView)
    {
        card.layer.cornerRadius = 6
        card.layer.borderWidth = 3
        card.layer.borderColor = UIColor.darkGrayColor().CGColor
        card.clipsToBounds = true
    }
    
    
    //# MARK: - New Game
    
    
    func newGame()
    {
        //set up players with their decks/shuffle
        self.prepGame()
        //***************************************
        //for testing purposes, this code can be commented out
        self.game.startGame()
        //***************************************
    }
    
    func dealHand()
    {
        //deal hand
        //this is pan gesture recognizer territory
        self.roundHasBegun = true
        self.game.drawHands()
        self.cardsRemaining()
        self.populateHandWithCards()
        
        //            self.prepButtonWithTitle(ready_string)
        
        self.playerDeckView.userInteractionEnabled = false
        
        self.playerHandStackView.reorderingEnabled = true
        
        //***************************************
        //for testing purposes, this code can be commented out
        self.ai1ClusterView.faceDown()
        self.ai2ClusterView.faceDown()
        self.ai3ClusterView.faceDown()
        //***************************************
        
        //a tap now should call self.winningConditions()
    }
    
    func playGame()
    {       
        //if cards haven't been dealt to hand yet, nothing happens
        if self.ai1ClusterView.baseCardView.hidden == true
        {
            return
        }
        
        //if hand is dealt, flip cards over
        if self.ai1ClusterView.baseCardView.faceUp == false
        {
            self.ai1ClusterView.showCard()
            self.ai2ClusterView.showCard()
            self.ai3ClusterView.showCard()
        }
        
        //judge the round, one column at a time
        if self.war1ResultLabel.text == blank_emoji
        {
            print("Column 1 needs to be judged")
            let result = self.judgeColumn(first_column)
            
            if result == war_result_string
            {
                print("Column 1 has a war!")
                return
            }
        }
        else if self.war1ResultLabel.text == war_emoji
        {
            self.playWar(first_column)
            self.war1ResultLabel.text = blank_emoji
            return
        }
        
        if self.war2ResultLabel.text == blank_emoji
        {
            print("Column 2 needs to be judged")
            let result = self.judgeColumn(second_column)
            
            if result == war_result_string
            {
                print("Column 2 has a war!")
                return
            }
        }
        else if self.war2ResultLabel.text == war_emoji
        {
            self.playWar(second_column)
            self.war2ResultLabel.text = blank_emoji
            return
        }
        
        if self.war3ResultLabel.text == blank_emoji
        {
            print("Column 3 needs to be judged")
            let result = self.judgeColumn(third_column)
            
            if result == war_result_string
            {
                print("Column 3 has a war!")
                return
            }
        }
        else if self.war3ResultLabel.text == war_emoji
        {
            self.playWar(third_column)
            self.war3ResultLabel.text = blank_emoji
            return
        }
        
        //who wins the hand?
        if self.winnerOfHand == ""
        {
            let winner = self.game.winnerOfHand()
            print(winner)
            self.winnerOfHand = winner
            //winner is either player_string or ai_string
            return
        }
        
        //save/discard all cards
        self.endRound()
        
        //ending the game
        let isGameOver = self.game.isGameOver()
        if isGameOver == true || self.gameIsOver == true
        {
            //game is over!
            self.endGame()
            return
        }
    }
    
    func judgeColumn(column: String) -> String
    {
//        let playerClusters = self.arrangedCardClusters()
//        let aiClusters = [ self.ai1ClusterView, self.ai2ClusterView, self.ai3ClusterView ]
        let resultLabels = [ self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel ]
        
        let columnCards = self.cardsToJudge(column)
        let result = self.game.resultOfColumnResolution(columnCards)
        
        var i = 4
        
        if column == first_column
        {
            i = 0
        }
        else if column == second_column
        {
            i = 1
        }
        else if column == third_column
        {
            i = 2
        }
        
        if result == win_result_string
        {
            //player wins!
            //save player cards
            //discard AI cards
            resultLabels[i].text = winning_emoji
            
//            self.game.savePlayerCards.appendContentsOf(playerClusters[i].cards)
//            self.game.discardAICards.appendContentsOf(aiClusters[i].cards)
//            self.game.savePlayerCards.appendContentsOf(playerClusters[i].removeCards())
//            self.game.discardAICards.appendContentsOf(aiClusters[i].removeCards())
        }
        else if result == loss_result_string
        {
            //AI wins!
            //save AI cards
            //discard player cards
            resultLabels[i].text = loss_emoji
            
//            self.game.discardPlayerCards.appendContentsOf(playerClusters[i].cards)
//            self.game.saveAICards.appendContentsOf(aiClusters[i].cards)
        }
        else if result == war_result_string
        {
            //war... resolve!
            resultLabels[i].text = war_emoji //I might not even need this
            //does player have at least 1 card for war?  does AI?
            //*** if no, they lose entire hand!
            let canPlayWar = self.game.canPlayWar()
            
            if !canPlayWar
            {
//                game is over
//                self.endGame()
                self.gameIsOver = true
            }
        }
        
        resultLabels[i].hidden = false
        
        return result
    }
    
    func playWar(column: String)
    {
        if self.game.player.deck.cards.count > 0 && self.game.aiPlayer.deck.cards.count > 0
        {
            self.game.war()
            
            let clusters = self.arrangedCardClusters()
            
            let playerCardCluster: CardCluster
            let aiCardCluster: AICardCluster
            
            if column == first_column
            {
                playerCardCluster = clusters[0]
                aiCardCluster = self.ai1ClusterView
            }
            else if column == second_column
            {
                playerCardCluster = clusters[1]
                aiCardCluster = self.ai2ClusterView
            }
            else
            {
                playerCardCluster = clusters[2]
                aiCardCluster = self.ai3ClusterView
            }
            
            playerCardCluster.addCard(self.game.player.warCards.last!)
            aiCardCluster.addCard(self.game.aiPlayer.warCards.last!)
            self.populateCardClusters()
            
            self.cardsRemaining()
        }
        else
        {
            //game over?
            self.endGame()
//            self.gameIsOver = true
        }
    }
    
    func endRound()
    {
        self.playerDeckView.userInteractionEnabled = true
        
        self.discardOrSaveCards()
        self.discardToPiles()
        self.game.endRound()
        
        self.roundHasBegun = false
        self.winnerOfHand = ""
        
        self.clearAllWarCardViewsAndTempHands()
        self.cardsRemaining()
    }
    
    func discardOrSaveCards()
    {
        let playerClusters = self.arrangedCardClusters()
        let aiClusters = [ self.ai1ClusterView, self.ai2ClusterView, self.ai3ClusterView ]
        let resultLabels = [ self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel ]
        
        for i in 0..<resultLabels.count
        {
            let result = resultLabels[i]
            
            if result.text == winning_emoji
            {
                //player wins!
                //save player cards
                //discard AI cards
//                result.text = blank_emoji
                
                self.game.savePlayerCards.appendContentsOf(playerClusters[i].removeCards())
                self.game.discardAICards.appendContentsOf(aiClusters[i].removeCards())
            }
            else if result.text == loss_emoji
            {
                //AI wins!
                //save AI cards
                //discard player cards
//                result.text = blank_emoji
                
                self.game.discardPlayerCards.appendContentsOf(playerClusters[i].removeCards())
                self.game.saveAICards.appendContentsOf(aiClusters[i].removeCards())
            }
            else if self.gameIsOver == true
            {
                //result text has not been assigned, but it still needs to get shuffled back into the deck
                //it's automatically discarding now
                self.game.discardPlayerCards.appendContentsOf(playerClusters[i].removeCards())
                self.game.discardAICards.appendContentsOf(aiClusters[i].removeCards())
            }
        }
    }
    
    
//    func startGame()
//    {
//        self.playGameButton.setTitle("", forState: UIControlState.Normal)
//        self.playGameButton.enabled = false
//        
//        self.prepGame()
//        //***************************************
//        //for testing purposes, this code can be commented out
//        self.game.startGame()
//        //***************************************
//    }
//    
    func prepGame()
    {
        //        print("#6 (resetGame)")
        self.aiDeckView.faceUp = false
        self.playerDeckView.faceUp = false
        
        self.clearAllWarCardViewsAndTempHands()
//        
//        self.war1ResultLabel.hidden = true
//        self.war2ResultLabel.hidden = true
//        self.war3ResultLabel.hidden = true
        //        self.resolveWarGuideLabel.hidden = true
        //        self.skipWarButton.hidden = true
    }
//
    func clearAllWarCardViewsAndTempHands()
    {
        self.war1ResultLabel.text = blank_emoji
        self.war2ResultLabel.text = blank_emoji
        self.war3ResultLabel.text = blank_emoji
        
        self.populateCardClusters()
        self.game.warIsDone()
    }
    
    func endGame()
    {
        print("Game is over!")
        
        //score here!!!
        let scores = self.game.getScores()
        self.gameDataStore.updateScores(scores)
        
        self.gameOverView.displayLabelsWithInfo()
        self.gameOverView.hidden = false
    }
    
    func resetTableau()
    {
        print("Tableau will be reset!!!")
        
        self.endRound()

        self.game.resetGame()
        
        self.gameIsOver = false
        self.gameOverView.hidden = true
        
        self.cardsRemaining()
    }
//
//    
//    //# MARK: - User Interaction
//    
//    
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
            print(self.playerDeckView.center)
            
            let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
            
            let yPoint: CGFloat = 450.0 //when it reaches -100 on the 6s+ then it's closer to the center, but it jumps weirdly back to its original position as the hand is dealt.
            
            if self.playerDeckView.center.y <= yPoint && cardCluster2.baseCardView.hidden == true && self.roundHasBegun == false
            {
//                self.newRound()
                self.dealHand()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            self.playerDeckView.center = self.deckOriginalCenter
        }
    }
    
    func handleGeneralTapGesture(tapGesture: UITapGestureRecognizer)
    {
        print("Tap!")
        
        self.playGame()
        
        //this should address where something is stilted in the winningConditions method... and later on it can show hints to people who get lost in the game ("Do this now!")
        //if waiting on war, play war
        //or maybe wars should be played when you tap on the column's card?
        //or maybe it should call winningConditions()?
    }
    
    func handleGameOverTapGesture(tapGesture: UITapGestureRecognizer)
    {
        print("Tapped!!")
        
        self.resetTableau()
    }
    
//    func didReorderArrangedSubviews(arrangedSubviews: Array<UIView>)
//    {
//        var rearrangedBaseCards = Array<Card>()
//        for subview in arrangedSubviews {
//            let cardCluster = subview as! CardCluster
//            if let card = cardCluster.baseCardView.card {
//                rearrangedBaseCards.append(card)
//            }
//        }
//    }
//    
//    func canReorderSubview(subview: UIView) -> Bool
//    {
//        //here is where I tell it that I can/'t reorder the subviews
//        print("canReorderSubview called!!!!!")
//        
//        return true
//    }
//    
//    
//    //# MARK: - New Round
//    
//    
//    func newRound()
//    {
//        //        print("#8 (newRound)")
//        self.roundHasBegun = true
//        self.game.drawHands()
//        self.cardsRemaining()
//        
//        if self.game.player.hand.count == 3 && self.game.aiPlayer.hand.count == 3
//        {
//            self.populateHandWithCards()
//            
////            self.prepButtonWithTitle(ready_string)
//            
//            self.playerDeckView.userInteractionEnabled = false
//            
//            self.playerHandStackView.reorderingEnabled = true
//            
//            //***************************************
//            //for testing purposes, this code can be commented out
//            self.ai1ClusterView.faceDown()
//            self.ai2ClusterView.faceDown()
//            self.ai3ClusterView.faceDown()
//            //***************************************
//        }
//        else if self.game.player.hand.count > 0 || self.game.aiPlayer.hand.count > 0
//        {
//            //just draw a single card--fight down to the last
//            self.populateHandWithSingleCard()
//            
////            self.prepButtonWithTitle(ready3_string)
//        }
//        else
//        {
//            //game is over!!
//            print("game is over :(")
//            print("newRound deemed this game OVER!!!!!!!!!")
////            self.prepButtonWithTitle(game_over_string)
//        }
//    }
//    
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
//        let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
        
//        if playerDeckAndHandCount == 0 || aiDeckAndHandCount == 0 && cardCluster2.baseCardView.hidden
//        {
//            print("cardsRemaining deemed this game OVER!!!!!!!")
////            self.prepButtonWithTitle(game_over_string)
//            
//            //there are no cards to save or discard here... right?
//            print("ASSUMPTION: no cards need to be saved or discarded here, because there are none on the tableau... right?")
//            self.finalOutcomeZero()
//        }
    }
//
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
//
////    func prepButtonWithTitle(title: String)
////    {
////        //        print("#27 (prepButtonWithTitle)")
////        self.playGameButton.setTitle(title, forState: UIControlState.Normal)
////        self.playGameButton.enabled = true
////    }
//    
//    func populateHandWithSingleCard()
//    {
//        //        print("#10 (populateHandWithSingleCard)")
//        print("[populateHandWithSingleCard] player has \(self.game.player.deck.cards.count) cards in deck, AI has \(self.game.aiPlayer.deck.cards.count) cards")
//        
//        let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
//        
//        cardCluster2.addCard(self.game.player.hand[0])
//        self.ai2ClusterView.addCard(self.game.aiPlayer.hand[0])
//        
//        self.populateCardClusters()
//        
//        self.game.aiPlayer.hand.removeAll()
//        self.game.player.hand.removeAll()
//    }
//    
//    
//    //# MARK: - Pivot Point
//    
//    
////    @IBAction func playGameButtonTapped(button: UIButton)
////    {
////        let label = button.titleLabel?.text
////        //        print("#12 (playGameButtonTapped)")
////        if label == play_game_string
////        {
////            self.resetForNewGame()
////            self.startGame()
////        }
////        else if label == ready_string
////        {
////            //helper method?
////            self.ai1ClusterView.showCard()
////            self.ai2ClusterView.showCard()
////            self.ai3ClusterView.showCard()
////            
////            if self.firstTimeJudgingHand
////            {
////                self.firstTimeThroughHand()
////            }
////            self.determineWinnerOfHand() //if this method is going to be called in different places at different times, then maybe the methods it called should just be called straightaway instead.  This would be judgeRound()
////        }
////        else if label == ready2_string
////        { //the difference between ready, 2, and 3 can probably be switched to properties--you know, like new (standard) round, currently playing war, and final round.  or it's a number of case statements, like the ready2_string, but the property can be gameStatus: standard_round, or resolving_war, or final_round.  I like that.
////            let cardsToJudge = self.cardsToJudge(self.currentWarColumnToResolve)
////            let result = self.faceOffCards(cardsToJudge)
////            
////            if result != player_string && result != ai_string
////            {
////                self.playCurrentWar()
////            }
////            else
////            {
////                self.currentWarColumnToResolve = ""
////                self.determineWinnerOfHand() //if this method is going to be called in different places at different times, then maybe the methods it called should just be called straightaway instead.  This would be judgeRound()
////            }
////        }
////        else if label == ready3_string
////        {
////            self.ai2ClusterView.showCard()
////            self.determineWinnerOfHand() //if this method is going to be called in different places at different times, then maybe the methods it called should just be called straightaway instead.  This would be judgeFinalRound()
////        }
////        else if label == war_string
////        {
////            //set up for hand with single war
////            //            self.skipWarButton.hidden = true
////            //            self.resolveWarGuideLabel.hidden = true
////            self.hideWarLabel(self.columnOfWar)
////            self.playWar()
////        }
////        else if label == war2_string
////        {
////            //set up for hand with multiple wars
////            //            self.skipWarButton.hidden = true
////            //            self.resolveWarGuideLabel.hidden = true
////            
////            self.hideWarLabel(self.currentWarColumnToResolve)
////            self.playCurrentWar()
////        }
////        else if label == end_round_string
////        {
////            self.endRound()
////        }
////        else if label == game_over_string
////        {
////            self.endGame()
////        }
////    }
//    
//    
//    //# MARK: - Judge Round
//    
//    
//    func firstTimeThroughHand()
//    {
//        print("first time judging hand!!")
//        self.trackCards()
//        self.firstTimeJudgingHand = false
//    }
//    
//    func trackCards()
//    {
//        let cardClusters = self.arrangedCardClusters()
//        var cardValues: [Int] = []
//        
//        for cluster in cardClusters
//        {
//            let cardValue = cluster.baseCardView.card?.cardValue
//            cardValues.append(cardValue!)
//        }
//        
//        let maxCardValue = cardValues.maxElement()
//        let columnOfMaxCardValue = cardValues.indexOf(maxCardValue!)
//        
//        print("GameVC column with highest card: \(columnOfMaxCardValue!)")
//        
//        self.gameDataStore.playerCardTrackerArray.append(columnOfMaxCardValue!)
//    }
//    
//    func determineWinnerOfHand()
//    {
//        self.playerHandStackView.reorderingEnabled = false
//        
//        let cardCluster1 = self.playerHandStackView.arrangedSubviews[0] as! CardCluster
//        
//        if !cardCluster1.baseCardView.hidden
//        {
//            self.judgeRound()
//        }
//        else
//        {
//            self.judgeFinalRound()
//        }
//    }
//    
//    func judgeRound()
//    {
//        //        print("#14 (judgeRound)")
//        let cardsToJudge1 = self.cardsToJudge(first_column)
//        let cardsToJudge2 = self.cardsToJudge(second_column)
//        let cardsToJudge3 = self.cardsToJudge(third_column)
//        
//        let result1 = self.faceOffCards(cardsToJudge1)
//        let result2 = self.faceOffCards(cardsToJudge2)
//        let result3 = self.faceOffCards(cardsToJudge3)
//        
//        //            print("\(winnerOf1) won 1, \(winnerOf2) won 2, \(winnerOf3) won 3")
//        
//        self.awardRoundWithResult(result1, cardResult2: result2, cardResult3: result3)
//    }
//    
//    //should this go with the rest of the end game methods?
//    func judgeFinalRound()
//    {
//        //there is only one card up, #2
//        
//        print("~~~~~~~~cards in player hand: \(self.game.player.hand.count) \n ~~~~~~~~cards in ai hand: \(self.game.aiPlayer.hand.count)")
//        
//        let cardsToJudge = self.cardsToJudge(second_column)
//        let winner = self.faceOffCards(cardsToJudge)
//        
//        print("\(winner) won!!")
//        
//        self.awardFinalRoundWithResult(winner)
//    }
//    
    func cardsToJudge(column: String) -> [Card]
    {
        var playerCard: Card = Card.init(suit: "X", rank: "0")
        var aiCard: Card = Card.init(suit: "X", rank: "0")
        
        let clusters = self.arrangedCardClusters()
        
        if column == first_column
        {
            playerCard = clusters[0].cardToJudge()
            aiCard = self.ai1ClusterView.cardToJudge()
        }
        else if column == second_column
        {
            playerCard = clusters[1].cardToJudge()
            aiCard = self.ai2ClusterView.cardToJudge()
        }
        else if column == third_column
        {
            playerCard = clusters[2].cardToJudge()
            aiCard = self.ai3ClusterView.cardToJudge()
        }
        
//        switch column
//        {
//        case first_column:
//            playerCard = clusters[0].cardToJudge()
//            print("crash caused here, cardsToJudge, first_column, playerCard");
//            aiCard = self.ai1ClusterView.cardToJudge()
//            print("crash caused here, cardsToJudge, first_column, aiCard");
//        case second_column:
//            playerCard = clusters[1].cardToJudge()
//            print("crash caused here, cardsToJudge, second_column, playerCard");
//            aiCard = self.ai2ClusterView.cardToJudge()
//            print("crash caused here, cardsToJudge, second_column, aiCard");
//        default:
//            playerCard = clusters[2].cardToJudge()
//            print("crash caused here, cardsToJudge, third_column, playerCard");
//            aiCard = self.ai3ClusterView.cardToJudge()
//            print("crash caused here, cardsToJudge, third_column, aiCard");
//        }
        return [ playerCard, aiCard ]
    }
//
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
//
//    func faceOffCards(cards: [Card]) -> String
//    {
//        let playerCard = cards.first!
//        let aiPlayerCard = cards.last!
//        
//        return self.game.twoCardFaceOff(playerCard, aiPlayerCard: aiPlayerCard)
//    }
//    
//    func awardRoundWithResult(cardResult1: String, cardResult2: String, cardResult3: String)
//    {
//        //        print("#16 (awardRoundWithResult)")
//        let results = [cardResult1, cardResult2, cardResult3]
//        let resultLabels = [self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel]
//        
//        for i in 0..<results.count
//        {
//            let result = results[i]
//            
//            switch result
//            {
//            case player_string:
//                resultLabels[i].text = winning_emoji
//            case "AI":
//                resultLabels[i].text = loss_emoji
//            default:
//                resultLabels[i].text = war_emoji
//            }
//        }
//        
//        self.war1ResultLabel.hidden = false
//        self.war2ResultLabel.hidden = false
//        self.war3ResultLabel.hidden = false
//        
////        self.prepButtonWithTitle("")
//        
//        self.determineHandOutcome()
//    }
//    
//    func determineHandOutcome()
//    {
//        //        print("#18 (determineHandOutcome)")
//        
//        let resultsArray = [self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel]
//        
//        var winCount = 0
//        var lossCount = 0
//        var warCount = 0
//        
//        for result in resultsArray
//        {
//            if result.text == winning_emoji
//            {
//                winCount += 1
//            }
//            else if result.text == loss_emoji
//            {
//                lossCount += 1
//            }
//            else if result.text == war_emoji
//            {
//                warCount += 1
//            }
//        }
//        
//        if winCount == 3
//        {
//            self.outcomeOne()
//        }
//        else if lossCount == 3
//        {
//            self.outcomeTwo()
//        }
//        else if winCount == 2
//        {
//            if lossCount == 1
//            {
//                self.outcomeThree()
//            }
//            else
//            {
//                self.outcomeFour()
//            }
//        }
//        else if lossCount == 2
//        {
//            if winCount == 1
//            {
//                self.outcomeFive()
//            }
//            else
//            {
//                self.outcomeSix()
//            }
//        }
//        else
//        {
//            self.outcomeSeven(warCount, winCount: winCount)
//        }
//        
//        //        print("crowns: \(winCount), X's: \(lossCount), swords: \(warCount)")
//    }
//    
//    
//    //# MARK: - Hand Outcomes
//    
//    
//    func outcomeOne()
//    {
//        self.saveAllCards(player_string)
//        self.discardAllCards(ai_string)
//        
////        self.prepButtonWithTitle(end_round_string)
//    }
//    
//    func outcomeTwo()
//    {
//        self.discardAllCards(player_string)
//        self.saveAllCards(ai_string)
//        
////        self.prepButtonWithTitle(end_round_string)
//    }
//    
//    func outcomeThree()
//    {
//        let column = self.columnOfResult(loss_emoji)
//        
//        switch column
//        {
//        case first_column:
//            self.playerHandActions([ discard_string, save_string, save_string ])
//        case second_column:
//            self.playerHandActions([ save_string, discard_string, save_string ])
//        default:
//            self.playerHandActions([ save_string, save_string, discard_string ])
//        }
//        
//        self.discardAllCards(ai_string)
//        
////        self.prepButtonWithTitle(end_round_string)
//    }
//    
//    func outcomeFour()
//    {
//        let column = self.columnOfResult(war_emoji)
//        let warValue = self.cardValueOfWar(column)
//        //                print("AI has lost, but gets to pass on the war.")
//        let willResolveWar = self.game.aiPlayer.shouldResolveWar(warValue)
//        
//        if willResolveWar
//        {
//            self.prepForSingleWar(column)
//        }
//        else
//        {
//            print("AI PASSES ON WAR.")
//            
//            self.saveAllCards(player_string)
//            
//            switch column
//            {
//            case first_column:
//                self.aiHandActions([ save_string, discard_string, discard_string ])
//            case second_column:
//                self.aiHandActions([ discard_string, save_string, discard_string ])
//            default:
//                self.aiHandActions([ discard_string, discard_string, save_string ])
//            }
//            
////            self.prepButtonWithTitle(end_round_string)
//        }
//    }
//    
//    func outcomeFive()
//    {
//        let column = self.columnOfResult(winning_emoji)
//        
//        switch column
//        {
//        case first_column:
//            self.aiHandActions([ discard_string, save_string, save_string ])
//        case second_column:
//            self.aiHandActions([ save_string, discard_string, save_string ])
//        default:
//            self.aiHandActions([ save_string, save_string, discard_string ])
//        }
//        
//        self.discardAllCards(player_string)
//        
////        self.prepButtonWithTitle(end_round_string)
//    }
//    
//    func outcomeSix()
//    {
//        //                print("playing the war now...")
//        let column = self.columnOfResult(war_emoji)
//        
//        //                self.skipWarButton.hidden = false
//        //                self.resolveWarGuideLabel.hidden = false
//        
//        self.prepForSingleWar(column)
//    }
//    
//    func outcomeSeven(warCount: Int, winCount: Int)
//    {
//        var column = ""
//        
//        if warCount == 1
//        {
//            column = self.columnOfResult(war_emoji)
//            self.prepForSingleWar(column)
//        }
//        else if warCount == 2
//        {
//            if winCount == 1
//            {
//                column = self.columnOfResult(winning_emoji)
//            }
//            else
//            {
//                column = self.columnOfResult(loss_emoji)
//            }
//            
//            var firstWar = 0
//            var secondWar = 0
//            
//            switch column
//            {
//            case first_column:
//                //wars are 2 and 3
//                firstWar = self.cardValueOfWar(second_column)
//                secondWar = self.cardValueOfWar(third_column)
//                
//                if firstWar >= secondWar || self.columnOfWar == second_column
//                {
//                    self.prepForSelectedWar(second_column)
//                }
//                else
//                {
//                    self.prepForSelectedWar(third_column)
//                }
//            case second_column:
//                //wars are 1 and 3
//                firstWar = self.cardValueOfWar(first_column)
//                secondWar = self.cardValueOfWar(third_column)
//                
//                if firstWar >= secondWar || self.columnOfWar == first_column
//                {
//                    self.prepForSelectedWar(first_column)
//                }
//                else
//                {
//                    self.prepForSelectedWar(third_column)
//                }
//            default:
//                //wars are 1 and 2
//                firstWar = self.cardValueOfWar(first_column)
//                secondWar = self.cardValueOfWar(second_column)
//                
//                if firstWar >= secondWar || self.columnOfWar == first_column
//                {
//                    self.prepForSelectedWar(first_column)
//                }
//                else
//                {
//                    self.prepForSelectedWar(second_column)
//                }
//            }
//        }
//        else //there are three wars!  how rare :)
//        {
//            let firstWar = self.cardValueOfWar(first_column)
//            let secondWar = self.cardValueOfWar(second_column)
//            let thirdWar = self.cardValueOfWar(third_column)
//            
//            let warValues = [ firstWar, secondWar, thirdWar ]
//            
//            if warValues.maxElement() == firstWar
//            {
//                self.prepForSelectedWar(first_column)
//            }
//            else if warValues.maxElement() == secondWar
//            {
//                self.prepForSelectedWar(second_column)
//            }
//            else
//            {
//                self.prepForSelectedWar(third_column)
//            }
//        }
//    }
//    
//    
//    //# MARK: - Fate of Cards
//    
//    
//    func saveAllCards(player: String)
//    {
//        //        print("#21 (saveAllCards)")
//        var cardsToSave: [Card] = []
//        
//        if player == player_string
//        {
//            for subview in self.playerHandStackView.arrangedSubviews
//            {
//                let cardCluster = subview as! CardCluster
//                cardsToSave.appendContentsOf(cardCluster.removeCards())
//            }
//            self.game.savePlayerCards.appendContentsOf(cardsToSave)
//        }
//        else if player == ai_string
//        {
//            cardsToSave.appendContentsOf(self.ai1ClusterView.removeCards())
//            cardsToSave.appendContentsOf(self.ai2ClusterView.removeCards())
//            cardsToSave.appendContentsOf(self.ai3ClusterView.removeCards())
//            
//            self.game.saveAICards.appendContentsOf(cardsToSave)
//        }
//    }
//    
//    func discardAllCards(player: String)
//    {
//        //        print("#22 (discardAllCards)")
//        var cardsToDiscard: [Card] = []
//        
//        if player == player_string
//        {
//            //cardsToDiscard.appendContentsOf(self.game.player.warCards)
//            //WHAT AM I USING THIS GAME.WARCARDS METHOD FOR THEN?!?!?!?!
//            
//            for subview in self.playerHandStackView.arrangedSubviews
//            {
//                let cardCluster = subview as! CardCluster
//                cardsToDiscard.appendContentsOf(cardCluster.removeCards())
//            }
//            self.game.discardPlayerCards.appendContentsOf(cardsToDiscard)
//        }
//        else if player == ai_string
//        {
//            cardsToDiscard.appendContentsOf(self.ai1ClusterView.removeCards())
//            cardsToDiscard.appendContentsOf(self.ai2ClusterView.removeCards())
//            cardsToDiscard.appendContentsOf(self.ai3ClusterView.removeCards())
//            
//            self.game.discardAICards.appendContentsOf(cardsToDiscard)
//        }
//    }
//    
//    func columnOfResult(result: String) -> String
//    {
//        //        print("#20 (columnOfResult)")
//        var column = ""
//        
//        if self.war1ResultLabel.text == result
//        {
//            column = first_column
//        }
//        if self.war2ResultLabel.text == result
//        {
//            column = second_column
//        }
//        if self.war3ResultLabel.text == result
//        {
//            column = third_column
//        }
//        
//        return column
//    }
//    
//    func playerHandActions(actions: [String])
//    {
//        let action1 = actions[0]
//        let action2 = actions[1]
//        let action3 = actions[2]
//        
//        switch action1
//        {
//        case save_string:
//            self.saveSingleCard(player_string, column: first_column)
//        default:
//            self.discardSingleCard(player_string, column: first_column)
//        }
//        switch action2
//        {
//        case save_string:
//            self.saveSingleCard(player_string, column: second_column)
//        default:
//            self.discardSingleCard(player_string, column: second_column)
//        }
//        switch action3
//        {
//        case save_string:
//            self.saveSingleCard(player_string, column: third_column)
//        default:
//            self.discardSingleCard(player_string, column: third_column)
//        }
//    }
//    
//    func aiHandActions(actions: [String])
//    {
//        let action1 = actions[0]
//        let action2 = actions[1]
//        let action3 = actions[2]
//        
//        switch action1
//        {
//        case save_string:
//            saveSingleCard(ai_string, column: first_column)
//        default:
//            discardSingleCard(ai_string, column: first_column)
//        }
//        switch action2
//        {
//        case save_string:
//            saveSingleCard(ai_string, column: second_column)
//        default:
//            discardSingleCard(ai_string, column: second_column)
//        }
//        switch action3
//        {
//        case save_string:
//            saveSingleCard(ai_string, column: third_column)
//        default:
//            discardSingleCard(ai_string, column: third_column)
//        }
//    }
//    
//    func saveSingleCard(player: String, column: String)
//    {
//        //        print("#23 (saveSingleCard)")
//        let clusters = self.arrangedCardClusters()
//        
//        if player == player_string
//        {
//            switch column
//            {
//            case first_column:
//                let playerCluster1 = clusters[0]
//                self.game.savePlayerCards.appendContentsOf(playerCluster1.removeCards())
//            case second_column:
//                let playerCluster2 = clusters[1]
//                self.game.savePlayerCards.appendContentsOf(playerCluster2.removeCards())
//            default:
//                let playerCluster3 = clusters[2]
//                self.game.savePlayerCards.appendContentsOf(playerCluster3.removeCards())
//            }
//        }
//        else if player == ai_string
//        {
//            switch column
//            {
//            case first_column:
//                self.game.saveAICards.appendContentsOf(self.ai1ClusterView.removeCards())
//            case second_column:
//                self.game.saveAICards.appendContentsOf(self.ai2ClusterView.removeCards())
//            default:
//                self.game.saveAICards.appendContentsOf(self.ai3ClusterView.removeCards())
//            }
//        }
//    }
//    
//    func discardSingleCard(player: String, column: String)
//    {
//        //        print("#24 (discardSingleCard)")
//        let clusters = self.arrangedCardClusters()
//        
//        if player == player_string
//        {
//            switch column
//            {
//            case first_column:
//                let playerCluster1 = clusters[0]
//                self.game.discardPlayerCards.appendContentsOf(playerCluster1.removeCards())
//            case second_column:
//                let playerCluster2 = clusters[1]
//                self.game.discardPlayerCards.appendContentsOf(playerCluster2.removeCards())
//            default:
//                let playerCluster3 = clusters[2]
//                self.game.discardPlayerCards.appendContentsOf(playerCluster3.removeCards())
//            }
//        }
//        else if player == ai_string
//        {
//            switch column
//            {
//            case first_column:
//                self.game.discardAICards.appendContentsOf(self.ai1ClusterView.removeCards())
//            case second_column:
//                self.game.discardAICards.appendContentsOf(self.ai2ClusterView.removeCards())
//            default:
//                self.game.discardAICards.appendContentsOf(self.ai3ClusterView.removeCards())
//            }
//        }
//    }
//    
//    
//    //# MARK: - Wars
//    
//    
//    func cardValueOfWar(column: String) -> Int
//    {
//        //        print("#25 (cardValueOfWar)")
//        switch column
//        {
//        case first_column:
//            print("crash caused here, cardValueOfWar, first_column")
//            return self.ai1ClusterView.cardToJudge().cardValue
//        case second_column:
//            return self.ai2ClusterView.cardToJudge().cardValue
//        default:
//            return self.ai3ClusterView.cardToJudge().cardValue
//        }
//    }
//    
//    func prepForSingleWar(column: String)
//    {
//        //        print("#26 (prepForWar)")
//        self.columnOfWar = column
//        
//        switch column
//        {
//        case first_column:
//            self.isWar1 = true
//        case second_column:
//            self.isWar2 = true
//        default:
//            self.isWar3 = true
//        }
//        
////        self.prepButtonWithTitle(war_string)
//    }
//    
//    func prepForSelectedWar(column: String)
//    {
//        self.currentWarColumnToResolve = column
//        
//        self.isWar1 = false
//        self.isWar2 = false
//        self.isWar3 = false
//        
////        self.prepButtonWithTitle(war2_string)
//    }
//    
//    func hideWarLabel(column: String)
//    {
//        //        print("#13 (hideWarLabel)")
//        switch column
//        {
//        case first_column:
//            self.war1ResultLabel.text = "  "
//        case second_column:
//            self.war2ResultLabel.text = "  "
//        default:
//            self.war3ResultLabel.text = "  "
//        }
//    }
//    
//    func playWar()
//    {
//        //        print("#29 (playWarInColumn)")
//        if self.game.player.deck.cards.count > 0 && self.game.aiPlayer.deck.cards.count > 0
//        {
//            self.game.war()
//            
//            let clusters = self.arrangedCardClusters()
//            
//            let playerCardCluster: CardCluster
//            let aiCardCluster: AICardCluster
//            
//            if self.isWar1
//            {
//                playerCardCluster = clusters[0]
//                aiCardCluster = self.ai1ClusterView
//                
//                self.isWar1 = false
//            }
//            else if self.isWar2
//            {
//                playerCardCluster = clusters[1]
//                aiCardCluster = self.ai2ClusterView
//                
//                self.isWar2 = false
//            }
//            else //self.isWar3
//            {
//                playerCardCluster = clusters[2]
//                aiCardCluster = self.ai3ClusterView
//                
//                self.isWar3 = false
//            }
//            
//            playerCardCluster.addCard(self.game.player.warCards.last!)
//            aiCardCluster.addCard(self.game.aiPlayer.warCards.last!)
//            self.populateCardClusters()
//            
//            self.playGameButton.setTitle(ready_string, forState: UIControlState.Normal) //why is this, and it's partner in playCurrentWar(), not the prepButtonWithTitle method?  is it just because of the enable clause at the end?
//            
//            //I think I should make all self.isWar# false here
//            //but I also have them set as false right above
//            self.isWar1 = false
//            self.isWar2 = false
//            self.isWar3 = false
//            
//            self.cardsRemaining()
//        }
//        else
//        {
//            print("playWar deemed this game OVER!!!!!!!!!")
////            self.prepButtonWithTitle(game_over_string)
//            
//            //we have an entire war here we were in the midst of!  plenty of cards to save or discard
//            self.finalOutcomeZero()
//        }
//    }
//
//    func playCurrentWar()
//    {
//        if self.game.player.deck.cards.count > 0 && self.game.aiPlayer.deck.cards.count > 0
//        {
//            self.game.war()
//            
//            let clusters = self.arrangedCardClusters()
//            
//            let playerCardCluster: CardCluster
//            let aiCardCluster: AICardCluster
//            
//            switch self.currentWarColumnToResolve
//            {
//            case first_column:
//                playerCardCluster = clusters[0]
//                aiCardCluster = self.ai1ClusterView
//            case second_column:
//                playerCardCluster = clusters[1]
//                aiCardCluster = self.ai2ClusterView
//            default:
//                playerCardCluster = clusters[2]
//                aiCardCluster = self.ai3ClusterView
//            }
//            
//            playerCardCluster.addCard(self.game.player.warCards.last!)
//            aiCardCluster.addCard(self.game.aiPlayer.warCards.last!)
//            self.populateCardClusters()
//            
//            self.playGameButton.setTitle(ready2_string, forState: UIControlState.Normal)
//        }
//        else
//        {
//            print("playCurrentWar deemed this game OVER!!!!!!!!!")
//            
//            //involved in big war, can't resolve!!
//            self.finalOutcomeZero()
////            self.prepButtonWithTitle(game_over_string)
//        }
//        self.cardsRemaining()
//    }
//    
//    
//    //# MARK: - End of Round
//    
//    
//    func endRound()
//    {
//        //        print("#28 (endRound)")
//        
//        //print("Player saves \(self.savePlayerCards.count) cards and discards \(self.discardPlayerCards.count) cards, AI saves \(self.saveAICards.count) cards and discards \(self.discardAICards.count) cards.")
//        
//        self.clearView()
//        
//        self.playGameButton.setTitle("", forState: UIControlState.Normal)
//        self.playGameButton.enabled = false
//        
//        self.roundHasBegun = false
//        self.playerDeckView.userInteractionEnabled = true
//        
//        self.firstTimeJudgingHand = true
//    }
//    
//    func clearView()
//    {
//        self.war1ResultLabel.text = ""
//        self.war2ResultLabel.text = ""
//        self.war3ResultLabel.text = ""
//        self.columnOfWar = ""
//        
//        self.discardToPiles()
//        self.game.endRound()
//        self.clearAllWarCardViewsAndTempHands()
//        self.cardsRemaining()
//    }
//    
    func discardToPiles()
    {
        if self.game.discardPlayerCards.count > 0
        {
            self.playerDiscardView.addCards(self.game.discardPlayerCards)
            self.playerDiscardView.populateCardViews()
        }
        
        if self.game.discardAICards.count > 0
        {
            self.aiDiscardView.addCards(self.game.discardAICards)
            self.aiDiscardView.populateCardViews()
        }
        
        if self.gameIsOver == true
        {
            self.playerDiscardView.emptyDiscardPile()
            self.aiDiscardView.emptyDiscardPile()
        }
    }
//
//    func awardFinalRoundWithResult(cardResult: String)
//    {
//        //        print("#17 (awardFinalRoundWithResult)")
//        switch cardResult
//        {
//        case player_string:
//            self.war2ResultLabel.text = winning_emoji
//        case "AI":
//            self.war2ResultLabel.text = loss_emoji
//        default:
//            self.war2ResultLabel.text = war_emoji
//        }
//        self.war2ResultLabel.hidden = false
//        
////        self.prepButtonWithTitle("")
//        
//        self.determineFinalOutcome(cardResult)
//    }
//    
//    func determineFinalOutcome(result: String)
//    {
//        switch result
//        {
//        case winning_emoji:
//            self.finalOutcomeOne()
//        case loss_emoji:
//            self.finalOutcomeTwo()
//        default:
//            self.finalOutcomeThree()
//            if self.game.player.deck.cards.count > 1 && self.game.aiPlayer.deck.cards.count > 1
//            {
//                //play can proceed
//                self.finalOutcomeThree()
//                //repeat this method!!
//            }
//            else if self.game.player.deck.cards.count == 1 && self.game.aiPlayer.deck.cards.count == 1
//            {
//                //no cards left, war can't be resolved/tie
//                self.finalOutcomeFour()
//            }
//            else if self.game.player.deck.cards.count == 1
//            {
//                //player can't resolve war, no cards left
//                self.finalOutcomeFive()
//            }
//            else if self.game.aiPlayer.deck.cards.count == 1
//            {
//                //ai can't resolve war, no cards left
//                self.finalOutcomeSix()
//            }
//        }
//    }
//    
//    func finalOutcomeZero()
//    {
//        //no cards left to play!
//        //discard and save cards as appropriate
//        self.fateOfCardsDuringFinalRound()
//        
////        self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func finalOutcomeOne()
//    {
//        self.saveSingleCard(player_string, column: second_column)
//        self.discardSingleCard(ai_string, column: second_column)
//        
////        self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func finalOutcomeTwo()
//    {
//        self.saveSingleCard(ai_string, column: second_column)
//        self.discardSingleCard(player_string, column: second_column)
//        
////        self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func finalOutcomeThree()
//    {
//        self.prepForSingleWar(second_column)
//    }
//    
//    func finalOutcomeFour()
//    {
//        self.saveSingleCard(player_string, column: second_column)
//        self.saveSingleCard(ai_string, column: second_column)
//        //tie!  retreat or both lose?  I like the thought of them shaking hands and suspending the war
//        print("Both soldiers shake hands, knowing there is no backup.  The war has been suspended.")
//        //GAME IS OVER
//        print("GAME IS OVER. NO BACKUP FOR WAR BY BOTH PLAYERS.  TIE!")
//        print("finalOutcomeFour deemed this game OVER!!!!!!!!")
//        //                self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func finalOutcomeFive()
//    {
//        //automatically lose
//        self.saveSingleCard(player_string, column: second_column)
//        self.discardSingleCard(ai_string, column: second_column)
//        //GAME IS OVER
//        print("GAME IS OVER. PLAYER ONLY HAS ONE CARD LEFT.")
//        print("finalOutcomeFive deemed this game OVER!!!!!!!!")
////        self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func finalOutcomeSix()
//    {
//        //automatically win
//        self.saveSingleCard(ai_string, column: second_column)
//        self.discardSingleCard(player_string, column: second_column)
//        //GAME IS OVER
//        print("GAME IS OVER.  AI ONLY HAS ONE CARD LEFT.")
//        print("finalOutcomeSix deemed this game OVER!!!!!!!!")
////        self.prepButtonWithTitle(game_over_string)
//    }
//    
//    func fateOfCardsDuringFinalRound()
//    {
//        let cardCluster1 = self.playerHandStackView.arrangedSubviews[0] as! CardCluster
//        
//        if !cardCluster1.baseCardView.hidden //we have three columns in play
//        {
////            let playerCardClusters = self.playerHandStackView.arrangedSubviews
////            let aiCardClusters = [ self.ai1ClusterView, self.ai2ClusterView, self.ai3ClusterView ]
//            let columnResultLabels = [ self.war1ResultLabel, self.war2ResultLabel, self.war3ResultLabel ]
//            
//            let columns = [ first_column, second_column, third_column ]
//            
//            for i in 0..<columns.count
//            {
////                let playerCluster = playerCardClusters[i] as! CardCluster
////                let aiCluster = aiCardClusters[i]
//                let result = columnResultLabels[i]
//                let column = columns[i]
//                
//                if result == winning_emoji
//                {
//                    self.saveSingleCard(player_string, column: column)
//                    self.discardSingleCard(ai_string, column: column)
//                }
//                else if result == loss_emoji
//                {
//                    self.discardSingleCard(player_string, column: column)
//                    self.saveSingleCard(ai_string, column: column)
//                }
//                else
//                {
//                    //... it depends on the state of remaining cards
//                }
//            }
//        }
//        else
//        {
//            //we only have one column in play
//        }
//    }
//    
//    
//    //# MARK: - End of Game
//    
//    
//    func endGame()
//    {
//        //        print("#31 (endGame)")
//        print("The game is over.")
//        
//        self.calculateScoreAndWinner()
//        
//        self.clearView()
//        
////        self.prepButtonWithTitle(play_game_string)
//    }
//    
//    func calculateScoreAndWinner() //tally points
//    {
//        let playerPoints = self.game.player.deck.cards.count
//        let aiPoints = self.game.aiPlayer.deck.cards.count
//        
//        var winner = ""
//        
//        if playerPoints > aiPoints
//        {
//            winner = player_string
//        }
//        else if aiPoints > playerPoints
//        {
//            winner = ai_string
//        }
//        else
//        {
//            winner = "There is no winner."
//        }
//        
//        print("Player has \(playerPoints) points, AI has \(aiPoints) points.  The winner is: \(winner)")
//    }
//    
//    func resetForNewGame()
//    {
//        self.clearView()
//        self.game.resetGame()        
//    }
    
    
    //# MARK: - IBAction
    
    
}
