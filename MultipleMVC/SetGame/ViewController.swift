//
//  ViewController.swift
//  SetGame
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var deckOfCards: UIImageView!
    @IBOutlet weak var deckOfCardsTwo: UIImageView!
    private var gethintedCards = [Card]()
    @IBOutlet weak var cardContainerView: CardContainerView!
    var game = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage(tapGestureRecognizer:)))
        deckOfCards.isUserInteractionEnabled = true
        deckOfCards.addGestureRecognizer(tapGestureRecognizer)
        
        addRotateGesture()
//        addSwipeDownGesture()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for view in self.cardContainerView.subviews {
            view.removeFromSuperview()
        }
        for index in game.cardsAvailable.indices{ //subViews
            let subView = SetCardView()
            subView.color = game.cardsAvailable[index].color
            subView.count = game.cardsAvailable[index].number
            subView.shade = game.cardsAvailable[index].shade
            subView.shape = game.cardsAvailable[index].shape
            subView.isMatched = game.cardsAvailable[index].isMatched
            
            subView.isSelected = game.cardsAvailable[index].isSelected
            subView.isMisMatched = game.cardsAvailable[index].isMisMatched
            cardContainerView.setCardAnimations = true
            cardContainerView.addSubview(subView)
        }
        
        for view in self.cardContainerView.subviews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(getIndex(_:)))
            view.addGestureRecognizer(tap)
            view.frame = self.deckOfCards.frame
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    func dealMoreCards() {
        for index in (game.cardsAvailable.count - 3)...game.cardsAvailable.count - 1 {
            let subView = SetCardView()
            subView.color = game.cardsAvailable[index].color
            subView.count = game.cardsAvailable[index].number
            subView.shade = game.cardsAvailable[index].shade
            subView.shape = game.cardsAvailable[index].shape
            subView.isMatched = game.cardsAvailable[index].isMatched
            subView.isSelected = game.cardsAvailable[index].isSelected
            subView.isMisMatched = game.cardsAvailable[index].isMisMatched
            cardContainerView.addSubview(subView)
            cardContainerView.setCardAnimations = true
            subView.frame = self.deckOfCards.frame
        }
        for view in self.cardContainerView.subviews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(getIndex(_:)))
            view.addGestureRecognizer(tap)
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    func updateViewFromModel_Match()
    {
        for view in self.cardContainerView.subviews {
            view.removeFromSuperview()
        }
        
        for index in game.cardsAvailable.indices
        {
            let subView = SetCardView()
            subView.color = game.cardsAvailable[index].color
            subView.count = game.cardsAvailable[index].number
            subView.shade = game.cardsAvailable[index].shade
            subView.shape = game.cardsAvailable[index].shape
            subView.isMatched = game.cardsAvailable[index].isMatched
            subView.isSelected = game.cardsAvailable[index].isSelected
            subView.isMisMatched = game.cardsAvailable[index].isMisMatched
            cardContainerView.setCardAnimations = false
            cardContainerView.addSubview(subView)
        }
        for view in self.cardContainerView.subviews {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getIndex(_:)))
            view.addGestureRecognizer(gestureRecognizer)
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @objc func getIndex(_ sender: UITapGestureRecognizer)
    {
        
        if let cardNumber = cardContainerView.subviews.firstIndex(of: sender.view!)
            
        {
            let view = cardContainerView.subviews[cardNumber]
            
            if game.cardsAvailable[cardNumber].isSelected
            {
                game.cardsAvailable[cardNumber].isSelected = !game.cardsAvailable[cardNumber].isSelected
                
                for card in game.setSelected.indices
                {
                    if game.setSelected.indices.contains(card){
                        if game.cardsAvailable[cardNumber].description == game.setSelected[card].description
                        {
                            game.setSelected.remove(at: card)
                        }
                    }
                }
                
                UIView.transition(with: view,
                                  duration: 0.75,
                                  options: .transitionFlipFromRight,
                                  animations: {
                                    
                                    view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                                    
                                    view.layer.borderColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 0.6420697774)
                                    
                }) { finished in
                }
            } else {
                game.chooseCard(at: cardNumber)
                
                UIView.transition(with: view,
                                  duration: 0.75,
                                  options: .transitionFlipFromRight,
                                  animations: {
                                    
                                    view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                                    
                                    view.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                                    view.layer.borderWidth = 1.2
                                    
                }) { finished in
                    
                }
                
                if(game.cardsAvailable[cardNumber].isMisMatched){  //when the cards are mismatched
                    
                    view.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    view.layer.borderWidth = 7
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.game.cardsAvailable[cardNumber].isMisMatched = false
                        for i in 0..<self.game.cardsAvailable.count{
                            self.game.cardsAvailable[i].isSelected = false
                        }
                        self.updateViewFromModel_Match()
                    })
                }
                
                if(game.cardsAvailable[cardNumber].isMatched)   // when the cards are matched
                {
                    view.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    view.layer.borderWidth = 7
                    
                    for view in cardContainerView.subviews {
                        if view.layer.borderColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), view.layer.borderWidth == 7
                        {
                            view.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                            view.layer.borderWidth = 7
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        
                        self.game.cardsAvailable[cardNumber].isMatched = false
                        var cardsAmount = [Int]()
                        
                        for view in self.cardContainerView.subviews {
                            if view.layer.borderColor == #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), view.layer.borderWidth == 7
                            {
                                cardsAmount.append(self.cardContainerView.subviews.firstIndex(of: view)!)
                                cardsAmount = cardsAmount.sorted().reversed()
                            }
                        }
                        
                        for i in cardsAmount
                        {
                            
                            let view = self.cardContainerView.subviews[i]
                            
                            UIView.transition(with: view, duration: 0.33, options: .transitionCurlDown, animations: {
                                
                                self.game.cardsAvailable[i].isFaceUp = !self.game.cardsAvailable[i].isFaceUp
                                view.frame = self.deckOfCardsTwo.frame
                            }) { finished in
                                
                                self.game.cardsAvailable.remove(at: i)
                                view.removeFromSuperview()
                            }
                        }
                        
                        self.game.addCards(numberOfCardsToAdd: 3)
                        self.dealMoreCards()
                        
                    })
                }
            }
        }
    }
    
//
//    private func addSwipeDownGesture() {
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownDeal(recognizedBy:)))
//        swipe.direction = .down
//        self.view.addGestureRecognizer(swipe)
//    }
//
//    @objc func swipeDownDeal(recognizedBy recognizer: UISwipeGestureRecognizer) {
//        switch recognizer.state {
//        case .ended:
//            game.addCards(numberOfCardsToAdd: 3)
//            updateViewFromModel()
//        default:
//            break
//        }
//    }
    
    private func addRotateGesture() {
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleRotate(recognizedBy:)))
        self.view.addGestureRecognizer(rotate)
    }
    
    @objc func shuffleRotate(recognizedBy recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.addCards(numberOfCardsToAdd: 12)
            updateViewFromModel()
        default:
            break
        }
    }
    
    @IBAction func newGameClicked(_ sender: Any) {
        game.newGame()
        addRotateGesture()
        updateViewFromModel()
        cardContainerView.setCardAnimations = true
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            self.view.transform = CGAffineTransform.identity
                        }
        })

    }
    
    @objc func tapImage(tapGestureRecognizer: UITapGestureRecognizer) {
        if game.cards.count > 1 {
            game.addCards(numberOfCardsToAdd: 3)
            dealMoreCards()
        }
    }
    
    @IBAction func dealThreeMoreCards(_ sender: UISwipeGestureRecognizer) {
        if game.cards.count > 1 {
            game.addCards(numberOfCardsToAdd: 3)
            dealMoreCards()
        }
    }
    
    @IBAction func hintClicked(_ sender: Any) {
        
        game.hint()
        cardContainerView.setCardAnimations = true
        if game.hintCard.count < 3 { return }
        
        for index in 0...2 {
            
            gethintedCards.append(game.cardsAvailable[game.hintCard[index]])
            
            let view = cardContainerView.subviews[game.hintCard[index]]
            
            UIView.animate(withDuration: 0.7,
                           animations: {
                            view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.75) {
                                view.transform = CGAffineTransform.identity
                            }
            })
            
        }
        gethintedCards.removeAll()
    }
}

