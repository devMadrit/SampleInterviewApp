//
//  BaseViewController.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import UIKit

internal class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboardUtilities()
    }
    
    private func loadKeyboardUtilities(){
        dismissKeyboardOnViewTouch()
    }
}
