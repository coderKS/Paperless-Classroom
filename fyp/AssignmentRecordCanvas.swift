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
  
  //var drawingImage: UIImage?
  
  var temp: UIImage?
  var parentController: PDFPageViewController?
  var saved = [CGPoint]()
  
  /* Draw Method */
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    image?.draw(in: bounds)
    
    var touches = [UITouch]()
    
    if let coalesedTouches = event?.coalescedTouches(for: touch){
      touches = coalesedTouches
    } else {
      touches.append(touch)
    }
    
    //Draw according to different mode in PDF page at pageCurrent
    var size:CGFloat?
    var color:UIColor?
    let parent = parentController!
    let penMode = parent.penMode
    switch penMode {
    case "pen":
      size = parent.penSize
      color = parent.penColor
      break
    case "pencil":
      size = parent.pencilSize
      color = parent.pencilTexture
      break
    case "eraser":
      size = parent.eraserSize
      color = nil
      break
    case "highlight":
      size = parent.highlightSize
      color = parent.highlightColor
      break
    default:
      size = parent.penSize
      color = parent.penColor
      break
    }
    
    for touch in touches {
      drawStroke(context, touch: touch, penMode: penMode, color: color, size: size!)
    }
    
    /*
     drawingImage = UIGraphicsGetImageFromCurrentImageContext()
     
     if let predictedTouches = event?.predictedTouches(for: touch) {
     for touch in predictedTouches {
     drawStroke(context, touch: touch)
     }
     }
     */
    image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //image = drawingImage
    
    //If pen mode is textBox
    let parent = parentController!
    let penMode = parent.penMode
    if penMode == "textBox" {
      //Draw a editable text field
      //Ask for keyboard input
    }
    
    //Push Undo History
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: temp)
    
    //Save the last Image
    setTempImage(image)
    
    //Create a line path Object
    var size:CGFloat?
    var color:UIColor?
    switch penMode {
    case "pen":
      size = parent.penSize
      color = parent.penColor
      break
    case "pencil":
      size = parent.pencilSize
      color = parent.pencilTexture
      break
    case "eraser":
      size = parent.eraserSize
      color = nil
      break
    case "highlight":
      size = parent.highlightSize
      color = parent.highlightColor
      break
    default:
      size = parent.penSize
      color = parent.penColor
      break
    }
    let linePath = LinePath(positions: saved, color: color!, lineWidth: size!, category: parent.penMode,
                            userID: 1, assignmentRecordID: 1, assignmentID: 1)
    
    //Empty the saved positions
    saved.removeAll(keepingCapacity: false)
    //API Call to addAnnotation
    parentController?.addAnnotation(linePath!)
  }

  
  func drawStroke(_ context: CGContext?, touch: UITouch, penMode: String, color: UIColor?, size: CGFloat) {
    let previous = touch.previousLocation(in: self)
    let current = touch.location(in: self)
    
    saved.append(CGPoint(x: current.x, y: current.y))
    
    if penMode == "pen" {
      //Set pen color
      color?.setStroke()
      //Pen Size
      if touch.force > 0 {
        context?.setLineWidth(size * touch.force * 0.5)
      } else {
        context?.setLineWidth(size)
      }
      context?.setLineCap(.round)
    } else if penMode == "pencil" {
      //Set pen color
      color?.setStroke()
      //Pen Size
      if touch.force > 0 {
        context?.setLineWidth(size * touch.force * 0.5)
      } else {
        context?.setLineWidth(size)
      }
    } else if penMode == "eraser" {
      context?.setLineWidth(size)
      context?.setLineCap(.round)
      context?.setBlendMode(.clear)
      context?.setStrokeColor(red: CGFloat(GL_RED), green: CGFloat(GL_GREEN), blue: CGFloat(GL_BLUE), alpha: CGFloat(0.0))
    } else if penMode == "highlight" {
      color?.setStroke()
      context?.setLineWidth(size)
      context?.setLineCap(.square)
    }
    context?.move(to: CGPoint(x: previous.x, y: previous.y))
    context?.addLine(to: CGPoint(x: current.x, y: current.y))
    
    context?.strokePath()
  }
  
  func textToImage(drawText text: NSString, atPoint point: CGPoint) -> UIImage {
    let textColor = UIColor.white
    let textFont = UIFont(name: "Helvetica Bold", size: 12)!
    
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions((image?.size)!, false, scale)
    
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
      ] as [String : Any]
    image?.draw(in: CGRect(origin: CGPoint.zero, size: (image?.size)!))
    
    let rect = CGRect(origin: point, size: (image?.size)!)
    text.draw(in: rect, withAttributes: textFontAttributes)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func getImage() -> UIImage? {
    return self.image
  }
  
  func getTemp() -> UIImage? {
    return self.temp
  }
  
  func setTempImage(_ new:UIImage?) {
    self.temp = new
  }
  
  func setCurrentImage(_ new:UIImage?) {
    self.image = new
  }
  
  //Clear Function
  func clear(){
    undoManager?.registerUndo(withTarget: self, selector: #selector(redo), object: image)
    //drawingImage = nil
    setCurrentImage(nil)
    setTempImage(nil)
  }
  
  //Undo Function
  func undo(_ sender: UIImage) {
    undoManager?.registerUndo(withTarget: self, selector: #selector(redo), object: image)
    //drawingImage = sender
    setCurrentImage(sender)
    setTempImage(sender)
    //print("Undo")
  }
  
  //Redo Function
  func redo(_ sender: UIImage) {
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: image)
    //drawingImage = sender
    setCurrentImage(sender)
    setTempImage(sender)
    //print("Redo")
  }
}
