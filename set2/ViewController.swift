//
//  ViewController.swift
//  set2
//
//  Created by Anthony Mackay on 2/2/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let setGame = SetGame()

    @IBOutlet weak var GridView: UIView!
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
    }
    
    @IBAction func touchDraw3CardsButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

