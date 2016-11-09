//
//  PDFPageViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 18/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class PDFPageViewController: UIPageViewController, UIPopoverPresentationControllerDelegate {
  
  //Navigation bar Color
  var navBarColor = UIColor.init(red: 31/255, green: 37/255, blue: 53/255, alpha: 1)
  
  //Layout info
  var width:CGFloat = 0;
  var height:CGFloat = 0;
  var panelWidth:CGFloat = 0;
  var panelHeight:CGFloat = 0;
  
  //Navigation Btn
  var navBar: UINavigationBar?
  var commentNavBar: UINavigationBar?
  
  //Panel View
  var panelView: UIView?
  var commentPanelView: UIView?
  
  var penOptionPanelView: UIView?
  var eraserOptionPanelView: UIView?
  var highlightOptionPanelView: UIView?
  var pencilOptionPanelView: UIView?
  
  //List of comments
  var comments = [String]()
  
  //List of comment Btns
  var commentBtns = [UIButton]()
  
  //PDF Information
  var pageCount: Int?
  var pageCurrent = 0
  
  //Data from the previous controller
  var assignmentRecord: AssignmentRecord?
  
  //CGPDFDocument to hold the whole PDF
  var PDFDocument: CGPDFDocument?
  
  //list of pages
  var PDFViewControllers = [PDFViewController]()
  
  //list of buttons
  var pageOverViewBtn: UIButton?
  
  var penBtn: UIButton?
  var pencilBtn: UIButton?
  var eraserBtn: UIButton?
  var highlightBtn: UIButton?
  var textBoxBtn: UIButton?
  
  var clearBtn: UIButton?
  var undoBtn: UIButton?
  var redoBtn: UIButton?
  //list of labels of indicators
  var currentPenColorLabel: UILabel?
  var currentHighlightColorLabel: UILabel?
  var currentPencilColorLabel: UILabel?
  
  var penOptionColorLabel: UILabel?
  var highlightOptionColorLabel: UILabel?
  
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
    prevSwipe.numberOfTouchesRequired = 2
    prevSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(prevSwipe)
    
    let nextSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PDFPageViewController.nextPage(_:)))
    nextSwipe.direction = UISwipeGestureRecognizerDirection.down
    nextSwipe.numberOfTouchesRequired = 2
    nextSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(nextSwipe)
    
    let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(showPagesOverview))
    leftEdgePan.minimumNumberOfTouches = 2
    leftEdgePan.maximumNumberOfTouches = 2
    leftEdgePan.edges = .left
    self.view.addGestureRecognizer(leftEdgePan)
    
    
    //Init layout value
    let percentage:CGFloat = 0.92;
    width = view.frame.size.width;
    height = view.frame.size.height * percentage;
    panelWidth = view.frame.size.width;
    panelHeight = view.frame.size.height * (1 - percentage);
    print(width, height, panelHeight)
    
    //Disable tab bar
    tabBarController?.tabBar.isHidden = true;
    
    //Disable navigation controller
    navigationController?.isNavigationBarHidden = true;
    
    //load PDF here
    loadAssignmentRecordURL()
    
    //load navigation item and bar button here
    loadNavigationItem()
    
    //load the page overview btn here
    loadPageOverviewBtn()
    
    //load pen option panel here (Not Visible)
    loadPenOptionPanel()
    
    //load highlight option panel here (Not Visible)
    loadHighlightOptionPanel()
    
    //load eraser option panel here (Not Visible)
    loadEraserOptionPanel()
    
    //load pencil option panel here (Not Visible)
    loadPencilOptionPanel()
    
    //load control panel here
    loadControlPanel()
    
    //load control panel for comment!
    loadCommentControlPanel()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    //Enable tabbar
    tabBarController?.tabBar.isHidden = false;
    //Enable navigation
    navigationController?.isNavigationBarHidden = false;
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
  
  func showPagesOverview(_ sender: UIScreenEdgePanGestureRecognizer){
    //Create a new view Controller pop up from the left
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

  func loadPageOverviewBtn(){
    let btnWidth:CGFloat = 20
    let btnHeight:CGFloat = 20
    pageOverViewBtn = UIButton(frame: CGRect(x: 5, y: (height - btnHeight) / 2, width: btnWidth, height: btnHeight))
    let arrowImg = UIImage(named: "arrow-right")
    pageOverViewBtn?.setImage(arrowImg, for: .normal)
    pageOverViewBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI) / 180)
    pageOverViewBtn?.addTarget(self, action: #selector(showPagesOverview(_:)), for: .touchUpInside)
    
    view.addSubview(pageOverViewBtn!)
  }
  
  func loadNavigationItem(){
    //Navigation Bar Button
    let btnWidth: CGFloat = 40
    let btnHeight: CGFloat = 40
    //Done Button
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
    doneItem.tintColor = UIColor.white
    //Common Comments Button
    let commentBtn = UIButton(type: .custom)
    let commentImg = UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate)
    commentBtn.setImage(commentImg, for: .normal)
    commentBtn.tintColor = UIColor.white
    commentBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
    commentBtn.addTarget(self, action: #selector(commentBtnTapped), for: .touchUpInside)
    let commentItem = UIBarButtonItem(customView: commentBtn)
    //Redo Button
    let redoBtn = UIButton(type: .custom)
    let redoImg = UIImage(named: "redo")?.withRenderingMode(.alwaysTemplate)
    redoBtn.setImage(redoImg, for: .normal)
    redoBtn.tintColor = UIColor.white
    redoBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
    redoBtn.addTarget(self, action: #selector(redoBtnTapped), for: .touchUpInside)
    let redoItem = UIBarButtonItem(customView: redoBtn)
    //Undo Button
    let undoBtn = UIButton(type: .custom)
    undoBtn.setImage(redoImg, for: .normal)
    undoBtn.tintColor = UIColor.white
    undoBtn.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    //undoBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI) / 180)
    undoBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
    undoBtn.addTarget(self, action: #selector(undoBtnTapped), for: .touchUpInside)
    let undoItem = UIBarButtonItem(customView: undoBtn)
    
    navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: height * 0.05))
    navBar?.barTintColor = navBarColor
    self.view.addSubview(navBar!)
    let navItem = UINavigationItem()
    navItem.setRightBarButtonItems([doneItem,commentItem,redoItem,undoItem], animated: true)
    navBar?.setItems([navItem], animated: false);
    
    //Comment Navigation Bar
    
    let commentDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commentDoneBtnTapped))
    commentDoneItem.tintColor = UIColor.white
    
    let commentCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(commentCancelBtnTapped))
    commentCancelItem.tintColor = UIColor.white
    
    //Redo Button
    let commentRedoBtn = UIButton(type: .custom)
    let commentRedoImg = UIImage(named: "redo")?.withRenderingMode(.alwaysTemplate)
    commentRedoBtn.setImage(commentRedoImg, for: .normal)
    commentRedoBtn.tintColor = UIColor.white
    commentRedoBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
    commentRedoBtn.addTarget(self, action: #selector(commentRedoBtnTapped), for: .touchUpInside)
    let commentRedoItem = UIBarButtonItem(customView: commentRedoBtn)
    //Undo Button
    let commentUndoBtn = UIButton(type: .custom)
    commentUndoBtn.setImage(redoImg, for: .normal)
    commentUndoBtn.tintColor = UIColor.white
    commentUndoBtn.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    //undoBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI) / 180)
    commentUndoBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
    commentUndoBtn.addTarget(self, action: #selector(commentUndoBtnTapped), for: .touchUpInside)
    let commentUndoItem = UIBarButtonItem(customView: commentUndoBtn)
    
    commentNavBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: height * 0.05))
    commentNavBar?.barTintColor = navBarColor
    let commentNavItem = UINavigationItem()
    commentNavItem.setRightBarButtonItems([commentDoneItem, commentRedoItem, commentUndoItem], animated: true)
    commentNavItem.setLeftBarButtonItems([commentCancelItem], animated: true)
    commentNavBar?.setItems([commentNavItem], animated: false);
    
  }
  
  func loadControlPanel() {
    //Init panel view
    let left:CGFloat = 0.0
    let top:CGFloat = height
    panelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    panelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //panelView.layer.cornerRadius = 30
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    panelView?.layer.addSublayer(border)
    //panelView.layer.masksToBounds = true
    
    //Create button
    let btnWidth:CGFloat = 60
    let btnHeight:CGFloat = 80
    let btnSpacing:CGFloat = width / 10
    let btnOffsetY:CGFloat = 10
    let btnOffsetX:CGFloat = panelWidth / 4
    let labelWidth:CGFloat = 60
    let labelHeight:CGFloat = 10
    
    //Eraser
    eraserBtn = UIButton(frame: CGRect(x: btnOffsetX, y: btnOffsetY, width: btnWidth, height: btnHeight))
    
    let eraserImage = UIImage(named: "eraser")
    eraserBtn?.setImage(eraserImage, for: .normal)
    eraserBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    eraserBtn?.setTitle("Eraser", for: .normal)
    eraserBtn?.addTarget(self, action: #selector(eraserBtnTapped), for: .touchUpInside)
    let eraserLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showEraserOption))
    eraserLongPress.delaysTouchesBegan = false
    eraserBtn?.addGestureRecognizer(eraserLongPress)
    //End Easer
    
    //Pen
    penBtn = UIButton(frame: CGRect(x: btnOffsetX + 1 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    
    let penImage = UIImage(named: "pen")
    penBtn?.setImage(penImage, for: .normal)
    penBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    penBtn?.setTitle("Pen", for: .normal)
    penBtn?.addTarget(self, action: #selector(penBtnTapped), for: .touchUpInside)
    penBtn?.titleLabel?.backgroundColor = UIColor.darkGray
    penBtn?.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let penLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showPenOption))
    penLongPress.delaysTouchesBegan = false
    penBtn?.addGestureRecognizer(penLongPress)
    
    //Create Label
    currentPenColorLabel = UILabel(frame: CGRect(x: btnOffsetX + 1 * btnSpacing, y: btnOffsetY + btnHeight + labelHeight / 2, width:labelWidth, height: labelHeight))
    //currentPenColorLabel?.layer.cornerRadius = 10
    currentPenColorLabel?.clipsToBounds = true
    let penColor = PDFViewControllers[pageCurrent].canvas?.getMyPenColor()
    currentPenColorLabel?.backgroundColor = penColor
    //End Pen
    
    //Pencil
    pencilBtn = UIButton(frame: CGRect(x: btnOffsetX + 2 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    
    let pencilImage = UIImage(named: "pencil")
    pencilBtn?.setImage(pencilImage, for: .normal)
    pencilBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    pencilBtn?.setTitle("Pencil", for: .normal)
    pencilBtn?.addTarget(self, action: #selector(pencilBtnTapped), for: .touchUpInside)
    pencilBtn?.titleLabel?.backgroundColor = UIColor.darkGray
    pencilBtn?.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let pencilLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showPencilOption))
    pencilLongPress.delaysTouchesBegan = false
    pencilBtn?.addGestureRecognizer(pencilLongPress)
    
    //Create Label
    currentPencilColorLabel = UILabel(frame: CGRect(x: btnOffsetX + 2 * btnSpacing, y: btnOffsetY + btnHeight + labelHeight / 2, width:labelWidth, height: labelHeight))
    let pencilColor = PDFViewControllers[pageCurrent].canvas?.getMyPenColor()
    currentPenColorLabel?.backgroundColor = pencilColor
    //End Penil
    
    //Highlight Pen
    highlightBtn = UIButton(frame: CGRect(x: btnOffsetX + 3 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    
    let highlightImage = UIImage(named: "highlight")
    highlightBtn?.setImage(highlightImage, for: .normal)
    highlightBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    highlightBtn?.setTitle("Highlight", for: .normal)
    highlightBtn?.addTarget(self, action: #selector(highlightBtnTapped), for: .touchUpInside)
    let highlightLongPress = UILongPressGestureRecognizer(target: self, action: #selector(showHighlightOption))
    highlightLongPress.delaysTouchesBegan = false
    highlightBtn?.addGestureRecognizer(highlightLongPress)
    
    //Create Label
    currentHighlightColorLabel = UILabel(frame: CGRect(x: btnOffsetX + 3 * btnSpacing, y: btnOffsetY + btnHeight + labelHeight / 2, width:labelWidth, height: labelHeight))
    let highlightColor = UIColor.yellow
    currentHighlightColorLabel?.backgroundColor = highlightColor
    //End Highlight Pen
    
    //Text Box
    textBoxBtn = UIButton(frame: CGRect(x: btnOffsetX + 4 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    
    let textBoxImage = UIImage(named: "character")
    textBoxBtn?.setImage(textBoxImage, for: .normal)
    
    textBoxBtn?.setTitle("TestBox", for: .normal)
    textBoxBtn?.addTarget(self, action: #selector(textBoxBtnTapped), for: .touchUpInside)
    //End Text Box
    
    //Scale down for Animation
    penBtn?.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    eraserBtn?.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    highlightBtn?.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    pencilBtn?.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    textBoxBtn?.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    
    
    
    panelView?.addSubview(eraserBtn!)
    panelView?.addSubview(penBtn!)
    panelView?.addSubview(pencilBtn!)
    panelView?.addSubview(highlightBtn!)
    panelView?.addSubview(textBoxBtn!)
    
    panelView?.addSubview(currentPenColorLabel!)
    panelView?.addSubview(currentHighlightColorLabel!)
    panelView?.addSubview(currentPencilColorLabel!)
    
    view.addSubview(panelView!)
    
    //Animate the button
    //Only the first time
    UIView.animate(withDuration: 1.5, animations: {
      self.eraserBtn?.transform = CGAffineTransform.identity
      self.penBtn?.transform = CGAffineTransform.identity
      self.pencilBtn?.transform = CGAffineTransform.identity
      self.highlightBtn?.transform = CGAffineTransform.identity
      self.textBoxBtn?.transform = CGAffineTransform.identity
      })
  }
  
  func loadCommentControlPanel(){
    //Init comment panel view
    let left:CGFloat = 0.0
    let top:CGFloat = height
    commentPanelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    commentPanelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //panelView.layer.cornerRadius = 30
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    commentPanelView?.layer.addSublayer(border)
    
    let btnWidth:CGFloat = width / 3
    let btnHeight:CGFloat = 30
    let btnOffsetY:CGFloat = 10
    let btnOffsetX:CGFloat = panelWidth / 6
    let btnSpacing:CGFloat = 20
    //Default Comment Choice
    let commentLength = 3
    //1. Well Illustrated Point
    //2. Lack of convincing examples
    //3. Fantastic
    comments = ["Well Illustrated Point", "Lack of convincing examples", "Fantastic"]
    for i in 0...commentLength - 1 {
      let btn = UIButton(frame: CGRect(x: btnOffsetX + CGFloat(i % 2) * (btnWidth + btnSpacing), y: btnOffsetY + CGFloat(i / 2) * (btnHeight + btnSpacing), width: btnWidth, height: btnHeight))

      
      btn.addTarget(self, action: #selector(commentSelectBtnTapped), for: .touchUpInside)
      btn.layer.borderColor = UIColor.cyan.cgColor
      btn.layer.borderWidth = 2
      btn.layer.cornerRadius = 10
      btn.backgroundColor = UIColor.cyan
      btn.setTitleColor(UIColor.black, for: .normal)
      btn.setTitleColor(UIColor.white, for: .focused)
      btn.setTitle(comments[i], for: .normal)
      //Use the tag value to get the index of the comment
      btn.tag = i
      commentPanelView?.addSubview(btn)
      
      //Append to list for Visual Feedback Usage
      commentBtns.append(btn)
    }
    
    //Set the default comment
    PDFViewControllers[pageCurrent].commentView?.setComment(comments[0])
    //Set visual feedback
    commentBtns[0].backgroundColor = UIColor.init(red: 0, green: 99/255, blue: 99/255, alpha: 1)
    commentBtns[0].setTitleColor(UIColor.white, for: .normal)
    
  }
  
  func loadEraserOptionPanel(){
    let top:CGFloat = height
    let left:CGFloat = 0
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 50
    let btnSpacing:CGFloat = width / 15
    let btnOffsetY:CGFloat = panelHeight / 10 + btnHeight / 1.8
    let btnOffsetX:CGFloat = panelWidth / 15
    eraserOptionPanelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    eraserOptionPanelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //Put content here
    
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    eraserOptionPanelView?.layer.addSublayer(border)
    
    let eraserBtn = UIButton(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY - btnHeight / 2, width: btnWidth, height: btnHeight * 1.5))
    
    let eraserImage = UIImage(named: "eraser")
    eraserBtn.setImage(eraserImage, for: .normal)
    eraserBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    eraserBtn.setTitle("Eraser", for: .normal)
    eraserBtn.addTarget(self, action: #selector(eraserBtnTapped), for: .touchUpInside)
    eraserBtn.titleLabel?.backgroundColor = UIColor.darkGray
    eraserBtn.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let eraserLongPress = UILongPressGestureRecognizer(target: self, action: #selector(hideEraserOption))
    eraserLongPress.delaysTouchesBegan = false
    eraserBtn.addGestureRecognizer(eraserLongPress)
    
    //Create size button
    for i in 7...10 {
      let btn = UIButton(frame: CGRect(x: btnOffsetX + CGFloat(i) * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
      btn.backgroundColor = UIColor.cyan
      btn.layer.cornerRadius = btnWidth / 2
      let size:CGSize = CGSize(width: btnWidth * CGFloat(i) / 15, height: btnWidth * CGFloat(i) / 15)
      let renderer = UIGraphicsImageRenderer(size: size)
      let btnImg = renderer.image { ctx in
        UIColor.white.set()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15.0)
        ctx.cgContext.addPath(path.cgPath)
        ctx.cgContext.fillPath()
      }
      btn.setImage(btnImg, for: .normal)
      //The resulted pen size is btn.tag * 2 - 1
      btn.tag = i - 6
      
      eraserOptionPanelView?.addSubview(btn)
      btn.addTarget(self, action: #selector(changeEraserSize), for: .touchUpInside)
    }

    eraserOptionPanelView?.addSubview(eraserBtn)
  }
  
  func loadPenOptionPanel(){

    let top:CGFloat = height
    let left:CGFloat = 0
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 50
    let btnSpacing:CGFloat = width / 15
    let btnOffsetY:CGFloat = panelHeight / 10 + btnHeight / 1.8
    let btnOffsetX:CGFloat = panelWidth / 15
    penOptionPanelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    penOptionPanelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //Put content here
    
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    penOptionPanelView?.layer.addSublayer(border)
    
    //Color
    //Row 1: Red, Yellow
    let redBtn = UIButton(frame: CGRect(x: btnOffsetX, y: btnOffsetY, width: btnWidth, height: btnHeight))
    redBtn.backgroundColor = UIColor.red
    redBtn.layer.cornerRadius = btnWidth / 2
    redBtn.tag = 1
    redBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    
    let yellowBtn = UIButton(frame: CGRect(x: btnOffsetX + 1 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    yellowBtn.tag = 2
    yellowBtn.layer.cornerRadius = btnWidth / 2
    yellowBtn.backgroundColor = UIColor.yellow
    yellowBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    //Row 2: Green, Blue
    let greenBtn = UIButton(frame: CGRect(x: btnOffsetX + 2 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    greenBtn.backgroundColor = UIColor.green
    greenBtn.layer.cornerRadius = btnWidth / 2
    greenBtn.tag = 3
    greenBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    
    let blueBtn = UIButton(frame: CGRect(x: btnOffsetX + 3 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    blueBtn.tag = 4
    blueBtn.backgroundColor = UIColor.blue
    blueBtn.layer.cornerRadius = btnWidth / 2
    blueBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    //Row 3: Purple, Black
    let purpleBtn = UIButton(frame: CGRect(x: btnOffsetX + 4 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    purpleBtn.backgroundColor = UIColor.purple
    purpleBtn.layer.cornerRadius = btnWidth / 2
    purpleBtn.tag = 5
    purpleBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    
    let blackBtn = UIButton(frame: CGRect(x: btnOffsetX + 5 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    blackBtn.tag = 6
    blackBtn.layer.cornerRadius = btnWidth / 2
    blackBtn.backgroundColor = UIColor.black
    blackBtn.addTarget(self, action: #selector(changePenColor), for: .touchUpInside)
    
    let penBtn = UIButton(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY - btnHeight / 2, width: btnWidth, height: btnHeight * 1.5))
    
    let penImage = UIImage(named: "pen")
    penBtn.setImage(penImage, for: .normal)
    penBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    penBtn.setTitle("Pen", for: .normal)
    penBtn.addTarget(self, action: #selector(penBtnTapped), for: .touchUpInside)
    penBtn.titleLabel?.backgroundColor = UIColor.darkGray
    penBtn.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let penLongPress = UILongPressGestureRecognizer(target: self, action: #selector(hidePenOption))
    penLongPress.delaysTouchesBegan = false
    penBtn.addGestureRecognizer(penLongPress)
    
    //Create Label
    penOptionColorLabel = UILabel(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY + btnHeight, width:btnWidth, height: btnHeight / 10))
    penOptionColorLabel?.clipsToBounds = true
    let penColor = PDFViewControllers[pageCurrent].canvas?.getMyPenColor()
    penOptionColorLabel?.backgroundColor = penColor
    
    //Create size button
    for i in 7...10 {
      let btn = UIButton(frame: CGRect(x: btnOffsetX + CGFloat(i) * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
      btn.backgroundColor = UIColor.cyan
      btn.layer.cornerRadius = btnWidth / 2
      let size:CGSize = CGSize(width: btnWidth * CGFloat(i) / 15, height: btnWidth * CGFloat(i) / 15)
      let renderer = UIGraphicsImageRenderer(size: size)
      let btnImg = renderer.image { ctx in
        UIColor.white.set()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15.0)
        ctx.cgContext.addPath(path.cgPath)
        ctx.cgContext.fillPath()
      }
      btn.setImage(btnImg, for: .normal)
      //The resulted pen size is btn.tag * 2 - 1
      btn.tag = i - 6
      
      penOptionPanelView?.addSubview(btn)
      btn.addTarget(self, action: #selector(changePenSize), for: .touchUpInside)
    }
    
    penOptionPanelView?.addSubview(redBtn)
    penOptionPanelView?.addSubview(yellowBtn)
    penOptionPanelView?.addSubview(greenBtn)
    penOptionPanelView?.addSubview(blueBtn)
    penOptionPanelView?.addSubview(purpleBtn)
    penOptionPanelView?.addSubview(blackBtn)
    
    penOptionPanelView?.addSubview(penBtn)
    penOptionPanelView?.addSubview(penOptionColorLabel!)
    
  }
  
  func loadPencilOptionPanel(){
    let top:CGFloat = height
    let left:CGFloat = 0
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 50
    let btnSpacing:CGFloat = width / 15
    let btnOffsetY:CGFloat = panelHeight / 10 + btnHeight / 1.8
    let btnOffsetX:CGFloat = panelWidth / 15
    pencilOptionPanelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    pencilOptionPanelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //Put content here
    
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    pencilOptionPanelView?.layer.addSublayer(border)
    
    let pencilBtn = UIButton(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY - btnHeight / 2, width: btnWidth, height: btnHeight * 1.5))
    
    let pencilImage = UIImage(named: "pencil")
    pencilBtn.setImage(pencilImage, for: .normal)
    pencilBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    pencilBtn.setTitle("Pencil", for: .normal)
    pencilBtn.addTarget(self, action: #selector(pencilBtnTapped), for: .touchUpInside)
    pencilBtn.titleLabel?.backgroundColor = UIColor.darkGray
    pencilBtn.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let pencilLongPress = UILongPressGestureRecognizer(target: self, action: #selector(hidePencilOption))
    pencilLongPress.delaysTouchesBegan = false
    pencilBtn.addGestureRecognizer(pencilLongPress)
    
    //Create size button
    for i in 7...10 {
      let btn = UIButton(frame: CGRect(x: btnOffsetX + CGFloat(i) * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
      btn.backgroundColor = UIColor.cyan
      btn.layer.cornerRadius = btnWidth / 2
      let size:CGSize = CGSize(width: btnWidth * CGFloat(i) / 15, height: btnWidth * CGFloat(i) / 15)
      let renderer = UIGraphicsImageRenderer(size: size)
      let btnImg = renderer.image { ctx in
        UIColor.white.set()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15.0)
        ctx.cgContext.addPath(path.cgPath)
        ctx.cgContext.fillPath()
      }
      btn.setImage(btnImg, for: .normal)
      //The resulted pen size is btn.tag * 2 - 1
      btn.tag = i - 6
      
      pencilOptionPanelView?.addSubview(btn)
      btn.addTarget(self, action: #selector(changePencilSize), for: .touchUpInside)
    }
    
    pencilOptionPanelView?.addSubview(pencilBtn)
  }
  
  func loadHighlightOptionPanel(){
    let top:CGFloat = height
    let left:CGFloat = 0
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 50
    let btnSpacing:CGFloat = width / 15
    let btnOffsetY:CGFloat = panelHeight / 10 + btnHeight / 1.8
    let btnOffsetX:CGFloat = panelWidth / 15
    highlightOptionPanelView = UIView(frame: CGRect(x: left, y: top, width: panelWidth, height: panelHeight))
    highlightOptionPanelView?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    //Put content here
    
    let border = CALayer()
    border.borderColor = navBarColor.cgColor
    border.frame = CGRect(x: 0, y: 0, width:  panelWidth, height: 1.0)
    border.borderWidth = 2.0
    
    highlightOptionPanelView?.layer.addSublayer(border)
    
    //Color
    //Row 1: Red, Yellow
    let redBtn = UIButton(frame: CGRect(x: btnOffsetX, y: btnOffsetY, width: btnWidth, height: btnHeight))
    redBtn.backgroundColor = UIColor.red
    redBtn.layer.cornerRadius = btnWidth / 2
    redBtn.tag = 1
    redBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    
    let yellowBtn = UIButton(frame: CGRect(x: btnOffsetX + 1 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    yellowBtn.tag = 2
    yellowBtn.layer.cornerRadius = btnWidth / 2
    yellowBtn.backgroundColor = UIColor.yellow
    yellowBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    //Row 2: Green, Blue
    let greenBtn = UIButton(frame: CGRect(x: btnOffsetX + 2 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    greenBtn.backgroundColor = UIColor.green
    greenBtn.layer.cornerRadius = btnWidth / 2
    greenBtn.tag = 3
    greenBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    
    let blueBtn = UIButton(frame: CGRect(x: btnOffsetX + 3 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    blueBtn.tag = 4
    blueBtn.backgroundColor = UIColor.blue
    blueBtn.layer.cornerRadius = btnWidth / 2
    blueBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    //Row 3: Purple, Black
    let purpleBtn = UIButton(frame: CGRect(x: btnOffsetX + 4 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    purpleBtn.backgroundColor = UIColor.purple
    purpleBtn.layer.cornerRadius = btnWidth / 2
    purpleBtn.tag = 5
    purpleBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    
    let blackBtn = UIButton(frame: CGRect(x: btnOffsetX + 5 * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
    blackBtn.tag = 6
    blackBtn.layer.cornerRadius = btnWidth / 2
    blackBtn.backgroundColor = UIColor.black
    blackBtn.addTarget(self, action: #selector(changeHighlightColor), for: .touchUpInside)
    
    let highlightBtn = UIButton(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY - btnHeight / 2, width: btnWidth, height: btnHeight * 1.5))
    
    let highlightImage = UIImage(named: "highlight")
    highlightBtn.setImage(highlightImage, for: .normal)
    highlightBtn.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI))
    
    
    highlightBtn.setTitle("Highlight", for: .normal)
    highlightBtn.addTarget(self, action: #selector(highlightBtnTapped), for: .touchUpInside)
    highlightBtn.titleLabel?.backgroundColor = UIColor.darkGray
    highlightBtn.layer.borderColor = UIColor.darkGray.cgColor
    
    
    let highlightLongPress = UILongPressGestureRecognizer(target: self, action: #selector(hideHighlightOption))
    highlightLongPress.delaysTouchesBegan = false
    highlightBtn.addGestureRecognizer(highlightLongPress)
    
    //Create Label
    highlightOptionColorLabel = UILabel(frame: CGRect(x: btnOffsetX + 6 * btnSpacing, y: btnOffsetY + btnHeight, width:btnWidth, height: btnHeight / 10))
    highlightOptionColorLabel?.clipsToBounds = true
    //let highlightColor = PDFViewControllers[pageCurrent].canvas?.getMyHighlightColor()
    highlightOptionColorLabel?.backgroundColor = UIColor.yellow
    
    //Create size button
    for i in 7...10 {
      let btn = UIButton(frame: CGRect(x: btnOffsetX + CGFloat(i) * btnSpacing, y: btnOffsetY, width: btnWidth, height: btnHeight))
      btn.backgroundColor = UIColor.cyan
      btn.layer.cornerRadius = btnWidth / 2
      let size:CGSize = CGSize(width: btnWidth * CGFloat(i) / 15, height: btnWidth * CGFloat(i) / 15)
      let renderer = UIGraphicsImageRenderer(size: size)
      let btnImg = renderer.image { ctx in
        UIColor.white.set()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15.0)
        ctx.cgContext.addPath(path.cgPath)
        ctx.cgContext.fillPath()
      }
      btn.setImage(btnImg, for: .normal)
      //The resulted pen size is btn.tag * 2 - 1
      btn.tag = i - 6
      
      highlightOptionPanelView?.addSubview(btn)
      btn.addTarget(self, action: #selector(changeHighlightSize), for: .touchUpInside)
    }
    
    //Make all the view visible
    highlightOptionPanelView?.addSubview(redBtn)
    highlightOptionPanelView?.addSubview(yellowBtn)
    highlightOptionPanelView?.addSubview(greenBtn)
    highlightOptionPanelView?.addSubview(blueBtn)
    highlightOptionPanelView?.addSubview(purpleBtn)
    highlightOptionPanelView?.addSubview(blackBtn)
    
    highlightOptionPanelView?.addSubview(highlightBtn)
    highlightOptionPanelView?.addSubview(highlightOptionColorLabel!)
  }
  
  //Btn handler
  func penBtnTapped(_ sender: UIButton){
    //Set draw mode to pen
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("pen")
    //Reset button state
    resetBtn()
    penBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func pencilBtnTapped(_ sender: UIButton){
    //Set draw mode to pencil
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("pencil")
    //Reset button state
    resetBtn()
    pencilBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func textBoxBtnTapped(_ sender: UIButton){
    //Set draw mode to text Box
    PDFViewControllers[pageCurrent].canvas?.setMyPenMode("textBox")
    //Reset button state
    resetBtn()
    textBoxBtn?.titleLabel?.backgroundColor = UIColor.darkGray
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
    PDFViewControllers[pageCurrent].canvas?.clear()
  }
  
  func undoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].canvas?.undoManager?.undo()
  }
  
  func redoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].canvas?.undoManager?.redo()
  }
  
  func doneBtnTapped(_ sender: UIButton){
    //Return to the previous view
    performSegue(withIdentifier: "backToAssignmentRecord", sender: nil)
  }
  
  func commentBtnTapped(_ sender: UIButton){
    //Hide the original navBar
    navBar?.isHidden = true
    //Hide the pen control panel
    panelView?.isHidden = true
    //Disable drawing as well
    PDFViewControllers[pageCurrent].enableComment()
    //Make comment panel view visible
    self.view.addSubview(commentPanelView!)
    self.view.addSubview(commentNavBar!)
  }
  
  func commentDoneBtnTapped(_ sender: UIButton){
    //Do sth to save the changes
    navBar?.isHidden = false
    panelView?.isHidden = false
    PDFViewControllers[pageCurrent].disableComment()
    //Save all changes
    PDFViewControllers[pageCurrent].commentView?.done()
    
    commentPanelView?.removeFromSuperview()
    commentNavBar?.removeFromSuperview()
  }
  
  func commentCancelBtnTapped(_ sender: UIButton){
    //Abort all the changes
    navBar?.isHidden = false
    panelView?.isHidden = false
    PDFViewControllers[pageCurrent].disableComment()
    //Clear all changes
    PDFViewControllers[pageCurrent].commentView?.cancel()
    
    commentPanelView?.removeFromSuperview()
    commentNavBar?.removeFromSuperview()
  }
  
  func commentSelectBtnTapped(_ sender: UIButton){
    //Get the comment based on tag value
    let selectedComment = comments[sender.tag]
    //Draw the comment on PDFViewController
    PDFViewControllers[pageCurrent].commentView?.setComment(selectedComment)
    //Visual feedback of selected comment
    for btn in commentBtns {
      btn.backgroundColor = UIColor.cyan
      btn.setTitleColor(UIColor.black, for: .normal)
    }
    commentBtns[sender.tag].backgroundColor = UIColor.init(red: 0, green: 80/255, blue: 80/255, alpha: 1)
    commentBtns[sender.tag].setTitleColor(UIColor.white, for: .normal)
  }
  
  func commentUndoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].commentView?.undoManager?.undo()
  }
  
  func commentRedoBtnTapped(_ sender: UIButton){
    //Clear the canvas
    PDFViewControllers[pageCurrent].commentView?.undoManager?.redo()
  }
  
  func resetBtn() {
    penBtn?.titleLabel?.backgroundColor = UIColor.clear
    pencilBtn?.titleLabel?.backgroundColor = UIColor.clear
    eraserBtn?.titleLabel?.backgroundColor = UIColor.clear
    highlightBtn?.titleLabel?.backgroundColor = UIColor.clear
    textBoxBtn?.titleLabel?.backgroundColor = UIColor.clear
  }
  
  func showPenOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show pen Option panel View
      self.view.addSubview(penOptionPanelView!)
    }
  }
  
  func hidePenOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide penOption panel View
      penOptionPanelView?.removeFromSuperview()
    }
  }
  
  func showPencilOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show pencil Option panel View
      self.view.addSubview(pencilOptionPanelView!)
    }
  }
  
  func hidePencilOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide eraser Option panel View
      pencilOptionPanelView?.removeFromSuperview()
    }
  }
  
  func showEraserOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show eraser Option panel View
      self.view.addSubview(eraserOptionPanelView!)
    }
  }

  func hideEraserOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide eraser Option panel View
      eraserOptionPanelView?.removeFromSuperview()
    }
  }
  
  func showHighlightOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show highlight Option panel View
      self.view.addSubview(highlightOptionPanelView!)
    }
  }
  
  func hideHighlightOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide penOption panel View
      highlightOptionPanelView?.removeFromSuperview()
    }
  }
  
  func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
  }
  
  
  func changeHighlightColor(_ sender: UIButton){
    var color = UIColor.black
    var actualColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
    switch sender.tag {
    case 1: color = UIColor.red
      actualColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.1)
      break
    case 2: color = UIColor.yellow
      actualColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.1)
      break
    case 3: color = UIColor.green
      actualColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.1)
      break
    case 4: color = UIColor.blue
      actualColor = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
      break
    case 5: color = UIColor.purple
      actualColor = UIColor.init(red: 128/256, green: 0, blue: 128/256, alpha: 0.1)
      break
    case 6: color = UIColor.black
      actualColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
      break
    default: break
    }
    PDFViewControllers[pageCurrent].canvas?.setMyHighlightColor(actualColor)
    //Update the current highlight color label
    currentHighlightColorLabel?.backgroundColor = color
    //Update the highlight option color label
    highlightOptionColorLabel?.backgroundColor = color
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
    //Update the current pen color label
    currentPenColorLabel?.backgroundColor = color
    //Update the pen option color label
    penOptionColorLabel?.backgroundColor = color
  }
  
  func changePenSize(_ sender: UIButton){
    PDFViewControllers[pageCurrent].canvas?.penSize = CGFloat(sender.tag * 2 - 1)
  }
  
  func changePencilSize(_ sender: UIButton){
    PDFViewControllers[pageCurrent].canvas?.pencilSize = CGFloat(sender.tag * 2 - 1)
  }
  
  func changeEraserSize(_ sender: UIButton) {
    PDFViewControllers[pageCurrent].canvas?.eraserSize = CGFloat(sender.tag * 5 - 1)
  }
  
  func changeHighlightSize(_ sender: UIButton) {
    PDFViewControllers[pageCurrent].canvas?.highlightSize = CGFloat(sender.tag * 5 - 1)
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "backToAssignmentRecord" {
      
    }
  }
  
  
}
