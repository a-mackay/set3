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
        setGame.dealStartingCards()
        drawCardsInPlay()
    }
    
    override func viewDidLayoutSubviews() {
        drawCardsInPlay()
    }
    
    private func drawCardsInPlay() {
        gridView.subviews.forEach() { $0.removeFromSuperview() }
        gridView.setCellCount(setGame.cardsInPlay.count)
        
        for (index, card) in setGame.cardsInPlay.enumerated() {
            let cardView = SetCardView()
            cardView.setId(index)
            cardView.addGestureRecognizer(touchCardGestureRecognizer())
            cardView.setVisualProperties(fromAttributes: card.attributes)
            if setGame.selectedCards.contains(card) {
                cardView.select()
            } else {
                cardView.deselect()
            }
            gridView.addSubview(cardView)
        }
        gridView.setNeedsDisplay()
    }
    
    private func touchCardGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTouchCardGestureRecognizer(_:)))
        return tapGestureRecognizer
    }
    
    @objc
    private func handleTouchCardGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            let setCardView = recognizer.view as! SetCardView
            let id = setCardView.getId()
            setGame.touchCard(atIndex: id)
            drawCardsInPlay()
        default: break
        }
    }
}

