//
//  UIAlertControllerExtension.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 06.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func singleButtonAlert(with title: String, message: String, buttonTitle: String, buttonHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
        return controller
    }
    
    static func alert(for error: Error) -> UIAlertController {
        guard let error = error as? NetworkError else {
            return alert()
        }
        switch error {
        case .noConnection:
            let title = "No internet connection"
            let message = "It seems your device has no internet connection. Please reconnect and try again."
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            return controller
        default:
            return alert()
        }
    }
    
    static func alert() -> UIAlertController {
        let title = "Something went wrong"
        let message = "Please try again. If the error still exists please contact support."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return controller
    }
}
