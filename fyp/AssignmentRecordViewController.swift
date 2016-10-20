//
//  AssignmentRecordViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordViewController: UIViewController, UIWebViewDelegate {
  
  /*** Properties ***/
  
  //Target document with assignment details
  var assignmentRecord: AssignmentRecord?
  
  //Subviews
  var assignmentRecordCanvas = [AssignmentRecordCanvas]()
  var webView: UIWebView?
  var penSizeSlider: UISlider?
  
  //Current page
  var selectedPage = 0
  var pageCount: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    //loadAssignmentRecordURL()
    //self.navigationItem.title = assignmentRecord?.studentID
    loadCanvas()
    //Hide the tabbar menu
    //self.tabBarController?.tabBar.isHidden = true
  }
  
  /*** End Properties ***/
  
  
  /*** Init ***/
  
  func loadAssignmentRecordURL() {
    //Load PDF into the Webview
    webView = UIWebView(frame: CGRect(x: 100, y: 150, width: 800, height: 1000))
    let fileExtension = "pdf"
    let localFilePath = Bundle.main.url(forResource: assignmentRecord!.assignmentURL, withExtension: fileExtension)
    let request = NSURLRequest(url: localFilePath!)
    webView?.isUserInteractionEnabled = false
    webView?.delegate = self
    webView?.scrollView.isPagingEnabled = true
    webView?.paginationMode = .leftToRight
    webView?.paginationBreakingMode = .page
    webView?.scalesPageToFit = true
    webView?.loadRequest(request as URLRequest)
    self.view.addSubview(webView!)
  }
  
  func loadCanvas() {
    //Load a UIImageView
    if pageCount! == 0 {
      pageCount = 1
    }
    for _ in 1...pageCount! {
      assignmentRecordCanvas += [AssignmentRecordCanvas(frame: CGRect(x: 100, y: 150, width: 800, height: 1000))]
    }
    assignmentRecordCanvas[selectedPage].isUserInteractionEnabled = true
    self.view.addSubview(assignmentRecordCanvas[selectedPage])
    
    //Add size slider to change pen size
    loadSizeSlider()
  }
  
  func loadSizeSlider() {
    
    //Slider Text
    let penSizeSliderLabel = UILabel(frame: CGRect(x: 10, y: 650, width: 90, height: 20))
    penSizeSliderLabel.text = "Pen Size"
    
    //Slider
    penSizeSlider = UISlider(frame: CGRect(x: 10, y: 660, width: 90, height: 30))
    
    penSizeSlider?.maximumValue = 5
    penSizeSlider?.minimumValue = 0.5
    penSizeSlider?.isContinuous = true
    
    //Default value
    penSizeSlider?.value = 2
    
    //Handler
    penSizeSlider?.addTarget(self, action: #selector(AssignmentRecordViewController.penSizeSliderValueDidChange), for: .valueChanged)
    
    //Add to main view
    self.view.addSubview(penSizeSliderLabel)
    self.view.addSubview(penSizeSlider!)
  }
  
  /*** End Init ***/
  
  
  /*** Delegate ***/
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //Make the bottom tabBar appear again
    self.tabBarController?.tabBar.isHidden = false
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    let totalHeight = webView.scrollView.contentSize.height
    
    let pageHeight = webView.scrollView.frame.size.height
    
    pageCount = Int(floor(Double(totalHeight) / Double(pageHeight)))
    
    //Add list of image view into this view to be the canvas
    loadCanvas()
  }

  /*** End Delegate ***/
  
  /*** Button Action ***/
  
  //Set to pen mode
  @IBAction func penButton(_ sender: AnyObject) {
    assignmentRecordCanvas[selectedPage].setMyPenMode("pen")
  }
  
  //Set to rubber mode
  @IBAction func EraserButton(_ sender: AnyObject) {
    assignmentRecordCanvas[selectedPage].setMyPenMode("rubber")
  }
  
  @IBAction func HighlightButton(_ sender: AnyObject) {
    assignmentRecordCanvas[selectedPage].setMyPenMode("highlight")
  }
  
  //Undo draw/erase...
  @IBAction func undoButton(_ sender: AnyObject) {
    assignmentRecordCanvas[selectedPage].undo()
  }
  
  //Clear the canvas
  @IBAction func clearButton(_ sender: AnyObject) {
    assignmentRecordCanvas[selectedPage].image = nil
  }
  
  //Navigate to previous page
  @IBAction func previousPageButton(_ sender: AnyObject) {
    let penMode: String
    if selectedPage > 0 {
      //Swap the Canvas
      assignmentRecordCanvas[selectedPage].removeFromSuperview()
      penMode = assignmentRecordCanvas[selectedPage].penMode
      selectedPage -= 1
      scrollPage(selectedPage, penMode)
    }
  }
  
  //Navigate to next page
  @IBAction func nextPageButton(_ sender: AnyObject) {
    let penMode: String
    if selectedPage < pageCount! - 1 {
      //Swap the Canvas
      assignmentRecordCanvas[selectedPage].removeFromSuperview()
      penMode = assignmentRecordCanvas[selectedPage].penMode
      selectedPage += 1
      scrollPage(selectedPage, penMode)
    }
  }

  /*** End Button Action ***/
  
  /*** Callback / Handler ***/
  
  func penSizeSliderValueDidChange(sender: UISlider!) {
    assignmentRecordCanvas[selectedPage].penSize = CGFloat(sender.value)
  }
  
  func scrollPage(_ selectedPage: Int, _ penMode: String) {
    let pageHeight = webView?.scrollView.frame.size.height
    let y = Double(selectedPage) * Double(pageHeight!)
    
    //Scroll the PDF
    self.webView?.scrollView.setContentOffset(CGPoint(x:0, y:y), animated: true)
    
    //Insert correct subview
    assignmentRecordCanvas[selectedPage].isUserInteractionEnabled = true
    self.view.addSubview(assignmentRecordCanvas[selectedPage])
    
    //subview properties inherit slider value
    assignmentRecordCanvas[selectedPage].penSize = CGFloat((penSizeSlider?.value)!)
    assignmentRecordCanvas[selectedPage].penMode = penMode
  }
  
  /*** End Callback / Handler ***/
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
