//
//  CircularTransition.swift
//  fyp
//
//  Created by Ka Hong Ngai on 25/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CircularTransition: NSObject {
  
  var circle = UIView()
  
  var startingPoint = CGPoint.zero {
    didSet {
      circle.center = startingPoint
    }
  }
  
  var circleColor = UIColor.white
  
  var duration = 0.4
  
  enum CircularTransitionMode: Int {
    case present, dismiss
  }
  
  var transitionMode:CircularTransitionMode = .present
}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    
    if transitionMode == .present {
      if let presentedView = transitionContext.view(forKey: .to){
        let viewCenter = presentedView.center
        let viewSize = presentedView.frame.size
        let exitPoint = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        circle = UIView()
        
        circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize)
        
        circle.layer.cornerRadius = circle.frame.size.width / 2
        circle.center = exitPoint
        circle.backgroundColor = UIColor.darkGray
        circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        containerView.addSubview(circle)
        
        presentedView.center = exitPoint
        presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        presentedView.alpha = 0
        containerView.addSubview(presentedView)
        
        UIView.animate(withDuration: duration, animations: {
          self.circle.transform = CGAffineTransform.identity
          presentedView.transform = CGAffineTransform.identity
          presentedView.alpha = 1
          presentedView.center = exitPoint
          }, completion: { (success:Bool) in
            transitionContext.completeTransition(success)
        })
      }
    } else {
      
      if let presentedView = transitionContext.view(forKey: .to) {
        let viewCenter = presentedView.center
        let viewSize = presentedView.frame.size
        let exitPoint = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        
        let circle = UIView()
        
        circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize)
        
        circle.layer.cornerRadius = circle.frame.size.width / 2
        circle.center = exitPoint
        circle.backgroundColor = UIColor.gray
        //circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        containerView.addSubview(circle)
        
        presentedView.center = exitPoint
        //presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        presentedView.alpha = 0
        containerView.addSubview(presentedView)
        
        let returningView = transitionContext.view(forKey: .from)
        returningView?.alpha = 1
        containerView.addSubview(returningView!)
        
        UIView.animate(withDuration: duration, animations: {
          circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
          presentedView.alpha = 1
          //presentedView.transform = CGAffineTransform.identity
          //presentedView.center = exitPoint
          
          returningView?.alpha = 0
          returningView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
          returningView?.center = exitPoint
          }, completion: { (success:Bool) in
            
            returningView?.removeFromSuperview()
            circle.removeFromSuperview()
            
            transitionContext.completeTransition(success)
        })
        
      }
    }
  }
  
  func frameForCircle(withViewCenter viewCenter:CGPoint, size viewSize:CGSize) -> CGRect {
    let xLength = viewSize.width / 2
    let yLength = viewSize.height / 2
    
    let offset = sqrt(xLength * xLength + yLength * yLength) * 2
    let size = CGSize(width: offset, height: offset)
    
    return CGRect(origin: CGPoint.zero, size: size)
  }
}
