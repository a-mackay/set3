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

    @IBOutlet weak var draw3CardsButton: UIButton!
    
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        setGame.dealStartingCards()
        drawEverything()
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
        draw3Cards()
    }
    
    private func draw3Cards() {
        setGame.dealThreeCards()
        drawEverything()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(swipeDownGestureRecognizer())
        view.addGestureRecognizer(rotateGestureRecognizer())
        setGame.dealStartingCards()
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
    
    private func rotateGestureRecognizer() -> UIRotationGestureRecognizer {
        let gestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGestureRecognizer(_:)))
        return gestureRecognizer
    }
    
    private func drawEverything() {
        scoreLabel.text = "Score: \(setGame.score)"
        drawCardsInPlay()
        draw3CardsButton.isEnabled = !setGame.isDeckEmpty()
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
    
    @objc
    private func handleRotationGestureRecognizer(_ recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            shuffleCardsInPlay()
        default: break
        }
    }
}

