//
//  PDFViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 18/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController{
  
  var scrollView: UIScrollView?
  var pdfView: UIImageView?
  var canvas: AssignmentRecordCanvas?
  var commentView: CommentView?
  
  
  var currentScale: CGFloat = 1.0
  var maxScale: CGFloat = 3.0
  var minScale: CGFloat = 1.0
  
  //Gesture
  var twoPan: UIPanGestureRecognizer?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    //Gestures
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(PDFViewController.didPinch(_:)))
    twoPan = UIPanGestureRecognizer(target: self, action: #selector(PDFViewController.didTwoPan(_:)))
    twoPan?.minimumNumberOfTouches = 2
    twoPan?.maximumNumberOfTouches = 2
    twoPan?.delaysTouchesBegan = false
    
    //Load the page of pdf
    if let parent = self.parent as? PDFPageViewController {
      //Get the page number from parent
      let pageNumber = parent.pageCurrent + 1
      //Get the width and height
      let width = parent.width
      let height = parent.height
      //Get the UIImage of pdf
      let pdf = drawPDF(parent.PDFDocument!, pageNumber, width, height)
      
      //Wrap the UIImage into UIImageView to be able to add into scrollview
      pdfView = UIImageView(image: pdf)

      pdfView?.isUserInteractionEnabled = false
      view.addSubview(pdfView!)
    }
    
    //Create canvas for drawing
    canvas = AssignmentRecordCanvas(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    self.view.backgroundColor = UIColor.white
    canvas?.isUserInteractionEnabled = true
    
    //Create a view for comments
    commentView = CommentView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    self.view.backgroundColor = UIColor.white
    commentView?.isUserInteractionEnabled = false
    
    //Wrap the pdf and canvas into a scroll view
    scrollView?.addSubview(pdfView!)
    scrollView?.addSubview(canvas!)
    scrollView?.addSubview(commentView!)
    scrollView?.delaysContentTouches = false
    scrollView?.isUserInteractionEnabled = true
    scrollView?.addGestureRecognizer(pinch)
    scrollView?.addGestureRecognizer(twoPan!)
    //Make the scrollview visible
    view.addSubview(scrollView!)
  }
  
  //Handle zoom IN/OUT event
  func didPinch(_ sender: UIPinchGestureRecognizer){
    let scale = sender.scale
    //TODO: Limit the min and max of scale each time
    let scrollView = sender.view as! UIScrollView
    if sender.state == .changed || sender.state == .ended {
      
      if minScale <= currentScale * scale && currentScale * scale <= maxScale {
        scrollView.transform = scrollView.transform.scaledBy(x: scale, y: scale)
        currentScale *= scale
      }
      
    }
    
    sender.scale = 1
  }
  
  //Handle two tap
  func didTwoPan(_ sender: UIPanGestureRecognizer){
    if sender.state == .changed {
      //Move the scrollView
      
      let scrollView = sender.view as! UIScrollView
      
      let translation = sender.translation(in: scrollView)
      sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
      /*
      let deltaY = sender.view!.center.y
      if let parent = self.parent as? PDFPageViewController {
      if (deltaY - view!.frame.size.height / 2) / currentScale < -50 {
        sender.forwardingTarget(for: #selector(parent.prevPage))
      } else if (deltaY + view!.frame.size.height / 2) / currentScale > view.frame.size.height + 50 {
        sender.forwardingTarget(for: #selector(parent.nextPage))
      }
      }
      */
      
      sender.setTranslation(CGPoint.zero, in: self.view)
    } else if sender.state == .ended {
      let deltaX = sender.view!.center.x
      let deltaY = sender.view!.center.y
      
      if (deltaX - view!.frame.size.width / 2) / currentScale < -50 {
        sender.view!.center = CGPoint(x: view!.frame.size.width / 2 * currentScale, y: deltaY)
      } else if (deltaX + view!.frame.size.width / 2) / currentScale > view.frame.size.width + 50 {
        sender.view!.center = CGPoint(x: view!.frame.size.width / 2 * currentScale, y: deltaY)
      }
      
      sender.setTranslation(CGPoint.zero, in: self.view)
    }
  }
  
  func drawPDF(_ document: CGPDFDocument, _ pageNumber: Int, _ width: CGFloat, _ height: CGFloat) -> UIImage?{
    guard let page = document.page(at: pageNumber) else { return nil }
    let pageRect = page.getBoxRect(.mediaBox)
    let size:CGSize = CGSize(width: width, height: height)
    let renderer = UIGraphicsImageRenderer(size: size)
    let img = renderer.image { ctx in
      UIColor.white.set()
      ctx.fill(pageRect)
      
      let scaleX = width / pageRect.size.width
      let scaleY = height / pageRect.size.height

      //Draw from left bottom
      ctx.cgContext.translateBy(x: 0.0, y: height);
      ctx.cgContext.scaleBy(x: scaleX, y: -scaleY);
      
      ctx.cgContext.drawPDFPage(page);
    }
    
    return img
  }
  
  func enableComment(){
    self.canvas?.isUserInteractionEnabled = false
    self.commentView?.isUserInteractionEnabled = true
  }
  
  func disableComment(){
    self.canvas?.isUserInteractionEnabled = true
    self.commentView?.isUserInteractionEnabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
