//
//  Set.swift
//  set
//
//  Created by Anthony Mackay on 11/11/18.
//  Copyright © 2018 Anthony Mackay. All rights reserved.
//

import Foundation

class SetGame {
    private var deck = SetCard.createDefaultDeckOfCards().shuffled()
    var cardsInPlay: [SetCard] = []
    private(set) var selectedCards: [SetCard] = []
    private(set) var score: Int = 0
    private var discardedCards: [SetCard] = []
    private(set) var numberOfStartingCards = 12
    private var maxNumberOfCardsInPlay = 81
    
    func hasAMatch() -> Bool {
        return SetGame.hasAMatch(selectedCards: self.selectedCards)
    }
    
    func isDeckEmpty() -> Bool {
        return deck.isEmpty
    }
    
    private static func hasAMatch(selectedCards: [SetCard]) -> Bool {
        if selectedCards.count == 3 {
            let firstCard = selectedCards[0]
            let secondCard = selectedCards[1]
            let thirdCard = selectedCards[2]
            let numberOfAttributes = firstCard.attributes.count
            for attributeIndex in 0..<numberOfAttributes {
                let firstAttribute = firstCard.attributes[attributeIndex]
                let secondAttribute = secondCard.attributes[attributeIndex]
                let thirdAttribute = thirdCard.attributes[attributeIndex]
                let attributeOptions = [firstAttribute, secondAttribute, thirdAttribute]
                if !allEqual(attributeOptions) && !allUnequal(attributeOptions) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    private static func allEqual(_ attributeOptions: [Int]) -> Bool {
        if attributeOptions.isEmpty {
            preconditionFailure("attributeOptions cannot be empty")
        }
        let set = Set(attributeOptions)
        return set.count == 1
    }
    
    private static func allUnequal(_ attributeOptions: [Int]) -> Bool {
        if attributeOptions.isEmpty {
            preconditionFailure("attributeOptions cannot be empty")
        }
        let set = Set(attributeOptions)
        return set.count == 3
    }
    
    private func dealCards(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            if deck.count > 0 && cardsInPlay.count < maxNumberOfCardsInPlay {
                let dealtCard = deck.remove(at: 0)
                cardsInPlay.append(dealtCard)
            }
        }
    }
    
    func dealCard() {
        dealCards(numberOfCards: 1)
    }
    
    func shuffleCardsInPlay() {
        self.cardsInPlay.shuffle()
    }
    
    func touchCard(atIndex index: Int) {
        if !cardsInPlay.indices.contains(index) {
            preconditionFailure("Index is not in the indices of the cards in play")
        }
        
        let touchedCard = cardsInPlay[index]

        if hasAMatch() {
            cardsInPlay.remove(elements: selectedCards)
            discardedCards.append(contentsOf: selectedCards)
            selectedCards.removeAll()
            score = score + 1
        } else if selectedCards.count == 3 {
            selectedCards.removeAll()
            selectedCards.append(touchedCard)
            score = score - 5
        } else {
            if let index = selectedCards.index(of: touchedCard) {
                selectedCards.remove(at: index)
            } else {
                selectedCards.append(touchedCard)
            }
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(elements: [Element]) {
        for element in elements {
            if let index = self.index(of: element) {
                self.remove(at: index)
            } else {
                preconditionFailure("Element \(element) was not in array")
            }
        }
    }
}
