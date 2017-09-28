//
//  UILayoutPriority+Utils.swift
//  SwiftForms
//
//  Created by Morgan  on 28/09/2017.
//  Copyright © 2017 Miguel Angel Ortuno Ortuno. All rights reserved.
//

extension UILayoutPriority {
    
    static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        let raw = lhs.rawValue + rhs
        return UILayoutPriority(rawValue:raw)
    }
    
    static func -(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        let raw = lhs.rawValue - rhs
        return UILayoutPriority(rawValue:raw)
    }
    
}

