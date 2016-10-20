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
  
  /* Possible Modes */
  /* 
   1. Pen
   2. Rubber
   3. Highlight
  */
  var penMode: String = "pen"
  var penSize: CGFloat = 2
  var eraserSize: CGFloat = 10
  var highlightSize: CGFloat = 10
  var penColor: UIColor = UIColor.black
  var highlightColor: UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.1)
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    image?.draw(in: bounds)
    
    var touches = [UITouch]()
    
    if let coalesedTouches = event?.coalescedTouches(for: touch!){
      touches = coalesedTouches
    } else {
      touches.append(touch!)
    }
        
    //Draw according to different mode
    for touch in touches {
      drawStroke(context, touch: touch)
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

  }
  
  func drawStroke(_ context: CGContext?, touch: UITouch) {
    let previous = touch.previousLocation(in: self)
    let current = touch.location(in: self)
    
    if self.penMode == "pen" {
      //Set pen color
      penColor.setStroke()
      //Pen Size
      if touch.force > 0 {
        context?.setLineWidth(penSize * touch.force * 0.5)
      } else {
        context?.setLineWidth(penSize)
      }
      context?.setLineCap(.round)
    } else if self.penMode == "eraser" {
      context?.setLineWidth(CGFloat(eraserSize))
      context?.setLineCap(.round)
      context?.setBlendMode(.clear)
      context?.setStrokeColor(red: CGFloat(GL_RED), green: CGFloat(GL_GREEN), blue: CGFloat(GL_BLUE), alpha: CGFloat(0.0))
    } else if self.penMode == "highlight" {
      highlightColor.setStroke()
      context?.setLineWidth(CGFloat(highlightSize))
      context?.setLineCap(.square)
    }
    context?.move(to: CGPoint(x: previous.x, y: previous.y))
    context?.addLine(to: CGPoint(x: current.x, y: current.y))
    
    context?.strokePath()
  }
  
  //Set Pen Mode
  func setMyPenMode(_ mode: String) {
    self.penMode = mode
  }
  
  //Set Pen Color
  func setMyPenColor(_ color: UIColor){
    self.penColor = color
  }
  
  //Set highlight Color
  func setMyHighlightColor(_ color: UIColor){
    self.highlightColor = color
  }
  
  //Get pen size
  func getPenSize() -> CGFloat {
    return self.penSize
  }
  
  //Get rubber size
  func getRubberSize() -> CGFloat {
    return self.eraserSize
  }
  
  //Get highlight size
  func getHighlightSize() -> CGFloat {
    return self.highlightSize
  }
  
  //Undo Function
  func undo() {
    print("Undo")
  }
  
  //Redo Function
  func redo() {
    print("Redo")
  }
}
