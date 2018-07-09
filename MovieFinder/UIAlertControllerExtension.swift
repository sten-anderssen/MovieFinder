//
//  UIAlertControllerExtension.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 06.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Returns an UIAlertController with a single button.
    ///
    /// - Parameters:
    ///   - title: The title of the alert controller
    ///   - message: The message of the alert controller
    ///   - buttonTitle: The button title of the button
    ///   - buttonHandler: The handler that should be invocated after the user taps on the button
    /// - Returns: The created alert controller
    static func singleButtonAlert(with title: String, message: String, buttonTitle: String, buttonHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
        return controller
    }
    
    /// Returns an UIAlertController with a single "Ok" button for a given error.
    ///
    /// - Parameter error: The error for creating a title and message for the controller
    /// - Returns: The created alert controller
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
    
    /// Returns an UIAlertController with a single "Ok" button and a default error title and message.
    ///
    /// - Returns: The created alert controller
    static func alert() -> UIAlertController {
        let title = "Something went wrong"
        let message = "Please try again. If the error still exists please contact support."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return controller
    }
}
