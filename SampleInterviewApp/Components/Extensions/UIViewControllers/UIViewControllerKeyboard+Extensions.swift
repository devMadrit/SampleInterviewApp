//
//  UIViewControllerKeyboard+Extensions.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import UIKit
extension UIViewController {
    
    public func dismissKeyboardOnViewTouch(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
