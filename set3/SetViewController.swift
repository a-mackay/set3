//
//  ViewController.swift
//  set2
//
//  Created by Anthony Mackay on 2/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    private var setGame = SetGame()

    @IBOutlet weak var draw3CardsButton: UIButton!
    
    @IBOutlet weak var gridView: SetGridView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        reset()
    }
    
    private func reset() {
        setGame = SetGame()
        gridView.resetToInitialState()
//        (0..<setGame.numberOfStartingCards).forEach { _ in
//            draw1Card()
//        }
        draw1Card()
        drawEverything()
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
        draw3Cards()
    }
    
    private func draw1Card() {
        if let dealtCard = setGame.dealCard() {
            gridView.addCard(dealtCard, wasDeckEmptied: setGame.isDeckEmpty())
        }
    }
    
    private func draw3Cards() {
        draw1Card()
//        draw1Card()
//        draw1Card()
        drawEverything()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(swipeDownGestureRecognizer())
        reset()
    }
    
    override func viewDidLayoutSubviews() {
        drawEverything()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        view.setNeedsDisplay()
        view.setNeedsLayout()
    }
    
    private func swipeDownGestureRecognizer() -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGestureRecognizer(_:)))
        gestureRecognizer.direction = .down
        return gestureRecognizer
    }

    private func drawEverything() {
        scoreLabel.text = "Score: \(setGame.score)"
//        drawCardsInPlay()
        self.gridView.updateStateFromSetGame(self.setGame)
        draw3CardsButton.isEnabled = !setGame.isDeckEmpty()
    }
    
//    private func drawCardsInPlay() {
//        gridView.removeViewsForCardsInPlay()
//        gridView.setCellCount(setGame.cardsInPlay.count)
//        
//        for card in setGame.cardsInPlay {
//            let cardView = SetCardView()
//            cardView.setId(card.id)
//            cardView.addGestureRecognizer(touchCardGestureRecognizer())
//            cardView.setVisualProperties(fromAttributes: card.attributes)
//            if setGame.isCardSelected(card) {
//                cardView.select()
//            } else {
//                cardView.deselect()
//            }
//            gridView.addSubview(cardView)
//        }
//        gridView.setNeedsDisplay()
//    }
    
    private func touchCardGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.handleTouchCardGestureRecognizer(_:)))
        return tapGestureRecognizer
    }
    
    @objc
    internal func handleTouchCardGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            let setCardView = recognizer.view as! SetCardView
            let id = setCardView.getId()
            setGame.touchCard(withId: id)
            drawEverything()
        default: break
        }
    }
    
    @objc
    private func handleSwipeDownGestureRecognizer(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            draw3Cards()
        default: break
        }
    }
}

