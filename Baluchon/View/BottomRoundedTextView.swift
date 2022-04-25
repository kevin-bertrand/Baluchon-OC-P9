//
//  BottomRoundedTextView.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class BottomRoundedTextView: UITextView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
    }
}
