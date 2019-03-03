//
//  Card.swift
//  concentration
//
//  Created by Anthony Mackay on 14/10/18.
//  Copyright © 2018 Anthony Mackay. All rights reserved.
//

import Foundation

class ConcentrationCard {
    var isFaceUp = false
    var isMatched = false
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}
