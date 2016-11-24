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
    var size:CGFloat?
    var color:UIColor?
    
    let positions = self.saved
    let smoothPositions = self.saved
    let pageId = parent.pageCurrent
    
    //Document Related Attributes
    let userID = 0
    let assignmentRecordID = 0
    let assignmentID = 0
    
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
    
    //Push Undo History
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: temp)
    
    //Save the last Image
    setTempImage(image)
    
    let linePath = LinePath(positions: positions, smoothPositions: smoothPositions, color:color!, lineWidth: size!, category: "pen", pageID: pageId,
                            userID: userID, assignmentRecordID: assignmentRecordID, assignmentID: assignmentID, refId: Utilities.getReferenceId())
    parent.pageDrawObjects[pageId]?.append(linePath!)
    print ("AssignmentRecordCanvas#touchesEnded- positions size=\(positions.count), pageId=\(pageId), size=\(size), pageDrawObjects[\(pageId)=\(parent.pageDrawObjects[pageId]?.count)]")
    //Add this annotation to the server
    addAnnotation()
  }

  
  func drawStroke(_ context: CGContext?, touch: UITouch, penMode: String, color: UIColor?, size: CGFloat) {
    let previous = touch.precisePreviousLocation(in: self) 
    let current = touch.preciseLocation(in: self)
    
    saved.append(CGPoint(x: Double(current.x),y: Double(current.y)))
    
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
    let parent = parentController!
    if((parent.pageDrawObjects[parent.pageCurrent]?.count)! > 0){
      let firstDrawObjects = parent.pageDrawObjects[parent.pageCurrent]?[0]
      parent.pageDrawObjects[parent.pageCurrent]?.removeFirst()
      parent.redoDrawObjects[parent.pageCurrent]?.append(firstDrawObjects!)
      
      print ("pop pageDrawObjects[\(parent.pageCurrent)], size=\(parent.pageDrawObjects[parent.pageCurrent]?.count), redoDrawObjects=\(parent.redoDrawObjects[parent.pageCurrent]?.count)")
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
  
  //For GetAnnotation
  func drawFromJSON(_ previous: CGPoint, _ current: CGPoint, _ penMode: String, _ color: UIColor?, _ size: CGFloat) {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    image?.draw(in: bounds)
    
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
    
    image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
  }
  
  //For AddAnnotation
  func addAnnotation() {
    let parent = parentController!
    let pageCurrent = parent.pageCurrent
    let scheduler = parent.scheduler
    parent.pageLastModifiedTime[pageCurrent] = Date()
    scheduler.addAnnotation(fileId: Constants.fileId, lastModifiedTime: Date(), pageDrawObjects: parent.pageDrawObjects)
    //Empty the saved positions
    saved.removeAll(keepingCapacity: false)
  }
}
