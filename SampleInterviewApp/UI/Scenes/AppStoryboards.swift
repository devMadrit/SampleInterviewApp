//
//  AppStoryboards.swift
//  SocialApp
//
//  Created by Madrit on 10/06/2019.
//  Copyright © 2019 Madrit Kacabumi. All rights reserved.
//

import UIKit
internal enum AppStoryboards: String, CaseIterable {
    
    case main = "Main"
    case authentication = "Authentication"
    case home = "Home"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    static let allValues = AppStoryboards.allCases
    
    static let valuesInString : [String] = (allCases.self).map { (appStoryBoard) -> String in
        return (appStoryBoard).rawValue
    }
    
    var storyboardItem : UIStoryboard {
        get {
            return UIStoryboard(name: self.rawValue, bundle: nil)
        }
    }
}

extension UIStoryboard {
    
    public func instantiateViewControllerSafe(withIdentifier identifier: String) -> UIViewController? {
        if let availableIdentifiers = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return self.instantiateViewController(withIdentifier: identifier)
            }
        }
        return nil
    }
}

extension UIViewController {
    //
    // create a instance of this view controller
    // for a view controller named the same way as the class
    //
    fileprivate class func _newInstance<T : UIViewController>(from storyboard: AppStoryboards = AppStoryboards.main, bundle: Bundle = Bundle.main) -> T? {
        let viewControllerName = String(describing: T.self)
        let sb = UIStoryboard(name: storyboard.rawValue, bundle: bundle);
        return sb.instantiateViewControllerSafe(withIdentifier: viewControllerName) as? T;
    }
    
    internal class func newInstance(from storyboard: AppStoryboards = AppStoryboards.main, bundle: Bundle = Bundle.main) -> Self? {
        return _newInstance(from: storyboard, bundle: bundle)
    }
}
