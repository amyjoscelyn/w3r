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

let play_game_string = "BEGIN GAME"
let ready_string = "READY"
let ready2_string = "READY!"
let ready3_string = "READY!!"
let war_string = "WAR"
let war2_string = "WAR!"
let end_round_string = "END ROUND"
let game_over_string = "GAME OVER"

let corner_radius: CGFloat = 8
let border_width: CGFloat = 1

class GameViewController: UIViewController, HorizontallyReorderableStackViewDelegate
{
    var lastLocation: CGPoint = CGPointMake(0, 0)
    
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
    
    @IBOutlet weak var centerGameView: UIView!
    @IBOutlet weak var gameOverView: GameOver!
    
    private var temporaryView: UIView!
    
    var roundHasBegun = false
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
        card.layer.borderWidth = border_width
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
        
        self.playerDeckView.userInteractionEnabled = false
        
        self.playerHandStackView.reorderingEnabled = true
        
        //***************************************
        //for testing purposes, this code can be commented out
        self.ai1ClusterView.faceDown()
        self.ai2ClusterView.faceDown()
        self.ai3ClusterView.faceDown()
        //***************************************
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
//            print("Column 1 needs to be judged")
            let result = self.judgeColumn(first_column)
            
            if result == war_result_string
            {
//                print("Column 1 has a war!")
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
//            print("Column 2 needs to be judged")
            let result = self.judgeColumn(second_column)
            
            if result == war_result_string
            {
//                print("Column 2 has a war!")
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
//            print("Column 3 needs to be judged")
            let result = self.judgeColumn(third_column)
            
            if result == war_result_string
            {
//                print("Column 3 has a war!")
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
        //for some reason, this chunk of code doesn't work correctly, but it is necessary in order to make the emoji results appear... hm.
        if self.winnerOfHand == ""
        {
            let winner = self.game.winnerOfHand()
            print("Winner of hand: \(winner)")
            self.winnerOfHand = winner
            //winner is either player_string or ai_string
            //except it's always ai_string, because the amount of columns a player has won is always 0
            return
        }
        
        //save/discard all cards
        self.endRound()
        
        //ending the game
        let isGameOver = self.game.isGameOver()
        if isGameOver == true
        {
            self.gameIsOver = isGameOver
        }
        
        if self.gameIsOver == true
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
            self.gameIsOver = true
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
    
    func prepGame()
    {
        //        print("#6 (resetGame)")
        self.aiDeckView.faceUp = false
        self.playerDeckView.faceUp = false
        
        self.clearAllWarCardViewsAndTempHands()
    }

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
        print("Game is over! (\(self.gameIsOver))")
        print("Player cards remaining: \(self.game.player.deck.cards.count)")
        print("AI cards remaining: \(self.game.aiPlayer.deck.cards.count)")
        
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
        
        //move all cards in deck to discard
        //discard them
        
        self.game.resetGame()
        
        self.gameIsOver = false
        self.gameOverView.hidden = true
        
        self.cardsRemaining()
    }

    
    //# MARK: - User Interaction
    
    
    func handleDeckPanGesture(panGesture: UIPanGestureRecognizer)
    {
        if panGesture.state == UIGestureRecognizerState.Began
        {
            self.lastLocation = panGesture.locationInView(self.view!)
            
            //self.prepareForPan
            // Configure the temporary view
            self.temporaryView = self.playerDeckView.snapshotViewAfterScreenUpdates(true)
            self.temporaryView.frame = self.playerDeckView.frame
            self.temporaryView.center = self.lastLocation
            
            //if there are no cards remaining in deck when dealing:
            //make sure if there are cards after the round is over, the alpha = 1
            if !self.hasCardsInDeck()
            {
                self.playerDeckView.alpha = 0
            }
            
            self.temporaryView.alpha = 1.0
            self.temporaryView.layer.cornerRadius = corner_radius
            self.temporaryView.clipsToBounds = true
            
            self.view.addSubview(self.temporaryView)
        }
        if panGesture.state == UIGestureRecognizerState.Changed
        {
            //Drag the temporaryView
            let translation = panGesture.translationInView(self.view!)
            self.temporaryView.center = CGPointMake(self.lastLocation.x + translation.x, self.lastLocation.y + translation.y)
            
            let cardCluster2 = self.playerHandStackView.arrangedSubviews[1] as! CardCluster
            
            let yPoint: CGFloat = 450.0
            
            if self.temporaryView.center.y <= yPoint && cardCluster2.baseCardView.hidden == true && self.roundHasBegun == false
            {
                self.dealHand()
            }
        }
        if panGesture.state == UIGestureRecognizerState.Ended
        {
            self.temporaryView.removeFromSuperview()
        }
    }
    
    func handleGeneralTapGesture(tapGesture: UITapGestureRecognizer)
    {
//        print("Tap!")
        
        self.playGame()
        
        //this should address where something is stilted in the winningConditions method... and later on it can show hints to people who get lost in the game ("Do this now!")
        //if waiting on war, play war
        //or maybe wars should be played when you tap on the column's card?
        //or maybe it should call winningConditions()?
    }
    
    func handleGameOverTapGesture(tapGesture: UITapGestureRecognizer)
    {
//        print("Tapped!!")
        if self.gameDataStore.hasDisplayedScores != true
        {
            self.gameOverView.displayScores()
        }
        else
        {
            self.resetTableau()
            self.gameDataStore.hasDisplayedScores = false
        }
    }
    
    
    //# MARK: - New Round
    
    
    func hasCardsInDeck() -> Bool
    {
        let playerDeckCount = self.game.player.deck.cards.count
        let cardsRemaining = playerDeckCount - 3
        
        return cardsRemaining > 0
    }
    
    func cardsRemaining()
    {
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
            self.playerDeckView.alpha = 1
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
    
    //# MARK: - Judge Round
    
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

    //# MARK: - End of Round

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
}
