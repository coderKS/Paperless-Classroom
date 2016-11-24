//
//  PDFViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 18/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController, UIScrollViewDelegate{
  
  var scrollView: UIScrollView?
  var pdfView: UIImageView?
  var canvas: AssignmentRecordCanvas?
  var commentView: CommentView?
  var containerView: UIView?
  
  var currentScale: CGFloat = 1.0
  var maxScale: CGFloat = 3.0
  var minScale: CGFloat = 1.0

  var lastOffsetCapture:TimeInterval = 0.0
  var isScroll = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    //Gestures
    /*let pinch = UIPinchGestureRecognizer(target: self, action: #selector(PDFViewController.didPinch(_:)))
    twoPan = UIPanGestureRecognizer(target: self, action: #selector(PDFViewController.didTwoPan(_:)))
    twoPan?.minimumNumberOfTouches = 2
    twoPan?.maximumNumberOfTouches = 2
    twoPan?.delaysTouchesBegan = false
    */
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
    canvas?.parentController = self.parent as! PDFPageViewController?
    canvas?.isUserInteractionEnabled = true
    
    //Create a view for comments
    commentView = CommentView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    self.view.backgroundColor = UIColor.white
    commentView?.isUserInteractionEnabled = false
    
    scrollView?.bouncesZoom = true
    scrollView?.bounces = true
    scrollView?.minimumZoomScale = 1
    scrollView?.maximumZoomScale = 10
    scrollView?.delegate = self
    scrollView?.setZoomScale(1, animated: true)

    
    
    scrollView?.decelerationRate = UIScrollViewDecelerationRateFast
    for gesture in (scrollView?.gestureRecognizers)! {
      if(gesture.isKind(of: UIPanGestureRecognizer.self)){
        let pan = gesture as! UIPanGestureRecognizer
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
      }
    }
    
    containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    //Wrap the pdf and canvas into a scroll view
    containerView?.addSubview(pdfView!)
    containerView?.addSubview(canvas!)
    containerView?.addSubview(commentView!)
    
    scrollView?.addSubview(containerView!)
    scrollView?.delaysContentTouches = false
    scrollView?.isUserInteractionEnabled = true
    //scrollView?.addGestureRecognizer(pinch)
    //scrollView?.addGestureRecognizer(twoPan!)
    //Make the scrollview visible
    view.addSubview(scrollView!)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentTime = Date.timeIntervalSinceReferenceDate
    let timeDiff = currentTime - lastOffsetCapture
    
    if(timeDiff > 0.5){
      //let distance = currentOffset.y - lastOffset.y
      let distance = scrollView.panGestureRecognizer.translation(in: self.view)
      let speedNotAbs = (distance.y * 10) / 1000
      
      let speed = fabsf(Float(speedNotAbs))
      print(speedNotAbs)
      if(speed > 0.4 && isScroll){
        
        let parent = self.parent as! PDFPageViewController
        
        if(speedNotAbs > 0){
          parent.nextPage()
        } else {
          parent.prevPage()
        }
        isScroll = false
      } else {
        print("A")
      }
      lastOffsetCapture = currentTime
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return containerView
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
