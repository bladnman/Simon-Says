//
//  ViewController.swift
//  Simon Says
//
//  Created by Maher, Matt on 2/20/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var colorButtons: [CircularButton]!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!
    
    var currentPlayer = 0
    var scores = [0, 0]
    
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()
    
    var gameEnded = false
    
    let sfx = Sfx()
    
    var playButtonDuration: TimeInterval {
        get {
            // intro
            if colorSequence.isEmpty {
                return 0.4
            }
            
            // only a few speeds
            if colorSequence.count > 8 {
                return 0.2
            } else if colorSequence.count > 6 {
                return 0.3
            } else if colorSequence.count > 4 {
                return 0.4
            } else if colorSequence.count > 2 {
                return 0.5
            }
            
            return 0.6
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtons = colorButtons.sorted { $0.tag < $1.tag }
        playerLabels = playerLabels.sorted { $0.tag < $1.tag }
        scoreLabels = scoreLabels.sorted { $0.tag < $1.tag }
        
        createNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded == true {
            // when game is over and touch restarts
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        colorButtons.forEach {
            $0.isEnabled = false
            $0.alpha = 0.5
        }
        
        gameEnded = false
        currentPlayer = 0
        scores = [0, 0]
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.75
        
        playIntro()
    }
    
    func playIntro() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
            let ms = 1000
            let delay = 200

            self.flash(button: self.colorButtons[0])
            usleep(useconds_t(delay * ms))
            self.flash(button: self.colorButtons[1])
            usleep(useconds_t(delay * ms))
            self.flash(button: self.colorButtons[3])
            usleep(useconds_t(delay * ms))
            self.flash(button: self.colorButtons[2])
            
        }
    }
    
    func updateScoreLabels() {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1 : 0
        playerLabels[currentPlayer].alpha = 1.0
    }
    
    func addNewColor() {
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            let buttonTag = colorSequence[sequenceIndex]
            flash(button: colorButtons[buttonTag])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true // your turn
            actionButton.setTitle("Tap the Circles", for: .normal)
            colorButtons.forEach { $0.isEnabled = true }
        }
    }
    
    func flash(button: CircularButton) {
        UIView.animate(withDuration: playButtonDuration, animations: {
            self.sfx.play(for: button.tag)
            button.alpha = 1.0
            button.alpha = 0.5
        }) { _ in
            if !self.colorSequence.isEmpty {
                self.playSequence()
            }
        }
    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 wins" : "Player 1 wins"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
    }
        
    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst() {
            // correct
            sfx.play(for: sender.tag)
        } else {
            // wrong button, sorry
            colorButtons.forEach { $0.isEnabled = false }
            sfx.playError()
            endGame()
            return
        }
        
        if colorsToTap.isEmpty {
            // all correct, next player
            scores[currentPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            colorButtons.forEach { $0.isEnabled = false }
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }
    
    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false // disables all interactions for now (not your turn)
        addNewColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
}
