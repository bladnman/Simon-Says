//
//  CircularButton.swift
//  Simon Says
//
//  Created by Maher, Matt on 2/20/21.
//

import UIKit

class CircularButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }

}
