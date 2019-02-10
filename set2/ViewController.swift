//
//  ViewController.swift
//  set2
//
//  Created by Anthony Mackay on 2/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var setGame = SetGame()

    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        setGame.dealStartingCards()
        drawCardsInPlay()
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
        setGame.dealThreeCards()
        drawCardsInPlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setGame.dealStartingCards()
        drawCardsInPlay()
    }
    
    override func viewDidLayoutSubviews() {
        drawCardsInPlay()
    }
    
    private func drawCardsInPlay() {
        gridView.subviews.forEach() { $0.removeFromSuperview() }
        gridView.setCellCount(setGame.cardsInPlay.count)
        
        for card in setGame.cardsInPlay {
            let cardView = SetCardView()
            cardView.setVisualProperties(fromAttributes: card.attributes)
            gridView.addSubview(cardView)
            gridView.setNeedsDisplay()
        }
    }
}

