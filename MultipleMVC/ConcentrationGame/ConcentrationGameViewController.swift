//
//  ConcentrationGameViewController.swift
//  MultipleMVC
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import UIKit

class ConcentrationGameViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    var emojiChoices =  ["🐻", "🥰", "❤️", "😎","🏀", "🐵", "🐶", "🍎","🥦", "🚘", "🍩", "👀","🐢", "🐙", "🐡", "🌼",
       "🐥", "🐸", "🦀", "🐳", "🐓", "🐉", "🍀", "🎂", "🍺", "🇺🇸" ,"🔴"]
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var ScoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    @IBAction func newGame() {
        game.resetGame()
        game.flipCount = 0
        game.score = 0
        emojiChoices = themes[currentThemeNumber]
        currentThemeNumber = getThemeNumber()
        
        for index in game.cards.indices {
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
        }
        viewDidLoad()
        updateViewFromModel()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    
    let themes = [
        ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"],
        ["🤾‍♀️","🏊‍♂️","🥊","🏈","🚴‍♂️","🏓","🏌🏻‍♂️","⚽️","🎳"],
        ["🍝","🥓","🍜","🥞","🍕","🍟","🍔","🌮","🌭"],
        ["🇵🇱","🇺🇸","🇵🇹","🇦🇷","🇨🇦","🇮🇹","🇩🇪","🇯🇵","🏴󠁧󠁢󠁥󠁮󠁧󠁿"],
        ["🛸","🛥","🚂","🚅","🚲","🚜","🚗","✈️","🚀"],
        ["😇","😤","😑","🤢","😱","😂","😎","😡","😀"],
        ["1","2","3","4","5","6","7","8","9"],
        ]
    
    let themeColors = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    var currentThemeNumber = 0
    
    private func getThemeNumber() -> Int {
        for key in themes.indices {
            if emojiChoices == themes[key] {
                return key
            }
        }
        return 0
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.firstIndex(of: sender) {
                       game.chooseCard(at: cardNumber)
                       updateViewFromModel()
                   } else {
                       print("chosen card was not in cardButtons")
                   }
               }

    
    func updateViewFromModel() {
        
        //Update the Flip count
        flipCountLabel.text = "Flips: \(game.flipCount)"
        
        //Update the Score
        ScoreCountLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
                       let button = cardButtons[index]
                       let card = game.cards[index]
                       if card.isFaceUp {
                           button.setTitle(emoji(for: card), for: UIControl.State.normal)
                           button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                       } else {
                           button.setTitle("", for: UIControl.State.normal)
                           if card.isMatched {
                               button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                           }else {
                               button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)                    }
                   }
               }
                   
           }
    
    var emoji = [Int: String]()
    
    func emoji(for card: ConcentrationCard) -> String {
           if emoji[card.identifier] == nil {
               if emojiChoices.count > 0 {
                   let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                   emoji[card.identifier] = emojiChoices[randomIndex]
                   emojiChoices.remove(at: randomIndex)
               }
           }
           return emoji[card.identifier] ?? "?"
       }
}
