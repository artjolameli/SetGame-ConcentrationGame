//
//  Set.swift
//  SetGame
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.
//

import Foundation

struct Set
{
    var cards = [Card]()
    var cardsAvailable = [Card]()
    var setSelected = [Card]()
    var score = 0
    var hintCard = [Int]()
    
    init() {
        newGame()
    }
    
    func isEmpty() -> Bool {
        return cardsAvailable.count == 0 ? true : false
    }
    
    mutating func newGame() {
        score = 0
        cardsAvailable.removeAll()
        setSelected.removeAll()
        cards.removeAll()
        hintCard.removeAll()
        generateCards()
        addCards(numberOfCardsToAdd: 12)
    }
    
    private mutating func generateCards() {
        for color in Card.Colors.all {
            for shape in Card.Shapes.all{
                for number in Card.Numbers.all{
                    for shade in Card.Shades.all {
                        let playingCard = Card(color: color, shade: shade, shape: shape, number: number, isFaceUp: false, isMatched: false, isMisMatched: false, isSelected: false)
                        cards.append(playingCard)
                        cards.shuffle()
                    }
                }
            }
        }
    }
    
    private mutating func addCard() {
        let randomInt = Int.random(in: 0..<cards.count)
        let selectedCard = cards.remove(at: randomInt)
        cardsAvailable.append(selectedCard)
    }
    
    mutating func addCards(numberOfCardsToAdd numberOfCards: Int) {
        for _ in 0..<numberOfCards {
            addCard()
        }
    }
    
    mutating func hint() {
        hintCard.removeAll()
        for i in 0..<cardsAvailable.count {
            for j in (i + 1)..<cardsAvailable.count {
                for k in (j + 1)..<cardsAvailable.count {
                    let hints = [cardsAvailable[i], cardsAvailable[j], cardsAvailable[k]]
                    if matchingCardsCheck(hints) {
                        hintCard += [i, j, k]
                    }
                }
            }
        }
    }
    
    internal mutating func chooseCard(at index: Int)
    {
        assert(cardsAvailable.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        if(!cardsAvailable[index].isSelected) {
            setSelected.append(cardsAvailable[index])
            
            if ( setSelected.count == 3),
                (matchingCardsCheck( setSelected)) {
                cardsAvailable[index].isMatched = true
                setSelected.removeAll()
                score += 2
            }
            
            if  setSelected.count == 3,
                !matchingCardsCheck( setSelected) {
                cardsAvailable[index].isMisMatched = true
                score -= 1
                setSelected.removeAll()
            }else{
                cardsAvailable[index].isSelected = true
            }
        }
    }
    
    func matchingCardsCheck(_ selectedCards : [Card]) -> Bool {  //checking the algorithm between matching cards
        if selectedCards.count != 3 {
            return false
        }
        if selectedCards[0].color == selectedCards[1].color {
            if selectedCards[0].color != selectedCards[2].color {
                return false
            }
        }
        else if selectedCards[1].color == selectedCards[2].color {
            return false
        }
        else if (selectedCards[0].color == selectedCards[2].color) {
            return false
        }
        if selectedCards[0].number == selectedCards[1].number {
            if selectedCards[0].number != selectedCards[2].number {
                return false
            }
        }
        else if selectedCards[1].number == selectedCards[2].number {
            return false
        }
        else if (selectedCards[0].number == selectedCards[2].number) {
            return false
        }
        if selectedCards[0].shade == selectedCards[1].shade {
            if selectedCards[0].shade != selectedCards[2].shade {
                return false
            }
        }
        else if selectedCards[1].shade == selectedCards[2].shade {
            return false
        }
        else if (selectedCards[0].shade == selectedCards[2].shade) {
            return false
        }
        if selectedCards[0].shape == selectedCards[1].shape {
            if selectedCards[0].shape != selectedCards[2].shape {
                return false
            }
        }
        else if selectedCards[1].shape == selectedCards[2].shape {
            return false
        }
        else if (selectedCards[0].shape == selectedCards[2].shape) {
            return false
        }
        return true
    }
}

extension Int
{
    var arc4random: Int {
        if (self > 0) {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if (self < 0) {
            return -Int(arc4random_uniform(UInt32(-self)))
        }else{
            return 0
        }
    }
}
