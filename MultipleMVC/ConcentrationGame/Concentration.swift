//
//  Concentration.swift
//  MultipleMVC
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import Foundation

class Concentration {
    
    var cards = [ConcentrationCard]()
    var flipCount = 0
    var score = 0
    var seenCards = [Int]()
    var unseen = true
    
    private struct Points {
          static let matchBonus = 2
      }
      
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp  {
                    guard foundIndex == nil else { return nil }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
                
    }
    
   func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += Points.matchBonus
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            flipCount += 1
        }
    }
    
    func resetGame (){
           flipCount = 0
           score = 0
           seenCards = []
           for index in cards.indices  {
               cards[index].isFaceUp = false
               cards[index].isMatched = false
           }
           cards.shuffle()
       }
    
    init(numberOfPairsOfCards: Int) {
            assert(numberOfPairsOfCards > 0,
                   "Concentration.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
            for _ in 1...numberOfPairsOfCards {
                let card = ConcentrationCard()
                cards += [card, card]
            }
            cards.shuffle()
        }
    }

    extension Array {
        mutating func shuffle() {
                if count < 2 {
                    return
                }
            
            for i in indices.dropLast() {
                let diff = distance(from: i, to: endIndex)
                let j = index(i, offsetBy: diff.arc4random)
                swapAt(i, j)
            }
        }
    }
