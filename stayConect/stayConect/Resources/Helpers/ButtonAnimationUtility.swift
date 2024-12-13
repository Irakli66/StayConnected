//
//  ButtonAnimationUtility.swift
//  stayConect
//
//  Created by irakli kharshiladze on 30.11.24.
//
import UIKit

class ButtonAnimationUtility {
    static func animateButtonPress(_ button: UIButton) {
        button.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                button.transform = CGAffineTransform.identity
            }) { _ in
                button.isUserInteractionEnabled = true
            }
        }
    }
}
