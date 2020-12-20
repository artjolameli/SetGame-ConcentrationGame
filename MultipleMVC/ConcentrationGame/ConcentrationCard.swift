//
//  Card.swift
//  MultipleMVC
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import Foundation

struct ConcentrationCard {
    
    
    var identifier: Int //what is on the card- every card has an identifier
    var isFaceUp = false
    var isMatched = false
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
    identifierFactory += 1
    return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
        
    }
}

