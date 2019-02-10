//
//  GridView.swift
//  set2
//
//  Created by Anthony Mackay on 7/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    private var cellCount: Int?
    
    internal func setCellCount(_ count: Int) {
        self.cellCount = count
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var cardGrid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio), frame: bounds)
        cardGrid.cellCount = cellCount!
        
        for (index, view) in subviews.enumerated() {
            let cardBounds = cardGrid[index]!
            let xInset = cardGridInsetRatio * cardBounds.width
            let yInset = cardGridInsetRatio * cardBounds.height
            view.frame = cardBounds.insetBy(dx: xInset, dy: yInset)
            view.setNeedsDisplay()
        }
    }
    
    private var cardGridInsetRatio: CGFloat = 0.03
 

}
