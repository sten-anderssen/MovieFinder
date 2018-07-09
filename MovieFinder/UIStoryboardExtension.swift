//
//  UIStoryboardExtension.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 04.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// Returns the "Main" storyboard file
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
