//
//  AssignmentRecordCanvas.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordCanvas: UIImageView {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  var penMode: String = "pen"
  var penSize: Int = 4
  var penColor: UIColor = UIColor.black
  //var drawStack = [(CGPoint, CGPoint)]()
  //var previousImage: UIImage?
  /*
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    previousImage = UIGraphicsGetImageFromCurrentImageContext()
  }
  */
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    image?.draw(in: bounds)
    drawStroke(context, touch: touch!)
    
    image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
  }
  
  /*
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //push the last drawing into a stack
    let previous = touches.first?.previousLocation(in: self)
    let current = touches.first?.location(in: self)
    if(drawStack.count < 5) {
      drawStack.append((CGPoint(x: previous.x, y: previous.y), CGPoint(x: current.x, y: current.y)))
    }
  }
  */
  
  func drawStroke(_ context: CGContext?, touch: UITouch) {
    let previous = touch.previousLocation(in: self)
    let current = touch.location(in: self)
    
    context?.setLineWidth(CGFloat(penSize))
    context?.setLineCap(.round)
    
    context?.move(to: CGPoint(x: previous.x, y: previous.y))
    context?.addLine(to: CGPoint(x: current.x, y: current.y))
    
    context?.strokePath()
  }
  
  //Rubber
  
  //Undo Function

  //Pen size
}
