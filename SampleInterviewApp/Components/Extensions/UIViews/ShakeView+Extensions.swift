//
//  ShakeView+Extensions.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import UIKit

extension UIView {
    
    public func performShakeAnimation(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
