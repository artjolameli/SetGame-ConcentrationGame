//
//  GameSelectorViewController.swift
//  MultipleMVC
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.//

import UIKit

class GameSelectorViewController: UIViewController {

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                if let themeName = button.currentTitle {
                    var themeNumber = 0
                    
                    switch themeName{
                    case "Halloween": themeNumber = 0
                    case "Sports": themeNumber = 1
                    case "Food": themeNumber = 2
                    case "Flags": themeNumber = 3
                    case "Vehicles": themeNumber = 4
                    case "Faces": themeNumber = 5
                    default:
                        break
                    }
                    
                    if let targetViewController = segue.destination as? ConcentrationGameViewController {
                        print("the selector theme number is \(themeNumber)")
                        targetViewController.emojiChoices = targetViewController.themes[themeNumber]
                        targetViewController.currentThemeNumber = themeNumber
                    }
                }
            }
        }
    }
}
