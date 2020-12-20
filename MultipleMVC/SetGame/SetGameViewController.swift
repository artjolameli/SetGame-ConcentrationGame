//
//  ViewController.swift
//  drawing practice
//
//  Created by Pawel Misiak on 10/25/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
//    lazy var grid = Grid(for: gameView.bounds, withNoOfFrames: gameView.subviews.count)
    
    func flip(card: CardView) -> CardView {
        card.color = UIColor.white
        card.backgroundColor = UIColor.white
        
        return card
    }
    
    private lazy var game = Set()
    var delayTime = 0.0
    var visibleCards = 12
    var maxNumberOfVisible = 81
    
    @IBOutlet weak var newCards: UIView!
    @IBOutlet weak var oldCards: UIView!
    
    @IBAction func reset() { // reset the game to the original state
        resetAnimation()
        let timeToWait = Int(ceil(Double(gameView.subviews.count) * 0.05 + 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timeToWait), execute: {
            for card in self.gameView.subviews{
                card.removeFromSuperview()
            }
            self.addThree.isEnabled = true
            self.addThree.backgroundColor = #colorLiteral(red: 1, green: 0.09332232228, blue: 0, alpha: 1)
            self.game = Set()
            self.visibleCards = 12
            self.viewDidLoad()
            self.cardsToOut = []
            self.maxNumberOfVisible = 81
        })
    }
    
    func resetAnimation(){
        var int = 0.0
        var i = gameView.subviews.count-1
        while i >= 0{
            let card = gameView.subviews[i]
            UIView.animate(
                withDuration: 1.0,
                delay: int,
                options: [],
                animations: {
                    card.frame.origin = self.oldCards.frame.origin
                    UIView.transition(with: card, duration: 1, options: [.transitionFlipFromTop],
                                      animations: {
                                        card.alpha = 0
                    })

            },
                completion: {_ in
                    UIView.animate(
                        withDuration: 1.0,
                        delay: int,
                        options: [],
                        animations: {
                            
                    })
                    }
                    )
            int += 0.05
            i -= 1
        }
    }
    
    @IBOutlet weak var gameView: UIView!{
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCards))
            swipe.direction = [.down]
            gameView.addGestureRecognizer(swipe)
        }
    }
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            shuffle()
        }
    }
    
    private func shuffle() {
        var decreasingIterator = gameView.subviews.count-1
        while decreasingIterator > 0 {
            let rand = Int(arc4random_uniform(UInt32(decreasingIterator)))
            gameView.exchangeSubview(at: decreasingIterator, withSubviewAt: rand)
            decreasingIterator -= 1
        }
    }
    
    @objc private func addThreeCards(){
        visibleCards += 3
        updateViewFromModel()
    }
    @IBOutlet weak var ScoreCount: UILabel! //label that will keep track of the score
    @IBOutlet weak var addThree: UIButton!  //button to add three cards
    @IBAction func addThree(_ sender: UIButton) { //by changing count of visible buttons updateViewFromModel will automatically unlock the disabled buttons and associate 3 more cards
        addThreeCards()
    }
    var cardsToOut = Array<Int>()
    
    func touchCardAnimation(index: Int){
//        let card = CardView()
//        card.color = UIColor.white
//        card.shade = "empty"
//        card.shape = "diamond"
//        card.numberOfObjects = 1
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.transitionFlipFromLeft],
            animations: {
                self.gameView.subviews[index].transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }

    
    @IBAction func touchCard(_ sender: UITapGestureRecognizer) {
        var wasCalled = false
        if sender.state == .ended {
            let location = sender.location(in: gameView)
            if let tappedView = gameView.hitTest(location, with: nil) {
                if let cardIndex = gameView.subviews.index(of: tappedView) {
                    touchCardAnimation(index: cardIndex)
                    game.chooseCard(index: cardIndex)
                    if game.arrayOfMatchedCardIndices.count == 3 {
                        for index in game.arrayOfMatchedCardIndices {
                            if game.weGotAMatch{
                                gameView.subviews[index].backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                                ScoreCount.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                                cardsToOut = game.arrayOfMatchedCardIndices // array of index to remove from the screen
                                var int = 0.0
                                let grid = Grid(for: gameView.bounds, withNoOfFrames: gameView.subviews.count, forIdeal: 2.0)
                                for index in self.cardsToOut{
                                    let card = gameView.subviews[index]
                                    card.frame = grid[index]!
                                    UIView.animate(
                                        withDuration: 1,
                                        delay: int,
                                        options: [.curveEaseOut],
                                        animations: {
                                           card.frame = self.oldCards.frame
//                                            card.frame.origin.x = self.oldCards.frame.origin.x
//                                            card.frame.origin.y = self.oldCards.frame.origin.y
//                                            card.frame.origin = self.oldCards.frame.origin
                                    })
                                    int += 0.05
                                }
                            }
                            
                            if game.wrongMatch{
                                gameView.subviews[index].backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                                ScoreCount.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                                game.cardsOnTable[index].isSelected = false
                                
                                for index in game.arrayOfMatchedCardIndices{
                                    
                                    let card = gameView.subviews[index]
//                                    let newCard = CardView()
//                                    newCard.color = UIColor.white
//                                    newCard.backgroundColor = UIColor.white
//                                    newCard.shade = "empty"
//                                    newCard.shape = "diamond"
//                                    newCard.numberOfObjects = 1
//                                    self.gameView.subviews[index].removeFromSuperview()
//                                    self.gameView.insertSubview(newCard, at: index)
                                    print(gameView.subviews[0])
                                    UIView.animate(
                                        withDuration: 0.8,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                                self.gameView.subviews[index].transform = CGAffineTransform(scaleX: -1, y: -1)
                                    },
                                            completion: {_ in
                                                UIView.transition(with: card, duration: 1, options: [.transitionFlipFromTop],
                                                                  animations: {
                                                })
                                            self.gameView.subviews[index].transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                   
                                }
                            }
                            wasCalled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                self.ScoreCount.backgroundColor = UIColor.clear
                                if self.game.weGotAMatch {
                                    self.game.score += 3
                                }
                                if self.game.wrongMatch {
                                    self.game.score -= 3
                                }
                                self.game.weGotAMatch = false
                                self.game.wrongMatch = false
                                self.updateViewFromModel()
                            })
                        }
                        game.arrayOfMatchedCardIndices.removeAll()
                    }
                }
            }
        }
        if !wasCalled {
            updateViewFromModel();
        }
    }
    
    private func insertCard(index: Int) -> CardView {
        let cardView = CardView()
        var card = Card()
        if visibleCards > gameView.subviews.count && game.cards.count > 0 {
            card = game.cards.remove(at: 0)
            game.cardsOnTable.append(card) // add the card to the end of array
        } else {
            if game.cards.count > 0 {
                card = game.cards.remove(at: 0)
                game.cardsOnTable[index] = card // add the card at the specific location
            }else if game.cardsOnTable.count > 0{
                game.cardsOnTable.remove(at: index)
            }
        }
        
        cardView.numberOfObjects = card.symbolCount
        switch card.symbol {
        case "diamond": cardView.shape = "diamond"
        case "oval": cardView.shape = "oval"
        case "squigle": cardView.shape = "squigle"
        default: break
        }
        
        switch card.color {
        case "blue": cardView.color = UIColor.cyan
        case "green": cardView.color = UIColor.green
        case "purple": cardView.color = UIColor.purple
        default: break
        }
        
        switch card.shade {
        case "full": cardView.shade = "full"
        case "striped": cardView.shade = "striped"
        default:
            cardView.shade = "empty"
        }
        
        if visibleCards > gameView.subviews.count {
            return cardView
        } else {
            gameView.subviews[index].removeFromSuperview()
            if game.cards.count > 0 {
                gameView.insertSubview(cardView, at: index)
            }
        }
        
        return cardView
    }
    
    func addCardAnimation(card: CardView, index: Int){
        let grid = Grid(for: gameView.bounds, withNoOfFrames: gameView.subviews.count, forIdeal: 2.0)
        print(index)
        var int = 0.0
        int = delayTime
        
        card.isHidden = true
        card.alpha = 0
        card.frame = newCards.frame
        
        UIView.animate(
            withDuration: 1.0,
            delay: int,
            options: [],
            animations: {
                if index == 0 {
                    card.frame = grid[index]!
                }else{
                    card.frame = grid[index - 1]!
                }
                card.isHidden = false
                card.alpha = 1
                
                
        },
            completion: {_ in
                UIView.transition(with: card, duration: 1, options: [.transitionFlipFromTop],
                                  animations: {
                })
        })
        
    }
    
    var indexOfAddedCard = 99;
    func addCard(){
        print(gameView.subviews.count)
        if indexOfAddedCard == 99 {
            let currentCard = insertCard(index: 0)
            gameView.addSubview(currentCard)
            addCardAnimation(card: currentCard, index: gameView.subviews.count)
            gameView.setNeedsLayout()
            gameView.setNeedsDisplay()
        }
        else{
            let currentCard = insertCard(index: indexOfAddedCard)
            addCardAnimation(card: currentCard, index: indexOfAddedCard)
        }
        indexOfAddedCard = 99
    }
    
    @IBAction func peakButton(_ sender: UIButton) {
        // button will highlight 3 cards for one second that currently form a match and will deduct points from the current score
        game.score -= 4
        var found = false
        for i in 0..<gameView.subviews.count{
            for j in i+1..<visibleCards{
                for k in j+1..<visibleCards{
                    if game.checkForMatch(
                        card1: game.cardsOnTable[i],
                        card2: game.cardsOnTable[j],
                        card3: game.cardsOnTable[k]) {
                        found = true
                        
                        UIView.animate(
                            withDuration: 1,
                            delay: 0,
                            options: [.autoreverse],
                            animations: {
                                self.gameView.subviews[i].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                                self.gameView.subviews[i].transform = CGAffineTransform(scaleX: -1, y: -1)
                                self.gameView.subviews[j].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                                self.gameView.subviews[j].transform = CGAffineTransform(scaleX: -1, y: -1)
                                self.gameView.subviews[k].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                                self.gameView.subviews[k].transform = CGAffineTransform(scaleX: -1, y: -1)
                        })
                        ScoreCount.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // asynchronous function that allows delay in farther execution without pausing the entire system
                            self.gameView.subviews[k].transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.gameView.subviews[j].transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.gameView.subviews[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.ScoreCount.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            self.updateViewFromModel()
                        })
                    }
                    if found{break}
                }
                if found{break}
            }
            if found{break}
        }
    }
    
    func checkIfAllDisabled() -> Bool{
        //necessary to check if the game is about to come to the end
        if game.cardsOnTable.count < 3 {
            return true
        }
        return false
    }
    
    private func updateViewFromModel() {
        
        delayTime = 0 // reset delay after each use
        if game.cards.count < 3 || visibleCards == 81 {
            addThree.isEnabled = false
            addThree.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
        ScoreCount.text = "Score: \(game.score)" // adjust the score here
        
        if visibleCards > gameView.subviews.count && game.cards.count > 0 {
            while visibleCards != game.cardsOnTable.count {
                addCard()
                delayTime += 0.05
            }
        }
        
        if checkIfAllDisabled() { //change the score to a message with score count indicating that the game is over
            ScoreCount.text = "You have finished the game with score: \(game.score)"
        }
        
        if gameView.subviews.count <= maxNumberOfVisible {
            for index in 0..<gameView.subviews.count {
                
                let currentCard = game.cardsOnTable[index]
                if currentCard.isSelected {
                    gameView.subviews[index].backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                } else {
                    gameView.subviews[index].backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
                }
            }
        }
        if cardsToOut.count == 3 {
            for index in 0..<3 {
                indexOfAddedCard = cardsToOut[index]
                addCard()
                gameView.setNeedsLayout()
                gameView.setNeedsDisplay()
            }
            maxNumberOfVisible -= 3
            
            cardsToOut = []
        }
    }
}

