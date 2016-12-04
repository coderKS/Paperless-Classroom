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
  
  var size:CGFloat?
  var color:UIColor?
  var aTouches = [UITouch]()
  var context: CGContext?
  var pageCurrent = 0
  var touch: UITouch?
  var coalesedTouches = [UITouch]()
  var previous = CGPoint()
  var current = CGPoint()
  /* Draw Method */
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    touch = touches.first!
    if touch == nil { return }
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    context = UIGraphicsGetCurrentContext()
    image?.draw(in: bounds)
    
    aTouches = [UITouch]()
    coalesedTouches = (event?.coalescedTouches(for: touch!))!
    if coalesedTouches.count > 0{
      aTouches = coalesedTouches
    } else {
      aTouches.append(touch!)
    }
    
    //Draw according to different mode in PDF page at pageCurrent
    
    switch parentController!.penMode {
    case "pen":
      size = parentController!.penSize
      color = parentController!.penColor
      break
    case "pencil":
      size = parentController!.pencilSize
      color = parentController!.pencilTexture
      break
    case "eraser":
      size = parentController!.eraserSize
      color = nil
      break
    case "highlight":
      size = parentController!.highlightSize
      color = parentController!.highlightColor
      break
    default:
      size = parentController!.penSize
      color = parentController!.penColor
      break
    }
    
    for touch in aTouches {
      drawStroke(context, touch: touch, penMode: parentController!.penMode, color: color, size: size!)
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
//    var size:CGFloat?
//    var color:UIColor?
    
//    let positions = self.saved
//    let smoothPositions = self.saved
    let pageId = parentController!.pageCurrent
    
    //Document Related Attributes
    let userID = 0
    let assignmentRecordID = 0
    let assignmentID = 0
    
    switch parentController!.penMode {
    case "pen":
      size = parentController!.penSize
      color = parentController!.penColor
      
      break
    case "pencil":
      size = parentController!.pencilSize
      color = parentController!.pencilTexture
      break
    case "eraser":
      size = parentController!.eraserSize
      color = nil
      break
    case "highlight":
      size = parentController!.highlightSize
      color = parentController!.highlightColor
      break
    default:
      size = parentController!.penSize
      color = parentController!.penColor
      break
    }
    
    //Push Undo History
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: temp)
    
    //Save the last Image
    setTempImage(image)
    
    let linePath = LinePath(positions: self.saved, smoothPositions: self.saved, color:color!, lineWidth: size!, category: "pen", pageID: pageId,
                            userID: userID, assignmentRecordID: assignmentRecordID, assignmentID: assignmentID, refId: Utilities.getReferenceId())
    parentController!.pageDrawObjects[pageId]?.append(linePath!)
    print ("AssignmentRecordCanvas#touchesEnded- positions size=\(self.saved.count), pageId=\(pageId), size=\(size), pageDrawObjects[\(pageId)=\(parentController!.pageDrawObjects[pageId]?.count)]")
    //Add this annotation to the server
    addAnnotation()
  }

  
  func drawStroke(_ context: CGContext?, touch: UITouch, penMode: String, color: UIColor?, size: CGFloat) {
    previous = touch.precisePreviousLocation(in: self)
    current = touch.preciseLocation(in: self)
    
    saved.append(CGPoint(x: Double(current.x),y: Double(current.y)))
    
    if penMode == "pen" {
      //Set pen color
      color?.setStroke()
      //context?.setBlendMode(.copy)
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
      context?.setBlendMode(.copy)
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
    self.temp = nil
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
    //undoManager?.registerUndo(withTarget: self, selector: #selector(redo), object: image)
    //drawingImage = sender
    setCurrentImage(sender)
    setTempImage(sender)
    //print("Undo")
    //let parent = parentController!
    if((parentController!.pageDrawObjects[parentController!.pageCurrent]?.count)! > 0){
      let firstDrawObjects = parentController!.pageDrawObjects[parentController!.pageCurrent]?[0]
      parentController!.pageDrawObjects[parentController!.pageCurrent]?.removeFirst()
      parentController!.redoDrawObjects[parentController!.pageCurrent]?.append(firstDrawObjects!)
      
      print ("pop pageDrawObjects[\(parentController!.pageCurrent)], size=\(parentController!.pageDrawObjects[parentController!.pageCurrent]?.count), redoDrawObjects=\(parentController!.redoDrawObjects[parentController!.pageCurrent]?.count)")
    }
  }
  
  //Redo Function
  func redo(_ sender: UIImage) {
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: image)
    //drawingImage = sender
    setCurrentImage(sender)
    setTempImage(sender)
    //print("Redo")
    let parent = parentController!
    let redoSize = (parent.redoDrawObjects[parent.pageCurrent]?.count)!
    if( redoSize > 0){
      let lastDrawObjects = parent.redoDrawObjects[parent.pageCurrent]?[redoSize-1]
      parent.redoDrawObjects[parent.pageCurrent]?.removeLast()
      parent.pageDrawObjects[parent.pageCurrent]?.append(lastDrawObjects!)
      
      print ("push pageDrawObjects[\(parent.pageCurrent)], size=\(parent.pageDrawObjects[parent.pageCurrent]?.count), redoDrawObjects=\(parent.redoDrawObjects[parent.pageCurrent]?.count)")
    }
  }
  func drawStart(){
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    context = UIGraphicsGetCurrentContext()
    image?.draw(in: bounds)
  }
  
  func drawEnd(){
    DispatchQueue.main.sync { () -> Void in
      self.image = self.webTemp
      self.webTemp = nil
    }
    UIGraphicsEndImageContext()
  }
  var webTemp: UIImage?
  //For GetAnnotation
  func drawFromJSON(_ previous: CGPoint, _ current: CGPoint, _ penMode: String, _ color: UIColor?, _ size: CGFloat) {
    
    
    if penMode == "pen" {
      //Set pen color
      color?.setStroke()
      //Pen Size
      
      context?.setLineWidth(size)
      
      context?.setLineCap(.round)
    } else if penMode == "pencil" {
      //Set pen color
      color?.setStroke()
      //Pen Size
      context?.setLineWidth(size)
      
    } else if penMode == "eraser" {
      context?.setLineWidth(size)
      context?.setLineCap(.round)
      context?.setBlendMode(.clear)
      context?.setStrokeColor(red: CGFloat(GL_RED), green: CGFloat(GL_GREEN), blue: CGFloat(GL_BLUE), alpha: CGFloat(0.0))
    } else if penMode == "highlight" {
      color?.setStroke()
      context?.setBlendMode(.copy)
      context?.setLineWidth(size)
      context?.setLineCap(.square)
    }
    
    context?.move(to: CGPoint(x: previous.x, y: previous.y))
    context?.addLine(to: CGPoint(x: current.x, y: current.y))
    
    context?.strokePath()
    
    
    webTemp = UIGraphicsGetImageFromCurrentImageContext()
  }
  
  //For AddAnnotation
//  var scheduler = self.parentController!.scheduler
  
  func addAnnotation() {
    pageCurrent = parentController!.pageCurrent
    parentController!.pageLastModifiedTime[pageCurrent] = Date()
    parentController!.scheduler.addAnnotation(fileId: Constants.fileId, lastModifiedTime: Date(), pageDrawObjects: parentController!.pageDrawObjects)
    //Empty the saved positions
    saved = [CGPoint]()
  }
}
