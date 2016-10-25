//
//  navigationDelegate.swift
//  fyp
//
//  Created by Ka Hong Ngai on 25/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class navigationDelegate: NSObject, UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let transition = CircularTransition()
    transition.circleColor = UIColor.darkGray
    if operation == .push {
      transition.transitionMode = .present
    } else if operation == .pop {
      transition.transitionMode = .dismiss
    }
    return transition
  }
}
