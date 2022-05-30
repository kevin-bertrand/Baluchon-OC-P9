//
//  ButtonStyling.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 22/05/2022.
//

import UIKit

class ButtonStyling: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        resetView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 1) {
            self.backgroundColor = .init(named: "touched-button-background")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 1) {
            self.resetView()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 1) {
            self.resetView()
        }
    }
    
    private func resetView() {
        self.backgroundColor = .init(named: "default-button-background")
    }
}
