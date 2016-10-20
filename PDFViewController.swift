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
  
  var currentScale: CGFloat = 1.0
  var maxScale: CGFloat = 3.0
  var minScale: CGFloat = 1.0
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    //Gestures
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(PDFViewController.didPinch(_:)))
    let twoPan = UIPanGestureRecognizer(target: self, action: #selector(PDFViewController.didTwoPan(_:)))
    twoPan.minimumNumberOfTouches = 2
    twoPan.maximumNumberOfTouches = 2
    //Load the page of pdf
    if let parent = self.parent as? PDFPageViewController {
      //Get the page number from parent
      let pageNumber = parent.pageCurrent + 1
      //Get the UIImage of pdf
      let pdf = drawPDF(parent.PDFDocument!, pageNumber)
      //Wrap the UIImage into UIImageView to be able to add into scrollview
      pdfView = UIImageView(image: pdf)

      pdfView?.isUserInteractionEnabled = false
      view.addSubview(pdfView!)
    }
    
    //Create canvas for drawing
    canvas = AssignmentRecordCanvas(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    self.view.backgroundColor = UIColor.white
    canvas?.isUserInteractionEnabled = true
    
    //Wrap the pdf and canvas into a scroll view
    scrollView?.addSubview(pdfView!)
    scrollView?.addSubview(canvas!)
    scrollView?.addGestureRecognizer(pinch)
    scrollView?.addGestureRecognizer(twoPan)
    scrollView?.bouncesZoom = true
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
    if sender.state == .began || sender.state == .changed {
      //Move the scrollView
      let scrollView = sender.view as! UIScrollView
      let translation = sender.translation(in: scrollView)
      sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)        
      
      sender.setTranslation(CGPoint.zero, in: self.view)
    } else if sender.state == .ended {
      
    }
  }
  
  func drawPDF(_ document: CGPDFDocument, _ pageNumber: Int) -> UIImage?{
    guard let page = document.page(at: pageNumber) else { return nil }
    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: view.frame.size)
    let img = renderer.image { ctx in
      UIColor.white.set()
      ctx.fill(pageRect)
      
      let scaleX = view.frame.size.width / pageRect.size.width
      let scaleY = view.frame.size.height / pageRect.size.height

      //Draw from left bottom
      ctx.cgContext.translateBy(x: 0.0, y: view.frame.size.height);
      ctx.cgContext.scaleBy(x: scaleX, y: -scaleY);
      
      ctx.cgContext.drawPDFPage(page);
    }
    
    return img
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
