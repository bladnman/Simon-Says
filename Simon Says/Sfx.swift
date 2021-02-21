//
//  Sfx.swift
//  Simon Says
//
//  Created by Maher, Matt on 2/21/21.
//

import AVFoundation

class Sfx: NSObject {
    let gsa = GSAudio.sharedInstance
    func play(for tag: Int) {
        switch tag {
            case 0: gsa.playSound(soundFileName: "simonSound3", ofType: "mp3")
            case 1: gsa.playSound(soundFileName: "simonSound1", ofType: "mp3")
            case 2: gsa.playSound(soundFileName: "simonSound4", ofType: "mp3")
            case 3: gsa.playSound(soundFileName: "simonSound2", ofType: "mp3")
            default: return
        }
    }

    func playError() {
        gsa.playSound(soundFileName: "error", ofType: "wav")
    }
}
