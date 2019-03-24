//
//  GridView.swift
//  set2
//
//  Created by Anthony Mackay on 7/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

// Holds a grid of set card views, a deck and a discard pile.
// Deck will be first subview
// Discard will be second subview
class GridView: UIView {
    private var deckCardView = SetCardView.defaultFaceDown() // a facedown default card view
    
    private var discardPileCardView = SetCardView.defaultFaceDown() // a facedown default card view
    
    // Number of cards in play (not deck or discard)
    private var cellCount: Int?
    
    internal func setCellCount(_ count: Int) {
        self.cellCount = count
    }
    
    private var subviewsForCardsInPlay: [UIView] {
        get { return Array(subviews[2..<subviews.count]) }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var cardGrid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: bounds)
        cardGrid.cellCount = cellCount! + 2 // extra 2 is the deck and discard piles
        
        // cards in play
        for (index, view) in subviewsForCardsInPlay.enumerated() {
            updateFrame(ofView: view, withGrid: cardGrid, usingIndex: index)
        }
        
        // deck
        let deckIndex = cardGrid.cellCount - 1 // last spot in the grid
        updateFrame(ofView: deckCardView, withGrid: cardGrid, usingIndex: deckIndex)
        
        // discard
        let discardPileIndex = cardGrid.cellCount - 2 // 2nd last spot in grid
        updateFrame(ofView: discardPileCardView, withGrid: cardGrid, usingIndex: discardPileIndex)
    }
    
    private func updateFrame(ofView view: UIView, withGrid grid: Grid, usingIndex index: Int) {
        let cardBounds = grid[index]!
        let xInset = cardGridInsetRatio * cardBounds.width
        let yInset = cardGridInsetRatio * cardBounds.height
        view.frame = cardBounds.insetBy(dx: xInset, dy: yInset)
        view.setNeedsDisplay()
    }
    
    internal func removeViewsForCardsInPlay() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.addSubview(deckCardView)
        self.addSubview(discardPileCardView)
    }
    
    private var cardGridInsetRatio: CGFloat = 0.03
 

}
