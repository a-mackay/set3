//
//  GridView.swift
//  set2
//
//  Created by Anthony Mackay on 7/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class SetGridView: UIView {
    struct State {
        var showDeck = true
        var showDiscard = false
        var orderedCards: [SetCard] = []
    }
    
    var state = State()
    
    internal func resetToInitialState() {
        subviews.forEach { $0.removeFromSuperview() }
        state = State()
        self.deckCardView.frame = getFrameOfDeckView(forOrderedCards: state.orderedCards)
        self.deckCardView.isHidden = !state.showDeck
        self.discardPileCardView.frame = getFrameOfDiscardView(forOrderedCards: state.orderedCards)
        self.discardPileCardView.isHidden = !state.showDiscard
        self.addSubview(deckCardView)
        self.addSubview(discardPileCardView)
        self.deckCardView.setNeedsDisplay()
        if (state.showDeck) {
            self.deckCardView.alpha = 1.0
        } else {
            self.deckCardView.alpha = 0.0
        }
        self.discardPileCardView.setNeedsDisplay()
        if (state.showDiscard) {
            self.discardPileCardView.alpha = 1.0
        } else {
            self.discardPileCardView.alpha = 0.0
        }
        self.setNeedsDisplay()
    }
    
    internal func updateStateFromSetGame(_ setGame: SetGame) {
        let newState = State(
            showDeck: !setGame.isDeckEmpty(),
            showDiscard: !setGame.isDiscardEmpty(),
            orderedCards: setGame.cardsInPlay
        )
        let newDeckFrame = getFrameOfDeckView(forOrderedCards: newState.orderedCards)
        let newDiscardFrame = getFrameOfDiscardView(forOrderedCards: newState.orderedCards)
        
        let newCardsInPlay = setGame.cardsInPlay.filter { !self.state.orderedCards.contains($0) }
        let cardsWhichWereAlreadyInPlay = setGame.cardsInPlay.filter { self.state.orderedCards.contains($0) }
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0.0,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                self?.deckCardView.frame = newDeckFrame
                self?.discardPileCardView.frame = newDiscardFrame
            },
            completion: { [weak self] uiViewAnimatingPosition in
                for newCard in newCardsInPlay {
                    self?.drawNewCard(newCard, startingAtDeckFrame: newDeckFrame)
                }
            }
        )
        for card in cardsWhichWereAlreadyInPlay {
            if let matchingSetCardView = (subviews.filter { ($0 as? SetCardView)?.getId() == card.id }).first as? SetCardView {
                if let newCardFrame = getFrameOfCard(card, forOrderedCards: newState.orderedCards) {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.3,
                        delay: 0.0,
                        options: [.beginFromCurrentState],
                        animations: {
                            matchingSetCardView.frame = newCardFrame
                        }
                    )
                }
            }
        }
        
//        let newOrderOfCards = setGame.cardsInPlay
//        let newCardsInPlay = setGame.cardsInPlay.filter { !self.orderedCards.contains($0) }
//        for newCard in newCardsInPlay {
//            let newCardView = drawNewCard(newCard)
//            let newCardViewFrame = getInsetFrame(fromGrid: getGrid(forOrderedCards: newOrderOfCards), forIndex: setGame.cardsInPlay.index(of: newCard)!)
//            UIViewPropertyAnimator.runningPropertyAnimator(
//                withDuration: 1.0,
//                delay: 0.0,
//                options: [.beginFromCurrentState],
//                animations: { newCardView.frame = newCardViewFrame }
//            )
//        }
//
//        showDeck = !setGame.isDeckEmpty()
//        showDiscard = !setGame.isDiscardEmpty()
//        orderedCards = setGame.cardsInPlay
    }
    
    private func drawNewCard(_ newCard: SetCard, startingAtDeckFrame deckFrame: CGRect) {
        let cardView = SetCardView()
        cardView.frame = deckFrame
        cardView.setId(newCard.id)
        cardView.addGestureRecognizer(touchCardGestureRecognizer())
        cardView.setVisualProperties(fromAttributes: newCard.attributes)
        cardView.deselect()
        self.addSubview(cardView)
        cardView.setNeedsDisplay()
        self.setNeedsDisplay()
    }
    
    private func getGrid(forOrderedCards cards: [SetCard]) -> Grid {
        var cardGrid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: bounds)
        cardGrid.cellCount = cards.count + 2 // extra 2 is the deck and discard piles
        return cardGrid
    }
    
    private func getFrameOfDeckView(forOrderedCards cards: [SetCard]) -> CGRect {
        let cardGrid = getGrid(forOrderedCards: cards)
        let lastIndex = cardGrid.cellCount - 1
        return getInsetFrame(fromGrid: cardGrid, forIndex: lastIndex) // Should always be two indices in cardGrid
    }
    
    private func getFrameOfDiscardView(forOrderedCards cards: [SetCard]) -> CGRect {
        let cardGrid = getGrid(forOrderedCards: cards)
        let secondLastIndex = cardGrid.cellCount - 2
        return getInsetFrame(fromGrid: cardGrid, forIndex: secondLastIndex) // Should always be two indices in cardGrid
    }
    
    private func getFrameOfCard(_ card: SetCard, forOrderedCards orderedCards: [SetCard]) -> CGRect? {
        let cardGrid = getGrid(forOrderedCards: orderedCards)
        if let cardIndex = orderedCards.index(of: card) {
            return getInsetFrame(fromGrid: cardGrid, forIndex: cardIndex)
        } else {
            return nil
        }
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
    
//    internal func removeViewsForCardsInPlay() {
//        self.subviews.forEach { $0.removeFromSuperview() }
//        self.addSubview(deckCardView)
//        self.addSubview(discardPileCardView)
//    }
    
    private var cardGridInsetRatio: CGFloat = 0.03
}
