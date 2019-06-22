//
//  ViewController.swift
//  Audio-Shaker
//
//  Created by Sean Higgins on 6/21/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()
    let allegretto_path = Bundle.main.path(forResource: "allegretto", ofType: "mp3")
    let balloon_path = Bundle.main.path(forResource: "balloon", ofType: "mp3")
    let bells_path = Bundle.main.path(forResource: "bells", ofType: "mp3")
    let comedy_path = Bundle.main.path(forResource: "comedy", ofType: "mp3")
    let cow_path = Bundle.main.path(forResource: "cow", ofType: "mp3")
    let guitar_path = Bundle.main.path(forResource: "guitar", ofType: "mp3")
    let paint_spray_path = Bundle.main.path(forResource: "paint-spray", ofType: "mp3")
    let paper_cutter_path = Bundle.main.path(forResource: "paper-cutter", ofType: "mp3")
    let sci_fy_path = Bundle.main.path(forResource: "sci-fy", ofType: "mp3")
    
    @IBOutlet weak var volume_slider: UISlider!
    @IBOutlet weak var scrubber_slider: UISlider!
    @IBOutlet weak var shaker_label: UILabel!
    @IBOutlet weak var tune_guess: UITextField!
    @IBOutlet weak var tune_guess_label: UILabel!
    @IBOutlet weak var tune_hint_label: UILabel!
    var tune_guess_id = -1
    var number_of_guesses = 0
    @IBOutlet weak var hint_label: UIButton!
    @IBOutlet weak var guess_label: UIButton!
    @IBOutlet weak var replay_label: UIButton!
    
    var timer = Timer()
    
    @IBAction func play_button(_ sender: Any) {
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateScrubber), userInfo: nil, repeats: true)
    }
    
    @IBAction func pause_button(_ sender: Any) {
        player.pause()
        timer.invalidate()
    }

    @IBAction func stop_button(_ sender: Any) {
        player.stop()
        timer.invalidate()
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: allegretto_path!))
        } catch {
            //Process any errors
        }
        
        scrubber_slider.value = 0
    }
    
    
    @IBAction func scrubberSliderMovement(_ sender: Any) {
        player.currentTime = TimeInterval(scrubber_slider.value)
    }
    
    @IBAction func volumeSliderMovement(_ sender: Any) {
        player.volume = volume_slider.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize the audio player and song
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: allegretto_path!))
            
            scrubber_slider.maximumValue = Float(player.duration)
        } catch {
            //Process any errors
        }
        
        // swipe functionality
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(gesture:)))
        swipe_right.direction = UISwipeGestureRecognizer.Direction.right
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(gesture:)))
        swipe_left.direction = UISwipeGestureRecognizer.Direction.left
        // add swipe to screen
        self.view.addGestureRecognizer(swipe_right)
        self.view.addGestureRecognizer(swipe_left)
        
        // set text box, guess button, hint button invisible
        self.tune_guess.alpha = 0
        self.guess_label.alpha = 0
        self.hint_label.alpha = 0
        self.replay_label.alpha = 0
    }

    @objc func updateScrubber() {
        scrubber_slider.value = Float(player.currentTime)
    }
    
    // to detect a shake...
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            self.shaker_label.text = ""
            self.tune_guess.text = ""
            self.tune_guess_label.text = ""
            self.tune_hint_label.text = ""
            self.hint_label.alpha = 0
            
            self.shaker_label.text = "You shook the device! Guess that tune."
            self.tune_guess.alpha = 1
            self.guess_label.alpha = 1
            self.replay_label.alpha = 1
            
            var tune_path = ""
            let random_number = Int.random(in: 0 ... 7)
            
            switch random_number {
            case 0:
                tune_path = self.balloon_path!
                self.tune_guess_id = 0
            case 1:
                tune_path = self.bells_path!
                self.tune_guess_id = 1
            case 2:
                tune_path = self.comedy_path!
                self.tune_guess_id = 2
            case 3:
                tune_path = self.cow_path!
                self.tune_guess_id = 3
            case 4:
                tune_path = self.guitar_path!
                self.tune_guess_id = 4
            case 5:
                tune_path = self.paint_spray_path!
                self.tune_guess_id = 5
            case 6:
                tune_path = self.paper_cutter_path!
                self.tune_guess_id = 6
            case 7:
                tune_path = self.sci_fy_path!
                self.tune_guess_id = 7
            default:
                self.tune_guess_id = -1
                break
            }
            
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: tune_path))
            } catch {
                //Process any errors
            }
            
            player.play()
            
        }
    }
    
    @IBAction func guess_button(_ sender: Any) {
        let guess = tune_guess.text
        number_of_guesses += 1
        
        let correct = "Correct! Nice guess! Shake again for new tune."
        let incorrect = "Sorry that's not it, try again!"
        
        if tune_guess_id != -1 {
            switch tune_guess_id {
            case 0:
                if guess == "balloon" || guess == "Balloon" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 1:
                if guess == "bells" || guess == "Bells" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 2:
                if guess == "comedy" || guess == "Comedy" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 3:
                if guess == "cow" || guess == "Cow" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 4:
                if guess == "guitar" || guess == "Guitar" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 5:
                if guess == "paint spray" || guess == "Paint spray" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 6:
                if guess == "paper cutter" || guess == "Paper cutter" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            case 7:
                if guess == "sci-fy" || guess == "Sci-fy" {
                    self.tune_guess_label.text = correct
                    self.number_of_guesses = 0
                } else {
                    self.tune_guess_label.text = incorrect
                }
            default:
                break
            }
        }
        
        if number_of_guesses > 5 {
            self.hint_label.alpha = 1
        }
    }
    
    @IBAction func replay_button(_ sender: Any) {
        player.play()
    }
    
    @IBAction func hint_button(_ sender: Any) {
        if number_of_guesses > 5 {
            tune_hint_label.text = "Options: balloon, bells, comedy, cow, guitar, paint spray, paper cutter, or sci-fy."
        }
    }
    
    // to detect a swipe... (can also have swipe up, down, etc.)
    @objc func swiped(gesture: UIGestureRecognizer) {
        if let swipe_gesture = gesture as? UISwipeGestureRecognizer {
            switch swipe_gesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("User swiped right")
            case UISwipeGestureRecognizer.Direction.left:
                print("User swiped left")
            default:
                break
            }
        }
    }
}

