//
//  Card.swift
//  set
//
//  Created by Anthony Mackay on 11/11/18.
//  Copyright © 2018 Anthony Mackay. All rights reserved.
//

import Foundation

struct SetCard: Equatable {
    let id: Int
    
    let attributes: [Int]
    
    init(attributes: [Int], id: Int) {
        self.attributes = attributes
        self.id = id
    }

    static func createDefaultDeckOfCards() -> [SetCard] {
        let numberOfOptionsPerAttribute = 3
        var cards: [SetCard] = []
        var id = 0
        
        for a in 0..<numberOfOptionsPerAttribute {
            for b in 0..<numberOfOptionsPerAttribute {
                for c in 0..<numberOfOptionsPerAttribute {
                    for d in 0..<numberOfOptionsPerAttribute {
                        let card = SetCard(attributes: [a, b, c, d], id: id)
                        cards.append(card)
                        id = id + 1
                    }
                }
            }
        }
        return cards
    }
}
