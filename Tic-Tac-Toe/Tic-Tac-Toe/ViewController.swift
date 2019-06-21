//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Sean Higgins on 6/20/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var active_game = true
    var controller = 1
    var game_state = [0,0,0,0,0,0,0,0,0] // 0 = empty, 1 = O, 2 = X
    let winning_combinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    
    @IBOutlet weak var player_1_score: UILabel!
    var player_1 = 0
    @IBOutlet weak var player_2_score: UILabel!
    var player_2 = 0
    
    @IBAction func button_press(_ sender: AnyObject) {
        let active_position = sender.tag - 1
        
        if game_state[active_position] == 0 && active_game {
            
            game_state[active_position] = controller
            
            if controller == 1 {
                sender.setImage(UIImage(named: "O.jpeg"), for: [])
                controller = 2
            } else {
                sender.setImage(UIImage(named: "X.jpeg"), for: [])
                controller = 1
            }
            
            for combination in winning_combinations {
                if game_state[combination[0]] != 0 && game_state[combination[0]] == game_state[combination[1]] && game_state[combination[0]] == game_state[combination[2]] {
                    
                    active_game = false
                    
                    self.winning_message.text = "Congratulations Player \(game_state[combination[0]]) - You Win!"
                    
                    if game_state[combination[0]] == 1 {
                        self.player_1 += 1
                        self.player_1_score.text = "Player 1: \(player_1)"
                    } else {
                        self.player_2 += 1
                        self.player_2_score.text = "Player 2: \(player_2)"
                    }
                }
            }
        }
    }
    
    @IBAction func start_over(_ sender: Any) {
        active_game = true
        controller = 1
        game_state = [0,0,0,0,0,0,0,0,0]
        
        for i in 1..<10 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.setImage(nil, for: [])
            }
        }
        
        winning_message.text = ""
    }
    
    @IBOutlet weak var winning_message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

