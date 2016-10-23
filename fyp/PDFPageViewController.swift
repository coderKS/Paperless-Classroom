//
//  PDFPageViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 18/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class PDFPageViewController: UIPageViewController, UIPopoverPresentationControllerDelegate {
  
  var pageCount: Int?
  var pageCurrent = 0
  //Data from the previous controller
  var assignmentRecord: AssignmentRecord?
  
  //CGPDFDocument to hold the whole PDF
  var PDFDocument: CGPDFDocument?
  
  //list of pages
  var PDFViewControllers = [PDFViewController]()
  
  //list of buttons
  var penBtn: UIButton?
  var eraserBtn: UIButton?
  var highlightBtn: UIButton?
  var clearBtn: UIButton?
  var undoBtn: UIButton?
  var redoBtn: UIButton?
  
  //Pen Panel
  var penSizeSlider: UISlider?
  //Eraser Panel
  var eraserSizeSlider: UISlider?
  //Highlight Panel
  var highlightSizeSlider: UISlider?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    //gestures
    let prevSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PDFPageViewController.prevPage(_:)))
    prevSwipe.direction = UISwipeGestureRecognizerDirection.up
    prevSwipe.numberOfTouchesRequired = 3
    prevSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(prevSwipe)
    
    let nextSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PDFPageViewController.nextPage(_:)))
    nextSwipe.direction = UISwipeGestureRecognizerDirection.down
    nextSwipe.numberOfTouchesRequired = 3
    nextSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(nextSwipe)
    
    //load PDF here
    loadAssignmentRecordURL()
    
    //load control panel here
    loadControlPanel()
  }
  
  func prevPage(_ sender: UISwipeGestureRecognizer) {
    if sender.state == .ended{
    sender.require(toFail: PDFViewControllers[pageCurrent].twoPan!)
    
    pageCurrent = pageCurrent - 1
    
    if pageCurrent < 0 {
      pageCurrent = PDFViewControllers.count - 1
    }
    
    let currentController = PDFViewControllers[pageCurrent]
    
    setViewControllers([currentController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  func nextPage(_ sender: UISwipeGestureRecognizer) {
    if sender.state == .ended{
    sender.require(toFail: PDFViewControllers[pageCurrent].twoPan!)
    
    pageCurrent = pageCurrent + 1
    
    if pageCurrent > PDFViewControllers.count - 1 {
      pageCurrent = 0
    }
    
    let currentController = PDFViewControllers[pageCurrent]
    
    setViewControllers([currentController], direction: .reverse, animated: true, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Init
  func loadAssignmentRecordURL() {
    let path = Bundle.main.path(forResource: "test_2.pdf", ofType: nil)
    
    // Create an NSURL object based on the file path.
    let url = NSURL.fileURL(withPath: path!)
    
    PDFDocument = CGPDFDocument(url as CFURL)
    
    pageCount = PDFDocument?.numberOfPages
    //Init page View Controller after loading the pdf
    for _ in 1...pageCount! {
      PDFViewControllers += [PDFViewController()]
    }
    if let firstViewController = PDFViewControllers.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }

  func loadControlPanel() {
    let left:CGFloat = 0.0
    let top:CGFloat = view.frame.height * 0.3
    let panelHeight = view.frame.height * 0.4
    let panelWidth:CGFloat = 100.0
    let panelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    panelView.backgroundColor = UIColor.lightGray
    //Create button
    let btnWidth:CGFloat = 80
    let btnHeight:CGFloat = 40
    let btnSpacing:CGFloat = 45
    
    penBtn = UIButton(frame: CGRect(x: 0.0, y: 1 * btnSpacing, width: btnWidth, height: btnHeight))
    penBtn?.setTitle("Pen", for: .normal)
    penBtn?.addTarget(self, action: #selector(penBtnTapped), for: .touchUpInside)
    penBtn?.titleLabel?.backgroundColor = UIColor.darkGray
    let penLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showPenOption))
    penLongPress.numberOfTapsRequired = 1
    penLongPress.allowableMovement = 50.0
    penLongPress.minimumPressDuration = 0.5
    penLongPress.delaysTouchesBegan = false
    penBtn?.addGestureRecognizer(penLongPress)
    
    eraserBtn = UIButton(frame: CGRect(x: 0.0, y: 2 * btnSpacing, width: btnWidth, height: btnHeight))
    eraserBtn?.setTitle("Eraser", for: .normal)
    eraserBtn?.addTarget(self, action: #selector(eraserBtnTapped), for: .touchUpInside)
    let eraserLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showEraserOption))
    eraserLongPress.numberOfTapsRequired = 1
    eraserLongPress.allowableMovement = 50.0
    eraserLongPress.minimumPressDuration = 0.5
    eraserLongPress.delaysTouchesBegan = false
    eraserBtn?.addGestureRecognizer(eraserLongPress)
    
    
    highlightBtn = UIButton(frame: CGRect(x: 0.0, y: 3 * btnSpacing, width: btnWidth, height: btnHeight))
    highlightBtn?.setTitle("Highlight", for: .normal)
    highlightBtn?.addTarget(self, action: #selector(highlightBtnTapped), for: .touchUpInside)
    let highlightLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showHighlightOption))
    highlightLongPress.numberOfTapsRequired = 1
    highlightLongPress.allowableMovement = 50.0
    highlightLongPress.minimumPressDuration = 0.5
    highlightLongPress.delaysTouchesBegan = false
    highlightBtn?.addGestureRecognizer(highlightLongPress)
    
    clearBtn = UIButton(frame: CGRect(x: 0.0, y: 4 * btnSpacing, width: btnWidth, height: btnHeight))
    clearBtn?.setTitle("Clear", for: .normal)
    clearBtn?.addTarget(self, action: #selector(clearBtnTapped), for: .touchUpInside)
    
    undoBtn = UIButton(frame: CGRect(x: 0.0, y: 5 * btnSpacing, width: btnWidth, height: btnHeight))
    undoBtn?.setTitle("Undo", for: .normal)
    undoBtn?.addTarget(self, action: #selector(undoBtnTapped), for: .touchUpInside)
    
    redoBtn = UIButton(frame: CGRect(x: 0.0, y: 6 * btnSpacing, width: btnWidth, height: btnHeight))
    redoBtn?.setTitle("Redo", for: .normal)
    redoBtn?.addTarget(self, action: #selector(redoBtnTapped), for: .touchUpInside)
    
    panelView.addSubview(penBtn!)
    panelView.addSubview(eraserBtn!)
    panelView.addSubview(highlightBtn!)
    panelView.addSubview(clearBtn!)
    panelView.addSubview(undoBtn!)
    panelView.addSubview(redoBtn!)
    view.addSubview(panelView)
  }
  
  //Btn handler
  func penBtnTapped(_ sender: UIButton){
    //Set draw mode to pen
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("pen")
    //Reset button state
    resetBtn()
    penBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func eraserBtnTapped(_ sender: UIButton){
    //Set draw mode to eraser
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("eraser")
    //Reset button state
    resetBtn()
    eraserBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func highlightBtnTapped(_ sender: UIButton){
    //Set draw mode to highlight
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("highlight")
    //Reset button state
    resetBtn()
    highlightBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func clearBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].canvas?.drawingImage = nil
    PDFViewControllers[pageCurrent].canvas?.image = nil
  }
  
  func undoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].canvas?.undoManager?.undo()
  }
  
  func redoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].canvas?.undoManager?.redo()
  }
  
  func resetBtn() {
    penBtn?.titleLabel?.backgroundColor = UIColor.lightGray
    eraserBtn?.titleLabel?.backgroundColor = UIColor.lightGray
    highlightBtn?.titleLabel?.backgroundColor = UIColor.lightGray
  }
  
  func showPenOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .ended {
      //Call an new view controller (another panel)
      
      //TODO: a custom view controller for pen panel
      //Now this is temporary implemented in here
      let viewController = UIViewController()
      //Put content here
      
      //Slider Text
      let penSizeSliderLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 80, height: 30))
      penSizeSliderLabel.text = "Pen Size"
      
      //Slider
      penSizeSlider = UISlider(frame: CGRect(x: 5, y: 40, width: 80, height: 20))
      
      penSizeSlider?.maximumValue = 10
      penSizeSlider?.minimumValue = 0.5
      penSizeSlider?.isContinuous = true
      
      //Default value
      let penSize = PDFViewControllers[pageCurrent].canvas?.penSize
      penSizeSlider?.value = Float(penSize!)
      
      //Handler
      penSizeSlider?.addTarget(self, action: #selector(penSizeSliderValueDidChange), for: .valueChanged)
      
      //Color
      //Row 1: Red, Yellow
      let redBtn = UIButton(frame: CGRect(x: 10, y: 70, width: 30, height: 30))
      redBtn.backgroundColor = UIColor.red
      redBtn.tag = 1
      redBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      
      let yellowBtn = UIButton(frame: CGRect(x: 60, y: 70, width: 30, height: 30))
      yellowBtn.tag = 2
      yellowBtn.backgroundColor = UIColor.yellow
      yellowBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      //Row 2: Green, Blue
      let greenBtn = UIButton(frame: CGRect(x: 10, y: 110, width: 30, height: 30))
      greenBtn.backgroundColor = UIColor.green
      greenBtn.tag = 3
      greenBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      
      let blueBtn = UIButton(frame: CGRect(x: 60, y: 110, width: 30, height: 30))
      blueBtn.tag = 4
      blueBtn.backgroundColor = UIColor.blue
      blueBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      //Row 3: Purple, Black
      let purpleBtn = UIButton(frame: CGRect(x: 10, y: 150, width: 30, height: 30))
      purpleBtn.backgroundColor = UIColor.purple
      purpleBtn.tag = 5
      purpleBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      
      let blackBtn = UIButton(frame: CGRect(x: 60, y: 150, width: 30, height: 30))
      blackBtn.tag = 6
      blackBtn.backgroundColor = UIColor.black
      blackBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
      
      //Make all the view visible
      viewController.view.addSubview(penSizeSliderLabel)
      viewController.view.addSubview(penSizeSlider!)
      
      viewController.view.addSubview(redBtn)
      viewController.view.addSubview(yellowBtn)
      viewController.view.addSubview(greenBtn)
      viewController.view.addSubview(blueBtn)
      viewController.view.addSubview(purpleBtn)
      viewController.view.addSubview(blackBtn)
      
      //Configure the popover
      viewController.modalPresentationStyle = .popover
      viewController.preferredContentSize = CGSize(width: 150, height: 200)
      let popoverViewController = viewController.popoverPresentationController
      popoverViewController?.dismissalTransitionDidEnd(true)
      popoverViewController?.permittedArrowDirections = .left
      popoverViewController?.delegate = self
      popoverViewController?.sourceView = sender.view
      popoverViewController?.sourceRect = CGRect(
        x: sender.location(in: sender.view).x,
        y: sender.location(in: sender.view).y,
        width: 1,
        height: 1)
      present(
        viewController,
        animated: false,
        completion: nil)
      
    }
  }
  
  func showEraserOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .ended {
      //Call an new view controller (another panel)
      
      //TODO: a custom view controller for pen panel
      //Now this is temporary implemented in here
      let viewController = UIViewController()
      //Put content here
      
      //Slider Text
      let eraserSizeSliderLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 80, height: 30))
      eraserSizeSliderLabel.text = "Eraser Size"
      
      //Slider
      eraserSizeSlider = UISlider(frame: CGRect(x: 5, y: 40, width: 80, height: 20))
      
      eraserSizeSlider?.maximumValue = 50
      eraserSizeSlider?.minimumValue = 1
      eraserSizeSlider?.isContinuous = true
      
      //Default value
      let eraserSize = PDFViewControllers[pageCurrent].canvas?.eraserSize
      eraserSizeSlider?.value = Float(eraserSize!)
      
      //Handler
      eraserSizeSlider?.addTarget(self, action: #selector(eraserSizeSliderValueDidChange), for: .valueChanged)
      
      //Make all the view visible
      viewController.view.addSubview(eraserSizeSliderLabel)
      viewController.view.addSubview(eraserSizeSlider!)

      //Configure the popover
      viewController.modalPresentationStyle = .popover
      viewController.preferredContentSize = CGSize(width: 150, height: 200)
      let popoverViewController = viewController.popoverPresentationController
      popoverViewController?.dismissalTransitionDidEnd(true)
      popoverViewController?.permittedArrowDirections = .left
      popoverViewController?.delegate = self
      popoverViewController?.sourceView = sender.view
      popoverViewController?.sourceRect = CGRect(
        x: sender.location(in: sender.view).x,
        y: sender.location(in: sender.view).y,
        width: 1,
        height: 1)
      present(
        viewController,
        animated: false,
        completion: nil)
    }
  }

  func showHighlightOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .ended {
      //Call an new view controller (another panel)
      
      //TODO: a custom view controller for pen panel
      //Now this is temporary implemented in here
      let viewController = UIViewController()
      //Put content here
      
      //Slider Text
      let highlightSizeSliderLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 80, height: 30))
      highlightSizeSliderLabel.text = "Highlight Size"
      
      //Slider
      highlightSizeSlider = UISlider(frame: CGRect(x: 5, y: 40, width: 80, height: 20))
      
      highlightSizeSlider?.maximumValue = 30
      highlightSizeSlider?.minimumValue = 5
      highlightSizeSlider?.isContinuous = true
      
      //Default value
      let highlightSize = PDFViewControllers[pageCurrent].canvas?.highlightSize
      highlightSizeSlider?.value = Float(highlightSize!)
      
      //Handler
      highlightSizeSlider?.addTarget(self, action: #selector(highlightSizeSliderValueDidChange), for: .valueChanged)
      
      //Color
      //Row 1: Red, Yellow
      let redBtn = UIButton(frame: CGRect(x: 10, y: 70, width: 30, height: 30))
      redBtn.backgroundColor = UIColor.red
      redBtn.tag = 1
      redBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      
      let yellowBtn = UIButton(frame: CGRect(x: 60, y: 70, width: 30, height: 30))
      yellowBtn.tag = 2
      yellowBtn.backgroundColor = UIColor.yellow
      yellowBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      //Row 2: Green, Blue
      let greenBtn = UIButton(frame: CGRect(x: 10, y: 110, width: 30, height: 30))
      greenBtn.backgroundColor = UIColor.green
      greenBtn.tag = 3
      greenBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      
      let blueBtn = UIButton(frame: CGRect(x: 60, y: 110, width: 30, height: 30))
      blueBtn.tag = 4
      blueBtn.backgroundColor = UIColor.blue
      blueBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      //Row 3: Purple, Black
      let purpleBtn = UIButton(frame: CGRect(x: 10, y: 150, width: 30, height: 30))
      purpleBtn.backgroundColor = UIColor.purple
      purpleBtn.tag = 5
      purpleBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      
      let blackBtn = UIButton(frame: CGRect(x: 60, y: 150, width: 30, height: 30))
      blackBtn.tag = 6
      blackBtn.backgroundColor = UIColor.black
      blackBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
      
      //Make all the view visible
      viewController.view.addSubview(highlightSizeSliderLabel)
      viewController.view.addSubview(highlightSizeSlider!)
      
      viewController.view.addSubview(redBtn)
      viewController.view.addSubview(yellowBtn)
      viewController.view.addSubview(greenBtn)
      viewController.view.addSubview(blueBtn)
      viewController.view.addSubview(purpleBtn)
      viewController.view.addSubview(blackBtn)
      
      //Configure the popover
      viewController.modalPresentationStyle = .popover
      viewController.preferredContentSize = CGSize(width: 150, height: 200)
      let popoverViewController = viewController.popoverPresentationController
      popoverViewController?.dismissalTransitionDidEnd(true)
      popoverViewController?.permittedArrowDirections = .left

      popoverViewController?.delegate = self
      popoverViewController?.sourceView = sender.view
      popoverViewController?.sourceRect = CGRect(
        x: sender.location(in: sender.view).x,
        y: sender.location(in: sender.view).y,
        width: 1,
        height: 1)
      present(
        viewController,
        animated: false,
        completion: nil)
    }
  }
  
  func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
  }
  
  
  func changeHighlightColor(_ sender: UIButton){
    var color = UIColor.black
    switch sender.tag {
    case 1: color = UIColor.red
      break
    case 2: color = UIColor.yellow
      break
    case 3: color = UIColor.green
      break
    case 4: color = UIColor.blue
      break
    case 5: color = UIColor.purple
      break
    case 6: color = UIColor.black
      break
    default: break
    }
    PDFViewControllers[pageCurrent].canvas?.setMyHighlightColor(color)
  }
  
  func changePenColor(_ sender: UIButton){
    var color = UIColor.black
    switch sender.tag {
    case 1: color = UIColor.red
      break
    case 2: color = UIColor.yellow
      break
    case 3: color = UIColor.green
      break
    case 4: color = UIColor.blue
      break
    case 5: color = UIColor.purple
      break
    case 6: color = UIColor.black
      break
    default: break
    }
    PDFViewControllers[pageCurrent].canvas?.setMyPenColor(color)
  }
  
  func penSizeSliderValueDidChange(sender: UISlider!) {
    PDFViewControllers[pageCurrent].canvas?.penSize = CGFloat(sender.value)
  }
  
  func eraserSizeSliderValueDidChange(sender: UISlider!) {
    PDFViewControllers[pageCurrent].canvas?.eraserSize = CGFloat(sender.value)
  }
  
  func highlightSizeSliderValueDidChange(sender: UISlider!) {
    PDFViewControllers[pageCurrent].canvas?.highlightSize = CGFloat(sender.value)
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
