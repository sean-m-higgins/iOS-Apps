//
//  ViewController.swift
//  Animations
//
//  Created by Sean Higgins on 6/20/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var images: UIImageView!
    var timer = Timer()
    var counter = 1
    
    @IBAction func start_button(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.animate), userInfo: nil, repeats: true)
    }
    
    @IBAction func stop_button(_ sender: Any) {
        timer.invalidate()
    }
    
    @objc func animate() {
        images.image = UIImage(named: "frame_\(counter)_delay-0.08s.gif")
        
        counter += 1
        
        if counter == 3 {
            counter = 0
        }
    }
    
    @IBOutlet weak var button: UIButton!
    var isAnimating = false
    
    @IBAction func all_in_one_button(_ sender: Any) {
        if isAnimating {
            timer.invalidate()
            button.setTitle("Start Again", for: [])
            isAnimating = false
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.animate), userInfo: nil, repeats: true)
            button.setTitle("Stop Animation", for: [])
            isAnimating = true
        }
    }
    
    @IBAction func fade_in_button(_ sender: Any) {
        images.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.images.alpha = 1
        }
    }
    
    @IBAction func slide_in_button(_ sender: Any) {
        images.center = CGPoint(x: images.center.x - 500, y: images.center.y)
        
        UIView.animate(withDuration: 2) {
            self.images.center = CGPoint(x: self.images.center.x + 500, y: self.images.center.y)
        }
    }
    
    
    @IBAction func grow_button(_ sender: Any) {
        images.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        UIView.animate(withDuration: 1) {
            self.images.frame = CGRect(x: 0, y: 150, width: 425, height: 250)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

