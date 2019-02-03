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
        drawSymbol(withShading: shading, andColor: color, withinBounds: self.bounds)
    }
    
    private func getPath(forShape shape: Shape, withinBounds bounds: CGRect) -> UIBezierPath {
        switch shape {
        case .circle:
            return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        case .triangle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX, y: 0))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            path.close()
            return path
        case .square:
            return UIBezierPath(rect: bounds)
        }
    }
    
    private func drawSymbol(withShading shading: Shading, andColor color: Color, withinBounds bounds: CGRect) {
        let insetBounds = bounds.insetBy(dx: Constants.symbolInset * bounds.width, dy: Constants.symbolInset * bounds.height)
        let path = getPath(forShape: .triangle, withinBounds: insetBounds)
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
            case .orange: return UIColor.orange
            case .green: return UIColor.green
            case .blue: return UIColor.blue
            }
        }
    }
    
    
}

fileprivate struct Constants {
    static let symbolsAreaToCardBounds: CGFloat = 0.75
    static let symbolInset: CGFloat = 0.1
    static let alphaComponent: CGFloat = 0.45
    static let strokeWidth: CGFloat = 0.05
}
