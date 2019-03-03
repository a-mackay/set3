//
//  Concentration.swift
//  concentration
//
//  Created by Anthony Mackay on 14/10/18.
//  Copyright © 2018 Anthony Mackay. All rights reserved.
//

import Foundation

class ConcentrationGame {
    var cards = [ConcentrationCard]()
    var score = 0
    
    func isGameComplete() -> Bool {
        return cards.allSatisfy { $0.isMatched }
    }
    
    func selectCard(atIndex index: Int) {
        if !cards[index].isFaceUp {
            score += 1
            let numberOfFaceUpCards = getNumberOfFaceUpCards()
            if numberOfFaceUpCards == 2 {
                flipAllCardsFaceDown()
                cards[index].isFaceUp = true
            } else {
                cards[index].isFaceUp = true
            }
            checkCardMatches()
        }
    }
    
    func checkCardMatches() {
        let faceUpIdCounts = cards.reduce(into: [Int: Int]()) { (dict, card) in
            if card.isFaceUp {
                let id = card.id
                if dict.keys.contains(id) {
                    dict[id] = dict[id]! + 1
                } else {
                    dict[id] = 1
                }
            }
        }
        let faceUpIdCountsWithCountOfTwo = faceUpIdCounts.filter { (_, value: Int) -> Bool in
            value == 2
        }
        for (id, _) in faceUpIdCountsWithCountOfTwo {
            for card in cards {
                if card.id == id {
                    card.isMatched = true
                }
            }
        }
    }
    
    func flipAllCardsFaceDown() {
        for card in cards {
            card.isFaceUp = false
        }
    }
    
    func getNumberOfFaceUpCards() -> Int {
        let value = cards.reduce(0) {
            (accumulator: Int, card: ConcentrationCard) -> Int in card.isFaceUp ? accumulator + 1 : accumulator
        }
        return value
    }
    
    func getIdOfTheOnlyFaceUpCard() -> Int? {
        for card in cards {
            if card.isFaceUp {
                return card.id
            }
        }
        return nil
    }
    
    init(numberOfCardPairs: Int) {
        for id in 0..<numberOfCardPairs {
            let card = ConcentrationCard(id: id)
            let matchingCard = ConcentrationCard(id: id)
            cards.append(card)
            cards.append(matchingCard)
        }
        cards.shuffle()
    }
}
