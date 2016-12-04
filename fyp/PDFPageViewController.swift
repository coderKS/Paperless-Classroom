//
//  PDFPageViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 18/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class PDFPageViewController: UIPageViewController, UICollectionViewDelegateFlowLayout,
  UICollectionViewDataSource {
  
  //Data from the previous controller
  var assignmentRecord: AssignmentRecord?
  
  //Navigation bar Color
  var navBarColor = Theme.navBarTintColor
  
  //Layout info
  var width:CGFloat = 0;
  var height:CGFloat = 0;
  var panelWidth:CGFloat = 0;
  var panelHeight:CGFloat = 0;
  
  //Navigation Btn
  var navBar: UINavigationBar?
  var commentNavBar: UINavigationBar?
  
  //Overview view
  var overviewView: UICollectionView?
  var overviewOverlay: UIView?
  var panelOverviewOverlay: UIView?
  var animateOffsetX: CGFloat = 500
  var overviewItemWidth:CGFloat = 100
  var overviewItemHeight:CGFloat = 200
  var overviewBackBtn: UIButton?
  
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
  
  var jsonAnnotation: JSON?
  var jsonAnnotationPages = [Int]()
  var json2PageCurrentMapping = [Int:Int]()
  
  /* Draw */
  var pageDrawObjects = [Int:[DrawObject]]()
  var redoDrawObjects = [Int:[DrawObject]]()
  var pageIsDrawn = [Int:Bool]()
  var pageLastModifiedTime = [Int:Date]()
  
  /* Possible Modes */
  /*
   1. Pen
   2. Rubber
   3. Highlight
   */
  var penMode: String = "pen"
  var penSize: CGFloat = 2
  var pencilSize: CGFloat = 2
  var eraserSize: CGFloat = 10
  var highlightSize: CGFloat = 10
  var penColor: UIColor = UIColor.black
  var pencilTexture: UIColor = UIColor(patternImage: UIImage(named: "PencilTexture")!)
  var highlightColor: UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.1)
  
  /* API */
  let api = AppAPI()
  
  /* Schedueler */
  let scheduler = Scheduler(fileId: Constants.fileId, updateTimePeriod: Float(Constants.updateTimePeriod))
  
  
  override func viewDidLoad() {
    
    
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    //gestures
    /*let prevSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PDFPageViewController.prevPage(_:)))
    prevSwipe.direction = UISwipeGestureRecognizerDirection.up
    prevSwipe.numberOfTouchesRequired = 2
    prevSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(prevSwipe)
    
    let nextSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PDFPageViewController.nextPage(_:)))
    nextSwipe.direction = UISwipeGestureRecognizerDirection.down
    nextSwipe.numberOfTouchesRequired = 2
    nextSwipe.delaysTouchesBegan = false
    self.view.addGestureRecognizer(nextSwipe)*/
    
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
    
    
    //Disable tab bar
    tabBarController?.tabBar.isHidden = true;
    
    //Disable navigation controller
    navigationController?.isNavigationBarHidden = true;
    
    //load PDF here
    loadAssignmentRecordURL()
    
    //load navigation item and bar button here
    loadNavigationItem()
    
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
    
    //load the page overview btn here
    loadPageOverviewBtn()
    
    //load the page overview view here (Not Visible)
    loadPageOverviewView()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    //Enable tabbar
    tabBarController?.tabBar.isHidden = false;
    //Enable navigation
    navigationController?.isNavigationBarHidden = false;
  }
  
  func changePage(_ currentController: PDFViewController, _ direction: UIPageViewControllerNavigationDirection){
    setViewControllers([currentController], direction: direction, animated: true, completion: nil)
//    var pointSize: CGFloat?
//    var pointColor: UIColor? = UIColor.red
//    var pointColorString: String?
//    var pointColorArray = [Int]()
//    //Draw json file here if exists
//      if jsonAnnotationPages.contains(pageCurrent) {
    
//      let map = json2PageCurrentMapping[pageCurrent]
//      for (_,subJSON):(String, JSON) in (jsonAnnotation?[map!]["data"])! {
//        
//        //let pageID = subJsonB["pageId"]
//        //let type = subJsonB["className"]
//        let str = subJSON["data"].string?.data(using: .utf8)
//        let detailsJSON = JSON(data: str!)
//        pointSize = CGFloat(detailsJSON["pointSize"].int!)
//        pointColorString = detailsJSON["pointColor"].string!
//        pointColorArray = Convertor.stringToRGB(rgbString: pointColorString!)
//        pointColor = UIColor.init(red: CGFloat(pointColorArray[0]/255), green: CGFloat(pointColorArray[1]/255), blue: CGFloat(pointColorArray[2] / 255), alpha: 1.0)
//        let pointCoordinatePairs = detailsJSON["pointCoordinatePairs"].array!
//        
//        if(pointCoordinatePairs.count == 1){
//          let current = CGPoint(x: pointCoordinatePairs[0][0].double!, y: pointCoordinatePairs[0][1].double!)
//          self.PDFViewControllers[pageCurrent].canvas?.drawFromJSON(current, current, "pen", pointColor, pointSize!)
//        } else {
//          for i in 1...pointCoordinatePairs.count - 1 {
//            let previous = CGPoint(x: pointCoordinatePairs[i - 1][0].double!, y: pointCoordinatePairs[i - 1][1].double!)
//            let current = CGPoint(x: pointCoordinatePairs[i][0].double!, y: pointCoordinatePairs[i][1].double!)
//            //print(previous, current)
//            self.PDFViewControllers[pageCurrent].canvas?.drawFromJSON(previous, current, "pen", pointColor, pointSize!)
//          }
//        }
//
//      }
//      
      //Remove the indexes afterwards
//      let index = jsonAnnotationPages.index(of: pageCurrent)
//      jsonAnnotationPages.remove(at: index!)
//    }
    
    print ("changePage#start: page=\(pageCurrent)")
    if(self.pageIsDrawn[pageCurrent]!){
      print("changePage# page \(pageCurrent) is already drawn")
      return;
    }
    
    // Try to read data from local variable
    print ("changePage#pageDrawObjects size=\(self.pageDrawObjects[pageCurrent]?.count) in pageCurrent=\(pageCurrent)")
    if let drawObjects = self.pageDrawObjects[pageCurrent] {
      if drawObjects.count == 0 {
        // Try to get data from server
        self.api.getAnnotation(fileId: Constants.fileId, pageId: String(pageCurrent+1)){
          (drawObjects, error) in
          if error != nil {
            /* Handle error here */
            return
          }
          if drawObjects == nil {
            return
          }
          if drawObjects?.count == 0 {
            return
          }
          
          self.drawObjectsToPane(drawObjects: drawObjects!, pageId: self.pageCurrent)
          print ("changePage#size of drawObject=\(drawObjects?.count)")
          self.pageDrawObjects[self.pageCurrent]? += drawObjects!
        }
        return
      }
      self.drawObjectsToPane(drawObjects: drawObjects, pageId: pageCurrent)
      return
    }
    
    // Try to get data from server
    self.api.getAnnotation(fileId: Constants.fileId, pageId: String(pageCurrent+1)){
      (drawObjects, error) in
      if error != nil {
        /* Handle error here */
        return
      }
      if drawObjects == nil {
        return
      }
      if drawObjects?.count == 0 {
        return
      }
      
      self.drawObjectsToPane(drawObjects: drawObjects!, pageId: self.pageCurrent)
      print ("changePage#size of drawObject=\(drawObjects?.count)")
      self.pageDrawObjects[self.pageCurrent]? += drawObjects!
    }
    return

    
  }
  
  func drawObjectsToPane(drawObjects: [DrawObject], pageId: Int){
    if drawObjects.count == 0 {
      return
    }
    print ("drawObjectsToPane size=\(drawObjects.count)")
    var current: CGPoint
    var previous: CGPoint
    var category: String
    var pointColor: UIColor
    var pointSize: CGFloat
    var positions: [CGPoint]
    PDFViewControllers[pageCurrent].canvas?.drawStart()
    for i in 0...(drawObjects.count) - 1 {
      switch(drawObjects[i].type){
      case DrawObjectType.Line:
        if let obj = drawObjects[i] as? Line {
          previous = obj.startPoint
          current = obj.endPoint
          category = obj.category
          pointColor = obj.color
          pointSize = obj.lineWidth
          
          self.PDFViewControllers[self.pageCurrent].canvas?.drawFromJSON(previous, current, category, pointColor, pointSize)
        }
        break
        
      case DrawObjectType.LinePath:
        if let obj = drawObjects[i] as? LinePath {
          positions = obj.positions
          category = obj.category
          pointColor = obj.color
          pointSize = obj.lineWidth
          
          if positions.count == 0 {
            return
          }
          
          if positions.count == 1{
            current = CGPoint(x: positions[0].x, y: positions[0].y)
//            self.PDFViewControllers[self.pageCurrent].canvas?.drawFromJSON(current, current, category, pointColor, pointSize)
          } else {
            print ("drawObjectsToPane#positions count=\(positions.count)")
            for j in 1...positions.count - 1 {
              previous = CGPoint(x: positions[j-1].x, y: positions[j-1].y)
              current = CGPoint(x: positions[j].x, y: positions[j].y)
              self.PDFViewControllers[self.pageCurrent].canvas?.drawFromJSON(previous, current, category, pointColor, pointSize)
            }
            print ("drawObjectsToPane# end drawing positions")
          }
          
        }
        break
        
      case DrawObjectType.ErasedLinePath:
        if let obj = drawObjects[i] as? ErasedLinePath {
          positions = obj.positions
          category = obj.category
          pointSize = obj.lineWidth
          
          if positions.count == 0 {
            return
          }
          
          if positions.count == 1 {
            current = CGPoint(x: positions[0].x, y: positions[0].y)
//            self.PDFViewControllers[self.pageCurrent].canvas?.drawFromJSON(current, current, category, nil, pointSize)
          } else {
            print ("drawObjectsToPane#positions count=\(positions.count)")
            for j in 1...positions.count - 1 {
              previous = CGPoint(x: positions[j-1].x, y: positions[j-1].y)
              current = CGPoint(x: positions[j].x, y: positions[j].y)
              self.PDFViewControllers[self.pageCurrent].canvas?.drawFromJSON(previous, current, category, nil, pointSize)
            }
            print ("drawObjectsToPane# end drawing positions")
          }
          
        }
        break
      }
    }
    PDFViewControllers[pageCurrent].canvas?.drawEnd()
    PDFViewControllers[pageCurrent].canvas?.setNeedsDisplay()
    self.pageIsDrawn[pageId] = true
  }
  
  func prevPage() {

    pageCurrent = pageCurrent - 1
    
    if pageCurrent < 0 {
      pageCurrent = PDFViewControllers.count - 1
    }
    
    let currentController = PDFViewControllers[pageCurrent]
      
    changePage(currentController, .forward)
  }
  
  func nextPage() {
    
    pageCurrent = pageCurrent + 1
    
    if pageCurrent > PDFViewControllers.count - 1 {
      pageCurrent = 0
    }
    
    let currentController = PDFViewControllers[pageCurrent]
    
    changePage(currentController, .reverse)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Init
  func loadAssignmentRecordURL() {
    let path = Bundle.main.path(forResource: "test3.pdf", ofType: nil)
    
    // Create an NSURL object based on the file path.
    let url = NSURL.fileURL(withPath: path!)
    
    PDFDocument = CGPDFDocument(url as CFURL)
    
    pageCount = PDFDocument?.numberOfPages
    //DRAW records from database
    loadAnnotationJSON(pageCount!)
    
    //Init page View Controller after loading the pdf
    for _ in 1...pageCount! {
      PDFViewControllers += [PDFViewController()]
    }
    if let firstViewController = PDFViewControllers.first {
      changePage(firstViewController, .forward)
    }
    
    
    
    
  }

  func loadAnnotationJSON(_ pageCount: Int) {
    print("loadAnnotationJSON# start, pageCount=\(pageCount)")
    // Init object
    for i in 0...pageCount - 1 {
      self.pageLastModifiedTime[i] = Date()
    }
    
    for i in 0...pageCount - 1 {
      self.pageDrawObjects[i] = [DrawObject]()
    }
    
    for i in 0...pageCount - 1 {
      self.redoDrawObjects[i] = [DrawObject]()
    }
    
    for i in 0...pageCount - 1 {
      self.pageIsDrawn[i] = false;
    }
    
//        for i in 1...pageCount {
//          self.api.getAnnotation(fileId: Constants.fileId, pageId: String(i)){
//            (drawObjects, error) in
//            print("loadAnnotationJSON# received dataobject size=\(drawObjects?.count) in page=\(i)")
//            if error != nil {
//              /* Handle error here */
//              print("loadAnnotationJSON# network error ocurred")
//              return
//            }
//            if drawObjects == nil {
//              print("loadAnnotationJSON# drawobject is null")
//              return
//            }
//    
//            if drawObjects?.count == 0 {
//              print("loadAnnotationJSON# page=\(i) is empty")
//              return
//            }
//    
//            self.pageDrawObjects[i - 1]? += drawObjects!
//          }
//    
//        }
    //MARK: TODO draw line in overview
  }
  
  func loadPageOverviewBtn(){
    let btnWidth:CGFloat = 20
    let btnHeight:CGFloat = 20
    pageOverViewBtn = UIButton(frame: CGRect(x: 5, y: (height - btnHeight) / 2, width: btnWidth, height: btnHeight))
    let arrowImg = UIImage(named: "arrow-right")
    pageOverViewBtn?.setImage(arrowImg, for: .normal)
    //pageOverViewBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI) / 180)
    pageOverViewBtn?.addTarget(self, action: #selector(showPagesOverview(_:)), for: .touchUpInside)
    
    view.addSubview(pageOverViewBtn!)
  }
  
  func loadPageOverviewView(){
    
    
    let overviewWidth:CGFloat = width / 4
    let overviewHeight:CGFloat = height + panelHeight
    
    let left:CGFloat = 0
    let top:CGFloat = 0
    
    overviewItemWidth = overviewWidth / 1.5
    overviewItemHeight = overviewHeight / 5
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: overviewHeight / 5, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: overviewItemWidth, height: overviewItemHeight)
    layout.minimumInteritemSpacing = overviewItemHeight / 5
    
    overviewView = UICollectionView(frame: CGRect(x: top, y: left, width: overviewWidth, height: overviewHeight), collectionViewLayout: layout)
    overviewView?.backgroundColor = UIColor.init(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hidePagesOverview))
    leftSwipe.direction = .left
    leftSwipe.numberOfTouchesRequired = 1
    overviewView?.addGestureRecognizer(leftSwipe)
    
    overviewView?.dataSource = self
    overviewView?.delegate = self
    overviewView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
    
    let btnWidth:CGFloat = 20
    let btnHeight:CGFloat = 20
    overviewBackBtn = UIButton(frame: CGRect(x: 5, y: (height - btnHeight) / 2, width: btnWidth, height: btnHeight))
    let arrowImg = UIImage(named: "arrow-right")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    overviewBackBtn?.setImage(arrowImg, for: .normal)
    overviewBackBtn?.tintColor = UIColor.white
    overviewBackBtn?.imageView?.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(M_PI) / 180)
    overviewBackBtn?.addTarget(self, action: #selector(hidePagesOverview(_:)), for: .touchUpInside)
    overviewView?.addSubview(overviewBackBtn!)
    
    let tap1 = UITapGestureRecognizer(target: self, action: #selector(hidePagesOverview(_:)))
    overviewOverlay = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    overviewOverlay?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    overviewOverlay?.addGestureRecognizer(tap1)
    
    let tap2 = UITapGestureRecognizer(target: self, action: #selector(hidePagesOverview(_:)))
    panelOverviewOverlay = UIView(frame: CGRect(x: 0, y: height, width: panelWidth, height: panelHeight))
    panelOverviewOverlay?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    panelOverviewOverlay?.addGestureRecognizer(tap2)
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
    navItem.setRightBarButtonItems([doneItem,redoItem,undoItem], animated: true)
    navItem.setLeftBarButtonItems([commentItem], animated: true)
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
    let penColor = getMyPenColor()
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
    let pencilColor = getMyPenColor()
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
    let penColor = getMyPenColor()
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
    setMyPenMode("pen")
    //Reset button state
    resetBtn()
    penBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func pencilBtnTapped(_ sender: UIButton){
    //Set draw mode to pencil
    setMyPenMode("pencil")
    //Reset button state
    resetBtn()
    pencilBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func textBoxBtnTapped(_ sender: UIButton){
    //Set draw mode to text Box
    setMyPenMode("textBox")
    //Reset button state
    resetBtn()
    textBoxBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func eraserBtnTapped(_ sender: UIButton){
    //Set draw mode to eraser
    setMyPenMode("eraser")
    //Reset button state
    resetBtn()
    eraserBtn?.titleLabel?.backgroundColor = UIColor.darkGray
  }
  
  func highlightBtnTapped(_ sender: UIButton){
    //Set draw mode to highlight
    setMyPenMode("highlight")
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
    //Finish and upload it back to the server
    finishAnnotation()
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
    commentNavBar?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -100))
    commentPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 200))
    UIView.animate(withDuration: 0.5, animations: {
      self.commentNavBar?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      self.commentPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
    })
    
  }
  
  func commentDoneBtnTapped(_ sender: UIButton){
    //Do sth to save the changes
    navBar?.isHidden = false
    panelView?.isHidden = false
    PDFViewControllers[pageCurrent].disableComment()
    //Save all changes
    PDFViewControllers[pageCurrent].commentView?.done()
    
    UIView.animate(withDuration: 0.5, animations: {
      self.commentNavBar?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -100))
      self.commentPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 200))
    }, completion: {_ in
      self.commentPanelView?.removeFromSuperview()
      self.commentNavBar?.removeFromSuperview()
    })
    
  }
  
  func commentCancelBtnTapped(_ sender: UIButton){
    //Abort all the changes
    navBar?.isHidden = false
    panelView?.isHidden = false
    PDFViewControllers[pageCurrent].disableComment()
    //Clear all changes
    PDFViewControllers[pageCurrent].commentView?.cancel()
    
    UIView.animate(withDuration: 0.5, animations: {
      self.commentNavBar?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -100))
      self.commentPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 200))
    }, completion: {_ in
      self.commentPanelView?.removeFromSuperview()
      self.commentNavBar?.removeFromSuperview()
    })
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
  
  func showPagesOverview(_ sender: UIScreenEdgePanGestureRecognizer){
    //Create a new view Controller pop up from the left
    
    if sender.state == .recognized {
      self.view.addSubview(overviewOverlay!)
      self.view.addSubview(panelOverviewOverlay!)
      self.view.addSubview(overviewView!)
      self.overviewView?.layer.setAffineTransform(CGAffineTransform(translationX: -animateOffsetX, y: 0))
      UIView.animate(withDuration: 0.5, animations: {
        self.overviewView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      }, completion: nil)
    }
  }
  
  func hidePagesOverview(_ sender: UISwipeGestureRecognizer){
    //Hide overviewView
    if sender.state == .recognized {
      UIView.animate(withDuration: 0.5, animations: {
        self.overviewView?.layer.setAffineTransform(CGAffineTransform(translationX: -self.animateOffsetX, y: 0))
      }, completion: {_ in
        self.overviewView?.removeFromSuperview()
        self.overviewOverlay?.removeFromSuperview()
        self.panelOverviewOverlay?.removeFromSuperview()
      })
      
    }
  }
  
  func showPenOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show pen Option panel View
      self.view.addSubview(penOptionPanelView!)
      penOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: panelHeight))
      UIView.animate(withDuration: 0.3, animations: {
        self.penOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      }, completion: nil)
    }
  }
  
  func hidePenOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide penOption panel View
      panelView?.layer.opacity = 0.001
      UIView.animate(withDuration: 0.3, animations: {
        self.panelView?.layer.opacity = 1
        self.penOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: self.panelHeight))
      }, completion: { _ in
        self.penOptionPanelView?.removeFromSuperview()
      })
    }
  }
  
  func showPencilOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show pencil Option panel View
      self.view.addSubview(pencilOptionPanelView!)
      pencilOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: panelHeight))
      UIView.animate(withDuration: 0.3, animations: {
        self.pencilOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      }, completion: nil)
    }
  }
  
  func hidePencilOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide eraser Option panel View
      panelView?.layer.opacity = 0.001
      UIView.animate(withDuration: 0.3, animations: {
        self.panelView?.layer.opacity = 1
        self.pencilOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: self.panelHeight))
      }, completion: { _ in
        self.pencilOptionPanelView?.removeFromSuperview()
      })
    }
  }
  
  func showEraserOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show eraser Option panel View
      self.view.addSubview(eraserOptionPanelView!)
      eraserOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: panelHeight))
      UIView.animate(withDuration: 0.3, animations: {
        self.eraserOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      }, completion: nil)

    }
  }

  func hideEraserOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide eraser Option panel View
      panelView?.layer.opacity = 0.001
      UIView.animate(withDuration: 0.3, animations: {
        self.panelView?.layer.opacity = 1
        self.eraserOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: self.panelHeight))
      }, completion: { _ in
        self.eraserOptionPanelView?.removeFromSuperview()
      })
    }
  }
  
  func showHighlightOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Hide panel View
      panelView?.isHidden = true
      //Show highlight Option panel View
      self.view.addSubview(highlightOptionPanelView!)
      highlightOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: panelHeight))
      UIView.animate(withDuration: 0.3, animations: {
        self.highlightOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
      }, completion: nil)
    }
  }
  
  func hideHighlightOption(_ sender: UILongPressGestureRecognizer){
    if sender.state == .began {
      //Show panel View
      panelView?.isHidden = false
      //Hide penOption panel View
      panelView?.layer.opacity = 0.001
      UIView.animate(withDuration: 0.3, animations: {
        self.panelView?.layer.opacity = 1
        self.highlightOptionPanelView?.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: self.panelHeight))
      }, completion: { _ in
        self.highlightOptionPanelView?.removeFromSuperview()
      })
      
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
    setMyHighlightColor(actualColor)
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
    setMyPenColor(color)
    //Update the current pen color label
    currentPenColorLabel?.backgroundColor = color
    //Update the pen option color label
    penOptionColorLabel?.backgroundColor = color
  }
  
  func changePenSize(_ sender: UIButton){
    penSize = CGFloat(sender.tag * 2 - 1)
  }
  
  func changePencilSize(_ sender: UIButton){
    pencilSize = CGFloat(sender.tag * 2 - 1)
  }
  
  func changeEraserSize(_ sender: UIButton) {
    eraserSize = CGFloat(sender.tag * 5 - 1)
  }
  
  func changeHighlightSize(_ sender: UIButton) {
    highlightSize = CGFloat(sender.tag * 5 - 1)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pageCount!
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
    cell.backgroundColor = UIColor.clear
    
    //Get the UIImage of pdf
    let pdf = drawPDF(PDFDocument!, indexPath.row + 1, overviewItemWidth, overviewItemHeight - 30)
    
    //Wrap the UIImage into UIImageView to be able to add into scrollview
    let pdfView = UIImageView(image: pdf)
    
    pdfView.isUserInteractionEnabled = false
    
    cell.addSubview(pdfView)
    
    let label = UILabel(frame: CGRect(x: overviewItemWidth / 2 - 40 / 2, y: overviewItemHeight - 20, width: 40, height: 20))
    let insets = UIEdgeInsets.init(top: 2, left: 0, bottom: 2, right: 0)
    label.drawText(in: UIEdgeInsetsInsetRect(label.frame, insets))
    label.text = String(indexPath.row + 1)
    label.textAlignment = .center
    label.textColor = UIColor.init(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
    label.backgroundColor = UIColor.white
    label.layer.cornerRadius = 3
    label.clipsToBounds = true
    cell.addSubview(label)
    
    let tap = UITapGestureRecognizer()
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    
    
    tap.addTarget(self, action: #selector(switchPage))
    cell.tag = indexPath.row
    cell.addGestureRecognizer(tap)
    return cell
  }
  
  func switchPage(_ sender: UITapGestureRecognizer) {
    let tag = sender.view?.tag
    let currentController = PDFViewControllers[tag!]
    if pageCurrent > tag! {
      pageCurrent = tag!
      changePage(currentController, .reverse)
    } else {
      pageCurrent = tag!
      changePage(currentController, .forward)
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
  
  //Get Pen Color
  func getMyPenColor() -> UIColor {
    return self.penColor
  }
  
  //Get Highlight Color
  func getMyHighlightColor() -> UIColor {
    return self.highlightColor
  }
  
  //Get pen size
  func getPenSize() -> CGFloat {
    return self.penSize
  }
  
  //Get pencil size
  func getPencilSize() -> CGFloat {
    return self.pencilSize
  }
  
  //Get rubber size
  func getRubberSize() -> CGFloat {
    return self.eraserSize
  }
  
  //Get highlight size
  func getHighlightSize() -> CGFloat {
    return self.highlightSize
  }
  
  
  /* API CALL */
  func finishAnnotation() {
    
  }
  
  func getAnnotation() {
    //Get the data from server
  }
  
//  func addAnnotation(_ positions: [CGPoint]) {
//    //Send the data to server
//    var size:CGFloat?
//    var color:UIColor?
//    switch self.penMode {
//    case "pen":
//      size = self.penSize
//      color = self.penColor
//      break
//    case "pencil":
//      size = self.pencilSize
//      color = self.pencilTexture
//      break
//    case "eraser":
//      size = self.eraserSize
//      color = nil
//      break
//    case "highlight":
//      size = self.highlightSize
//      color = self.highlightColor
//      break
//    default:
//      size = self.penSize
//      color = self.penColor
//      break
//    }
//    
//    //Get user details
//    let userID = 1
//    let assignmentRecordID = 1
//    let assignmentID = 1
//    
//    //Create a line path Object
//    let linePath = LinePath(positions: positions, color: color!, lineWidth: size!, category: self.penMode,
//                            pageID: pageCurrent, userID: userID, assignmentRecordID: assignmentRecordID, assignmentID: assignmentID, refId: Utilities.getReferenceId())
//    let json = LinePath.toJSON(linePath!)
//    let api = AppAPI()
//    
//    
//  }
  
  func undoAnnotation() {
    //Undo the data uploaded to server
  }
  
  func redoAnnotation() {
    //Redo the data deleted from server
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
