//
//  UIViewController + Extensions.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import UIKit

//MARK: - UIAlerts
extension UIViewController {
    
    internal func showGenericAlertInfo(title: String, message: String, buttonTitle: String = "Ok", alertAction: (() -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            alertAction?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
