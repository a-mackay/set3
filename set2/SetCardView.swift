//
//  SetCardView.swift
//  set2
//
//  Created by Anthony Mackay on 2/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    private let shape: Shape = Shape.circle
    private let number: Number = Number.one
    private let shading: Shading = Shading.semitransparent
    private let color: Color = Color.blue
    
    override func draw(_ rect: CGRect) {
        let cardSize = getCardBounds(fromBounds: self.bounds)
        let cardPath = UIBezierPath(roundedRect: cardSize, cornerRadius: cardSize.width * Constants.cornerRadiusRatio)
        
//        let symbolsAreaBounds = cardSize.insetBy(dx: Constants.cardSymbolAreaInset * cardSize.width, dy: Constants.cardSymbolAreaInset * cardSize.height)
        let symbolsGrid = Grid(layout: Grid.Layout.dimensions(rowCount: 3, columnCount: 1), frame: frame)
        UIColor.black.setFill()
        cardPath.fill()
        drawSymbol(withShape: shape, andShading: shading, andColor: color, withinBounds: self.bounds)
    }
    
    private func getCardBounds(fromBounds bounds: CGRect) -> CGRect {
        let boundsRatio = bounds.width / bounds.height
        if boundsRatio > Constants.cardRatio {
            let desiredWidth = bounds.height * Constants.cardRatio
            let widthDifference = abs(bounds.width - desiredWidth)
            // The bounds are wider than the desired aspect ratio, so we shrink the width:
            return CGRect(x: bounds.minX + widthDifference / 2, y: bounds.minY, width: bounds.width - widthDifference, height: bounds.height)
        } else if boundsRatio < Constants.cardRatio {
            // The bounds are thinner than the desired aspect ration, so we shrink the height:
            let desiredHeight = bounds.width / Constants.cardRatio
            let heightDifference = abs(bounds.height - desiredHeight)
            return CGRect(x: bounds.minX, y: bounds.minY + heightDifference / 2, width: bounds.width, height: bounds.height - heightDifference)
        } else {
            return bounds
        }
    }
    
    private func getCardFrame(fromFrame frame: CGRect, andCardBounds cardBounds: CGRect) -> CGRect {
        // TODO
        convert
        return CGRect(origin: frame.origin, size: cardBounds.size)
    }
    
    private func getPath(forShape shape: Shape, withinBounds bounds: CGRect) -> UIBezierPath {
        switch shape {
        case .circle:
            return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case .triangle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX, y: Constants.equilateralTriangleHeightOffset * bounds.height))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - Constants.equilateralTriangleHeightOffset * bounds.height))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY - Constants.equilateralTriangleHeightOffset * bounds.height))
            path.close()
            return path
        case .square:
            return UIBezierPath(rect: bounds)
        }
    }
    
    private func drawSymbol(withShape shape: Shape, andShading shading: Shading, andColor color: Color, withinBounds bounds: CGRect) {
        let insetBounds = bounds.insetBy(dx: Constants.symbolInset * bounds.width, dy: Constants.symbolInset * bounds.height)
        let path = getPath(forShape: shape, withinBounds: insetBounds)
        path.lineWidth = Constants.strokeWidth * insetBounds.width
        let uiColor = color.toColor()
        uiColor.setStroke()
        
        switch shading {
        case .outline: break
        case .filled:
            uiColor.setFill()
            path.fill()
        case .semitransparent:
            uiColor.withAlphaComponent(Constants.alphaComponent).setFill()
            path.fill()
        }
        
        path.stroke()
    }
    
    private enum Shape {
        case circle
        case triangle
        case square
    }
    
    private enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    private enum Shading {
        case outline
        case filled
        case semitransparent
    }
    
    private enum Color {
        case orange
        case green
        case blue
        
        func toColor() -> UIColor {
            switch self {
            case .orange: return #colorLiteral(red: 0.9872463346, green: 0.6835058331, blue: 0.2003244758, alpha: 1)
            case .green: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            case .blue: return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
    
}

fileprivate struct Constants {
    static let symbolsAreaToCardBounds: CGFloat = 0.75
    static let symbolInset: CGFloat = 0.1
    static let alphaComponent: CGFloat = 0.45
    static let strokeWidth: CGFloat = 0.05
    static let equilateralTriangleHeightOffset: CGFloat = 0.12
    
    static let cardRatio: CGFloat = 0.66 // card width to height
    static let cornerRadiusRatio: CGFloat = 0.18 // card width to corner radius
    static let cardSymbolAreaInset: CGFloat = 0.1
}
