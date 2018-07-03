//
//  UIViewControllerExtension.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private static let kFadeInAnimationDuration: TimeInterval = 0.2
    
    func loadChildViewController(_ childViewController: UIViewController, in containerView: UIView) {
        loadChildViewController(childViewController, in: containerView, animated: false)
    }
    
    func loadChildViewController(_ childViewController: UIViewController, in containerView: UIView, animated: Bool) {
        addChildViewController(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: childViewController.view, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: childViewController.view, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: childViewController.view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: childViewController.view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([trailing, leading, top, bottom])
        childViewController.didMove(toParentViewController: self)
        
        guard animated else {
            return
        }
        
        let view = childViewController.view
        view?.alpha = 0.0
        UIView.animate(withDuration: UIViewController.kFadeInAnimationDuration, animations: {
            view?.alpha = 1.0
        })
    }
    
    func unloadChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
}
