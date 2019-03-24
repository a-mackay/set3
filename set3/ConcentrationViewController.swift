//
//  ConcentrationViewController.swift
//  set3
//
//  Created by Anthony Mackay on 26/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    var concentrationGame = ConcentrationGame(numberOfCardPairs: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        drawCards()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        concentrationGame = ConcentrationGame(numberOfCardPairs: 8)
        drawCards()
    }
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        let index = cardButtons.firstIndex(of: sender)!
        concentrationGame.selectCard(atIndex: index)
        drawCards()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private func drawCards() {
        if theme != nil {
            for (index, card) in concentrationGame.cards.enumerated() {
                let cardButton = cardButtons[index]
                if card.isMatched {
                    cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    cardButton.setTitle("", for: .normal)
                    cardButton.isEnabled = false
                } else if card.isFaceUp {
                    cardButton.isEnabled = true
                    cardButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    cardButton.setTitle(theme![card.id], for: .normal)
                } else {
                    cardButton.isEnabled = true
                    cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    cardButton.setTitle("", for: .normal)
                }
            }
        }
    }
    
    var theme: [String]? = ["😀", "🤪", "🙁", "😡", "🤢", "🥶", "😈", "🤠"]
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
