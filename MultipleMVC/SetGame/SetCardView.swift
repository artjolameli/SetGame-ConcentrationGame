//
//  SetCardView.swift
//  Squiggle
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.
//

import UIKit

@IBDesignable class SetCardView: UIView {
    
    //Attributes
    enum Shapes {
        case diamond
        case oval
        case squiggle
        
        static var all = [Shapes.diamond, Shapes.oval, Shapes.squiggle]
    }
    
    var shape : Card.Shapes = Card.Shapes.squiggle {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var color : Card.Colors = Card.Colors.red {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var shade : Card.Shades = Card.Shades.empty {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var count : Card.Numbers = Card.Numbers.one {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var isSelected: Bool = true {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var isMatched: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var isMisMatched: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    /*************************************************/
    /*               drawSquiggle()                  */
    /*************************************************/
    
    private func drawSquiggle() -> UIBezierPath {
        let squiggle = UIBezierPath()
        
        squiggle.move(to: squiggleBottomLeft)
        
        squiggle.addCurve(to: squiggleTopLeft,
                          controlPoint1: squiggleControlLeftOne,
                          controlPoint2: squiggleControlLeftTwo)
        
        squiggle.addArc(withCenter: squiggleTopCenter,
                        radius: squiggleTopRadius,
                        startAngle: CGFloat.pi,
                        endAngle: 0.0,
                        clockwise: true)
        
        squiggle.addCurve(to: squiggleBottomRight,
                          controlPoint1: squiggleControlRightOne,
                          controlPoint2: squiggleControlRightTwo)
        
        squiggle.addArc(withCenter: squiggleBottomCenter,
                        radius: squiggleBottomRadius,
                        startAngle: 0.0,
                        endAngle: CGFloat.pi,
                        clockwise: true)
        
        squiggle.close()
        
        return squiggle
    }
    
    /*************************************************/
    /*               drawOval()                      */
    /*************************************************/
    
    private func drawOval() -> UIBezierPath {
        let oval = UIBezierPath()
        
        oval.move(to: lowerLeftVertex)
        
        oval.addLine(to: upperLeftVertex)
        
        let xDistance = (upperRightVertex.x - upperLeftVertex.x)
        let yDistance = (upperRightVertex.y - upperLeftVertex.y)
        let distance = sqrt((xDistance * xDistance) + (yDistance * yDistance))
        
        oval.addArc(withCenter: CGPoint(x: self.bounds.size.width * 0.5,y:
            self.bounds.size.height * 0.3),
                    radius: distance/2,
                    startAngle: .pi,
                    endAngle: 0, clockwise: true)
        
        oval.addLine(to: lowerRightVertex)
        oval.addArc(withCenter: CGPoint(x: self.bounds.size.width * 0.5,y:
            self.bounds.size.height / 1.5),
                    radius: distance/2,
                    startAngle: 0,
                    endAngle: .pi,
                    clockwise: true)
        oval.close()
        return oval
    }
    
    /*************************************************/
    /*               drawDiamond()                   */
    /*************************************************/
    
    private func drawDiamond() -> UIBezierPath {
        let diamond = UIBezierPath()
        
        diamond.move(to: upperVertex)
        diamond.addLine(to: rightVertex)
        diamond.addLine(to: lowerVertex)
        diamond.addLine(to: leftVertex)
        diamond.addLine(to: upperVertex)
        diamond.close()
        
        return diamond
    }
    
    /*************************************************/
    /*               showPath()                      */
    /*************************************************/
    
    private func showPath(_ path: UIBezierPath) {
        var path = replicatePath(path)
        colorForPath.setStroke()
        path = shadePath(path)
        path.lineWidth = 2.0
        path.fill()
        path.stroke()
    }
    
    /*************************************************/
    /*               colorForPath()                  */
    /*************************************************/
    private var colorForPath: UIColor {
        switch color {
        case .green:
            return UIColor.green
        case .red:
            return UIColor.red
        case .purple:
            return UIColor.purple
        }
    }
    
    /*************************************************/
    /*               shadePath()                    */
    /*************************************************/
    
    private func shadePath(_ path: UIBezierPath) -> UIBezierPath {
        let shadedPath = UIBezierPath()
        shadedPath.append(path)
        
        switch shade {
        case .filled:
            colorForPath.setFill()
        case .striped:
            UIColor.clear.setFill()
            shadedPath.addClip()
            var start = CGPoint(x: 0.0, y: 0.0)
            var end   = CGPoint(x: self.bounds.size.width, y: 0.0)
            let dy: CGFloat = self.bounds.size.height / 10.0
            while start.y <= self.bounds.size.height {
                shadedPath.move(to: start)
                shadedPath.addLine(to: end)
                start.y += dy
                end.y += dy
            }
        case .empty:
            UIColor.clear.setFill()
        }
        
        return shadedPath
    }
    
    /*************************************************/
    /*               replicatePath()                 */
    /*************************************************/
    
    private func replicatePath(_ path: UIBezierPath) -> UIBezierPath {
        let replicatedPath = UIBezierPath()
        
        if count == .one {
            replicatedPath.append(path)
        } else if count == .two {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftPathTransform = CGAffineTransform(translationX: leftTwoPathTranslation.x, y: leftTwoPathTranslation.y)
            leftPath.apply(leftPathTransform)
            
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightPathTransform = CGAffineTransform(translationX: rightTwoPathTranslation.x, y: rightTwoPathTranslation.y)
            rightPath.apply(rightPathTransform)
            
            replicatedPath.append(leftPath)
            replicatedPath.append(rightPath)
        } else if count == .three {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftPathTransform = CGAffineTransform(translationX: leftThreePathTranslation.x, y: leftThreePathTranslation.y)
            leftPath.apply(leftPathTransform)
            
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightPathTransform = CGAffineTransform(translationX: rightThreePathTranslation.x, y: rightThreePathTranslation.y)
            rightPath.apply(rightPathTransform)
            
            replicatedPath.append(leftPath)
            replicatedPath.append(path)
            replicatedPath.append(rightPath)
        }
        
        return replicatedPath
    }
    
    /*************************************************/
    /*               draw()                          */
    /*************************************************/
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds,
                                       cornerRadius: 16)
        roundedRect.addClip()
        roundedRect.lineWidth = 5.0
        
        if isSelected {
            UIColor.black.setStroke()
        } else if isMatched {
            UIColor.green.setStroke()
        } else if isMisMatched {
            UIColor.red.setStroke()
        } else {
            UIColor.white.setStroke()
        }
        
        UIColor.white.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        
        
        let path = UIBezierPath()
        switch shape {
        case .squiggle:
            path.append(drawSquiggle())
        case .oval:
            path.append(drawOval())
        case .diamond:
            path.append(drawDiamond())
        }
        
        showPath(path)
    }
}

extension SetCardView {
    //
    // all the squiggle ratios and locations
    //
    private struct SquiggleRatios {
        static let offsetPercentage:                    CGFloat = 0.20
        static let widthPercentage:                     CGFloat = 0.15
        static let controlHorizontalOffsetPercentage:   CGFloat = 0.10
        static let controlVerticalOffsetPercentage:     CGFloat = 0.40
    }
    
    private var squiggleTopLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    
    private var squiggleBottomLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    
    private var squiggleControlLeftOne: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x + (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage),
                       y: self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage)
    }
    
    private var squiggleControlLeftTwo: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x - (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage))
    }
    
    private var squiggleTopRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    
    private var squiggleBottomRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    
    private var squiggleControlRightOne: CGPoint {
        let controlLeftTwo = squiggleControlLeftTwo
        return CGPoint(x: controlLeftTwo.x + (self.bounds.size.width * SquiggleRatios.widthPercentage),
                       y: controlLeftTwo.y)
    }
    
    private var squiggleControlRightTwo: CGPoint {
        let controlLeftOne = squiggleControlLeftOne
        return CGPoint(x: controlLeftOne.x + (self.bounds.size.width * SquiggleRatios.widthPercentage),
                       y: controlLeftOne.y)
    }
    
    private var squiggleTopCenter: CGPoint {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return CGPoint(x: (topLeft.x + topRight.x)/2.0,
                       y: topLeft.y)
    }
    
    private var squiggleBottomCenter: CGPoint {
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return CGPoint(x: (bottomLeft.x + bottomRight.x)/2.0,
                       y: bottomLeft.y)
    }
    
    private var squiggleTopRadius: CGFloat {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return (topRight.x - topLeft.x)/2.0
    }
    
    private var squiggleBottomRadius: CGFloat {
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return (bottomRight.x - bottomLeft.x)/2.0
    }
}

extension SetCardView {
    //
    //Oval rations and locations
    //
    private struct DiamondRatios {
        static let upperVertexOffsetPercentage:  CGFloat = 0.10
        static let lowerVertexOffsetPercentage:  CGFloat = 0.10
        static let widthPercentage:              CGFloat = 0.20
    }
    
    private var upperVertex: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0,
                       y: self.bounds.size.height * DiamondRatios.upperVertexOffsetPercentage)
    }
    
    private var lowerVertex: CGPoint {
        return CGPoint(x: self.bounds.width/2.0,
                       y: self.bounds.height - (self.bounds.size.height * DiamondRatios.lowerVertexOffsetPercentage))
    }
    
    private var leftVertex: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * DiamondRatios.widthPercentage / 2.0),
                       y: self.bounds.size.height/2.0)
    }
    
    private var rightVertex: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * DiamondRatios.widthPercentage / 2.0),
                       y: self.bounds.size.height/2.0)
    }
    
    //
    //Oval rations and locations
    //
    private var upperLeftVertex: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2.0 - self.bounds.size.width / 12.0,
                       y: self.bounds.size.height * 0.3)
    }
    
    
    private var lowerLeftVertex: CGPoint {
        return CGPoint(x:self.bounds.size.width / 2.0 - self.bounds.size.width / 12.0 ,
                       y: self.bounds.size.height / 1.5);
    }
    
    private var upperRightVertex: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2.0 + self.bounds.size.width / 12.0,
                       y: self.bounds.size.height * 0.3)
    }
    
    
    private var lowerRightVertex: CGPoint {
        return CGPoint(x:self.bounds.size.width / 2.0 + self.bounds.size.width / 12.0 ,
                       y: self.bounds.size.height / 1.5);
    }
}

extension SetCardView {
    //
    // constants and ratios for path replication
    //
    private var leftTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.15,
                       y: 0.0)
    }
    
    private var rightTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.15,
                       y: 0.0)
    }
    
    private var leftThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.25,
                       y: 0.0)
    }
    
    private var rightThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.25,
                       y: 0.0)
    }
}

