//
//  GridView.swift
//  set2
//
//  Created by Anthony Mackay on 7/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class SetGridView: UIView {
    internal func addCard(_ card: SetCard, wasDeckEmptied: Bool) {
        // Create card view:
        let cardView = SetCardView()
//        cardView.alpha = 0.0
//        cardView.isFaceDown = true
        cardView.setId(card.id)
        cardView.addGestureRecognizer(touchCardGestureRecognizer())
        cardView.setVisualProperties(fromAttributes: card.attributes)
        cardView.deselect()
        
        // Rearrange the subview hierarchy:
        addSubview(cardView)
        sendSubviewToBack(discardPileCardView)
        sendSubviewToBack(deckCardView)
        
        // Initially position the new card where the deck is:
        cardView.frame = getFrameForSubview(deckCardView)
        
        // Update positions of other subviews which were already on-screen:
        for view in subviews {
            let isNotTheNewCard = (view as? SetCardView) != cardView
            let isTheDeck = (view as? SetCardView) == deckCardView
            if isNotTheNewCard && !isTheDeck {
                let newFrame = getFrameForSubview(view)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: [.beginFromCurrentState],
                    animations: { view.frame = newFrame }
                )
            }
        }
        
        if wasDeckEmptied {
            deckCardView.alpha = 0.0
            deckCardView.isHidden = true
        } else {
            let newDeckFrame = getFrameForSubview(deckCardView)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0.0,
                options: [.beginFromCurrentState],
                animations: { [weak self] in
                    self?.deckCardView.frame = newDeckFrame
                },
                completion: { uiViewAnimatingPosition in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1.0,
                        delay: 0.0,
                        options: [.beginFromCurrentState],
                        animations: { [weak self] in
                            if let newCardFrame = self?.getFrameForSubview(cardView) {
                                cardView.frame = newCardFrame
                            }
                            cardView.alpha = 1.0
                        }
                    )
                }
            )
        }
        
        // Then, move the new card from the deck position to its actual position:
//        let cardFrame = getFrameForSubview(cardView)
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 1.0,
//            delay: 1.0,
//            options: [.beginFromCurrentState],
//            animations: { cardView.frame = cardFrame }
//        )
        
        subviews.forEach { $0.setNeedsDisplay() }
    }
    
    private func isACardInPlay(_ view: UIView) -> Bool {
        let cardView = view as? SetCardView
        return cardView != deckCardView && cardView != discardPileCardView
    }
    
    internal func discardCard(_ card: SetCard, wasDiscardStarted: Bool) {
        //
    }
    
    private func getFrameForSubview(_ view: UIView) -> CGRect {
        if let index = subviews.index(of: view) {
            var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: bounds)
            grid.cellCount = subviews.count
            return getInsetFrame(fromGrid: grid, forIndex: index)
        } else {
            preconditionFailure("view wasn't a subview of SetGridView object")
        }
    }
    
    internal func resetToInitialState() {
        subviews.forEach { $0.removeFromSuperview() }
        resetUiView(deckCardView, isVisible: true)
        resetUiView(discardPileCardView, isVisible: false)
        addSubview(discardPileCardView)
        addSubview(deckCardView)
        deckCardView.frame = getFrameForSubview(deckCardView)
        discardPileCardView.frame = getFrameForSubview(discardPileCardView)
        deckCardView.setNeedsDisplay()
        discardPileCardView.setNeedsDisplay()
    }
    
    private func resetUiView(_ view: UIView, isVisible: Bool) {
        if (isVisible) {
            view.isHidden = false
            view.alpha = 1.0
        } else {
            view.isHidden = true
            view.alpha = 0.0
        }
        view.setNeedsDisplay()
    }
    
    internal func updateStateFromSetGame(_ setGame: SetGame) {
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 0.3,
//            delay: 0.0,
//            options: [.beginFromCurrentState],
//            animations: { [weak self] in
//                self?.deckCardView.frame = newDeckFrame
//                self?.discardPileCardView.frame = newDiscardFrame
//            },
//            completion: { [weak self] uiViewAnimatingPosition in
//                for newCard in newCardsInPlay {
//                    self?.drawNewCard(newCard, startingAtDeckFrame: newDeckFrame)
//                }
//            }
//        )
        }
    
    private func getInsetFrame(fromGrid grid: Grid, forIndex index: Int) -> CGRect {
        let frame = grid[index]!
        let xInset = cardGridInsetRatio * frame.width
        let yInset = cardGridInsetRatio * frame.height
        let insetFrame = frame.insetBy(dx: xInset, dy: yInset)
        return insetFrame
    }
    
    private func touchCardGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.handleTouchCardGestureRecognizer(_:)))
        return tapGestureRecognizer
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
    
    private var deckCardView = SetCardView.defaultFaceDown() // a facedown default card view
    
    private var discardPileCardView = SetCardView.defaultFaceDown() // a facedown default card view
    
//    // Number of cards in play (not deck or discard)
//    private var cellCount: Int?
//
//    internal func setCellCount(_ count: Int) {
//        self.cellCount = count
//    }
    
//    private var subviewsForCardsInPlay: [UIView] {
//        get { return Array(subviews[2..<subviews.count]) }
//    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        var cardGrid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: bounds)
//        cardGrid.cellCount = cellCount! + 2 // extra 2 is the deck and discard piles
//
//        // cards in play
//        for (index, view) in subviewsForCardsInPlay.enumerated() {
//            updateFrame(ofView: view, withGrid: cardGrid, usingIndex: index)
//        }
//
//        // deck
//        let deckIndex = cardGrid.cellCount - 1 // last spot in the grid
//        updateFrame(ofView: deckCardView, withGrid: cardGrid, usingIndex: deckIndex)
//
//        // discard
//        let discardPileIndex = cardGrid.cellCount - 2 // 2nd last spot in grid
//        updateFrame(ofView: discardPileCardView, withGrid: cardGrid, usingIndex: discardPileIndex)
//    }
    
    private func updateFrame(ofView view: UIView, withGrid grid: Grid, usingIndex index: Int) {
        let cardBounds = grid[index]!
        let xInset = cardGridInsetRatio * cardBounds.width
        let yInset = cardGridInsetRatio * cardBounds.height
        view.frame = cardBounds.insetBy(dx: xInset, dy: yInset)
        view.setNeedsDisplay()
    }

    private var cardGridInsetRatio: CGFloat = 0.03
}
