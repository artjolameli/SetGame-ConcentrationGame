//
//  Card.swift
//  SetGame
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import Foundation
import UIKit

struct Card {
    internal var color : Colors
    internal var shade : Shades
    internal var shape : Shapes
    internal var number : Numbers
    internal var isFaceUp = false
    internal var isMatched = false
    internal var isMisMatched = false
    internal var isSelected = false
    
    var description: String {
         return "\(color), \(shade), \(shape), \(number) , is face up: \(isFaceUp)"
     }
     
    enum Numbers {
        case one
        case two
        case three
        static var all = [Numbers.one, Numbers.two, Numbers.three]
    }
    
    enum Colors {
        case purple
        case green
        case red
        static var all = [Colors.green, Colors.purple, Colors.red]
    }
    
    enum Shades {
        case empty
        case filled
        case striped
        static var all = [Shades.striped, Shades.filled, Shades.empty]
    }
    
    enum Shapes {
        case diamond
        case squiggle
        case oval
        static var all = [Shapes.squiggle, Shapes.oval, Shapes.diamond]
    }
}
