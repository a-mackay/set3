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
    
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        (0..<setGame.numberOfStartingCards).forEach { _ in setGame.dealCard() }
        drawEverything()
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
        draw3Cards()
    }
    
    private func draw3Cards() {
        setGame.dealCard()
        setGame.dealCard()
        setGame.dealCard()
        drawEverything()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(swipeDownGestureRecognizer())
        (0..<setGame.numberOfStartingCards).forEach { _ in setGame.dealCard() }
        drawEverything()
    }
    
    override func viewDidLayoutSubviews() {
        drawEverything()
    }
    
    private func shuffleCardsInPlay() {
        setGame.shuffleCardsInPlay()
        drawCardsInPlay()
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
        drawCardsInPlay()
        draw3CardsButton.isEnabled = !setGame.isDeckEmpty()
    }
    
    private func drawCardsInPlay() {
        gridView.removeViewsForCardsInPlay()
        gridView.setCellCount(setGame.cardsInPlay.count)
        
        for card in setGame.cardsInPlay {
            let cardView = SetCardView()
            cardView.setId(card.id)
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.handleTouchCardGestureRecognizer(_:)))
        return tapGestureRecognizer
    }
    
    @objc
    private func handleTouchCardGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
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

