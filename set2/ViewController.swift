//
//  ViewController.swift
//  set2
//
//  Created by Anthony Mackay on 2/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var setGame = SetGame() {
        didSet { drawCardsInPlay() }
    }

    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        print("newgame")
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
        print("draw 3")
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
        
        var cardGrid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: gridView.bounds)
        let cardCount = setGame.cardsInPlay.count
        cardGrid.cellCount = cardCount
        
        for (index, card) in setGame.cardsInPlay.enumerated() {
            let cardView = SetCardView()
            cardView.setVisualProperties(fromAttributes: card.attributes)
            let cardBounds = cardGrid[index]!
            let xInset = cardGridInsetRatio * cardBounds.width
            let yInset = cardGridInsetRatio * cardBounds.height
            cardView.frame = cardBounds.insetBy(dx: xInset, dy: yInset)
            gridView.addSubview(cardView)
        }
    }
    
    let cardGridInsetRatio: CGFloat = 0.05


}

