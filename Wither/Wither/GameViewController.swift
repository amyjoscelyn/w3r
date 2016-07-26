//
//  GameViewController.swift
//  Wither
//
//  Created by Amy Joscelyn on 7/26/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController
{
    @IBOutlet weak var playerDeckView: CardView!
    @IBOutlet weak var playerDiscardView: CardView!
    
    @IBOutlet weak var aiDeckView: CardView!
    @IBOutlet weak var aiDiscardView: CardView!
    
    @IBOutlet weak var playerWar1View: CardView!
    @IBOutlet weak var playerWar1AView: CardView!
    @IBOutlet weak var playerWar1BView: CardView!
    @IBOutlet weak var playerWar1CView: CardView!
    
    @IBOutlet weak var player1ClusterView: CardCluster!
    @IBOutlet weak var player2ClusterView: CardCluster!
    @IBOutlet weak var player3ClusterView: CardCluster!
    @IBOutlet weak var ai1ClusterView: CardCluster!
    @IBOutlet weak var ai2ClusterView: CardCluster!
    @IBOutlet weak var ai3ClusterView: CardCluster!
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var war1ResultLabel: UILabel!
    @IBOutlet weak var war2ResultLabel: UILabel!
    @IBOutlet weak var war3ResultLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setCardClusters()
    }
    
    func setCardClusters()
    {
        self.player1ClusterView.setPlayerAndColumn("Player", column: "1")
        self.player2ClusterView.setPlayerAndColumn("Player", column: "2")
        self.player3ClusterView.setPlayerAndColumn("Player", column: "3")
        
        self.ai1ClusterView.setPlayerAndColumn("AI", column: "1")
        self.ai2ClusterView.setPlayerAndColumn("AI", column: "2")
        self.ai3ClusterView.setPlayerAndColumn("AI", column: "3")
        
//        self.populateCardClusters()
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
}
