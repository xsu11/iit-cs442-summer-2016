//
//  ViewController.swift
//  Simon
//
//  Created by Michael Lee on 6/27/16.
//  Copyright © 2016 Michael Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    var sequence = [Int]()
    var guessidx = 0
    var currentLevel: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "Double tap to start!"
        label.text = String(Int(slider.value))
    }
    
    func flashSequence(level: Int) {
        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        self.messageLabel.text = "Watch carefully... (Level \(level))"
        dispatch_async(queue) {
            NSThread.sleepForTimeInterval(1.0)
            self.generateSequence(level)
            for btnidx in self.sequence {
                dispatch_async(dispatch_get_main_queue()) {
                    self.buttons[btnidx].highlighted = true
                }
                NSThread.sleepForTimeInterval(1.0)
                dispatch_async(dispatch_get_main_queue()) {
                    self.buttons[btnidx].highlighted = false
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.messageLabel.text = "Tap out the sequence!"
            }
        }
    }
    
    func generateSequence(level: Int) -> Bool {
        self.sequence = []
        while self.sequence.count < level {
            let newValue = Int(arc4random_uniform(4))
            if (self.sequence.count == 0 || (self.sequence.count > 0 && newValue != self.sequence[sequence.count - 1])) {
                self.sequence.append(newValue)
            }
        }
        return true
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        if self.buttons[self.sequence[self.guessidx]] == sender {
            self.guessidx += 1
            let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            if self.guessidx == self.currentLevel {
                if self.currentLevel < Int(self.slider.value) {
                    self.messageLabel.text = "You win! Next Level!"
                    self.guessidx = 0
                    self.currentLevel = self.currentLevel! + 1
                    dispatch_async(queue) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.flashSequence(self.currentLevel!)
                        }
                        NSThread.sleepForTimeInterval(1.0)
                    }
                } else {
                    self.messageLabel.text = "BIG WIN! (Double tap to start!)"
                    self.guessidx = 0
                }
                
            } else {
                dispatch_async(queue) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = "Good guess \(self.guessidx)"
                    }
                }
            }
        } else {
            self.messageLabel.text = "Wrong!"
            self.guessidx = 0
            let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(queue) {
                // blink all buttons and restart game
                dispatch_async(dispatch_get_main_queue()) {
                    for btn in self.buttons {
                        btn.highlighted = true
                    }
                }
                NSThread.sleepForTimeInterval(1.0)
                dispatch_async(dispatch_get_main_queue()) {
                    for btn in self.buttons {
                        btn.highlighted = false
                    }
                }
                NSThread.sleepForTimeInterval(1.0)
                dispatch_async(dispatch_get_main_queue()) {
                    self.flashSequence(self.currentLevel!)
                }
            }
        }
    }
    
    @IBAction func startGame(sender: AnyObject) {
        guessidx = 0
        currentLevel = Int(self.slider.minimumValue)
        flashSequence(currentLevel!)
        
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        label.text = String(Int(sender.value))
    }
}

