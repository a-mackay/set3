//
//  ConcentrationThemeChooserViewController.swift
//  set3
//
//  Created by Anthony Mackay on 3/3/19.
//  Copyright © 2019 Anthony Mackay. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        if let cvc = destination as? ConcentrationViewController, let button = sender as? UIButton {
            switch button.title(for: .normal) {
            case "Animals":
                cvc.theme = ["🐶", "🐱", "🐭", "🐷", "🙈", "🐸", "🦁", "🐨"]
            case "Faces":
                cvc.theme = ["😀", "🤪", "🙁", "😡", "🤢", "🥶", "😈", "🤠"]
            case "Sports":
                cvc.theme = ["🏓", "🏸", "🥊", "🛹", "🏏", "⛳️", "🏈", "🎾"]
            default: break
            }
        }
    }

}
