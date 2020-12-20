//
//  CardViewContainer.swift
//  SetGame
//
//  Created by Artjola Meli on 11/11/20.
//  Copyright © 2020 Artjola Meli. All rights reserved.
//

import UIKit

class CardContainerView: UIView {
    var setCardAnimations = true
    var int = 0.0
    
    override func layoutSubviews() {
        
        let setGrid = Grid(for: self.frame, withNoOfFrames: self.subviews.count, forIdeal: 2.0)
        
        for index in self.subviews.indices{
            if var frame = setGrid[index]
            {
                frame.size.width -= 5
                frame.size.height -= 5
                var delay = 0.0
                
                if setCardAnimations {
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
                                                                   delay: int,
                                                                   options: [.transitionFlipFromTop],
                                                                   animations: {
                                                                    self.subviews[index].frame = frame
                                                                    
                                                                    delay += 3.0
                    })
                }else{
                    self.subviews[index].frame = frame
                }
            }
        }
    }
}
