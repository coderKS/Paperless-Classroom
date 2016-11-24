//
//  CourseViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 20/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController,
  //For Table View
  UITableViewDelegate, UITableViewDataSource,
  //For Collection View
  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,
  //Bar position
  UIBarPositioningDelegate {
  
  var userId = "king"
  var coursesSections = [String]()
  var courses = [[Course]]()
  
  var width:CGFloat = 0
  
  //Tableview
  @IBOutlet weak var listViewBtn: UIButton!
  @IBOutlet weak var collectionViewBtn: UIButton!
  
  @IBOutlet weak var homeBtn: UIButton!
  //var courseTableView = UITableView()
  @IBOutlet weak var courseTableView: UITableView!
  @IBOutlet weak var secondaryMenuView: UIView!
  
  @IBOutlet weak var courseCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    width = self.view.frame.width
    
    let nib = UINib(nibName: "CourseTableViewHeaderView", bundle: nil)
    self.courseTableView.register(nib, forHeaderFooterViewReuseIdentifier: "CourseTableViewHeaderView")
    
    //Init the background color
    self.courseCollectionView.backgroundColor = Theme.navigationBackgroundColor
    self.courseTableView.backgroundColor = Theme.navigationBackgroundColor
    self.secondaryMenuView.backgroundColor = Theme.navigationBarTintColor
    //self.view.backgroundColor = Theme.navigationBackgroundColor
    
    //Init the button
    initSecondaryMenu()
    
    //Configure Navigation Bar
    navigationController?.navigationBar.barTintColor = UIColor.black
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.navigationBarTextColor, NSFontAttributeName: UIFont.init(name: "Arial", size: 30)!]
    navigationItem.setHidesBackButton(true, animated: true)
      
    
    
    // Remove the courseCollectionView first
    self.courseCollectionView.isHidden = true
    self.courseTableView.isHidden = false
    self.view.bringSubview(toFront: secondaryMenuView)
    
    //Load Course
    loadCourse()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return UIBarPosition.topAttached
  }
  
  //Init
  func loadCourse() {
    print("loadCourse# start")
    let connectorType = ConnectorType.Veriguide
    print("loadCourse# connectorType=\(connectorType)")
    let api = AppAPI(connectorType: connectorType)
    if(api == nil){
      print ("Fail to load api")
      
    }
    api!.getCourseList(userId: self.userId){
      (courses, error) in
      if (error != nil){
        //handle error here
        return
      }
      self.coursesSections = ["This Semester", "2015 - 2016 Term 2"]
      for _ in 1...self.coursesSections.count {
        self.courses.append(courses!)
      }
      DispatchQueue.main.async(){
        //code
        self.animateTable()
      }
    }
  }
  
  func animateTable() {
    courseTableView.reloadData()
    let cells = courseTableView.visibleCells
    let tableHeight: CGFloat = courseTableView.bounds.size.height
    
    for i in cells {
      let cell: UITableViewCell = i as UITableViewCell
      cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
    }
    
    var index = 0
    
    for a in cells {
      let cell: UITableViewCell = a as UITableViewCell
      UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
        cell.transform = CGAffineTransform(translationX: 0, y: 0);
      }, completion: nil)
      
      index += 1
    }
    
  }
  
  func animateCollection() {
    courseCollectionView.reloadData()
    courseCollectionView.layoutIfNeeded()
    let cells = courseCollectionView.visibleCells
    let tableHeight: CGFloat = courseCollectionView.bounds.size.height
    print(cells)
    for i in cells {
      let cell: UICollectionViewCell = i as UICollectionViewCell
      cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
    }
    
    var index = 0
    
    for a in cells {
      let cell: UICollectionViewCell = a as UICollectionViewCell
      UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
        cell.transform = CGAffineTransform(translationX: 0, y: 0);
      }, completion: nil)
      
      index += 1
    }
  }
  
  func initSecondaryMenu() {
    var img = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
    listViewBtn.setImage(img, for: .normal)
    listViewBtn.tintColor = Theme.navigationBarTextColor
    
    img = UIImage(named: "collection")?.withRenderingMode(.alwaysTemplate)
    collectionViewBtn.setImage(img, for: .normal)
    
    collectionViewBtn.tintColor = UIColor.darkGray//Theme.navigationBarTextColor
    
    img = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
    homeBtn.setImage(img, for: .normal)
    homeBtn.tintColor = Theme.navigationBarTextColor
  }
  
  /************************************* Table View Related **********************************/
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100.0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return coursesSections.count //1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return courses[section].count
  }
  
  /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return coursesSections[section]
  }*/
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "CourseTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
    // Configure the cell...
    let course = courses[indexPath.section][indexPath.row]
    cell.name.text = course.name
    cell.courseCode.text = course.code
    cell.enrollmentNumber.text = String(course.enrollmentNumber)
    cell.teacher.text = "Irwin King" //course.teacher
    return cell
  }

  /*func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont(name: "Helvetica Neue", size: CGFloat(40.0))
    header.textLabel?.textColor = UIColor.darkGray
    header.contentView.backgroundColor = Theme.navigationBackgroundColor
  }*/
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = courseTableView.dequeueReusableHeaderFooterView(withIdentifier: "CourseTableViewHeaderView") as! CourseTableViewHeaderView
    
    var font = UIFont(name: "Helvetica Neue", size: CGFloat(40.0))
    let color = UIColor.darkGray
    
    header.name.font = font
    header.name?.textColor = color
    header.name.text = coursesSections[section]
    
    font = UIFont(name: "Helvetica Neue", size: CGFloat(20.0))
    header.enrollmentNumber.font = font
    header.enrollmentNumber.textColor = color
    header.enrollmentNumber.text = "Enrollment"
    
    header.teacher.font = font
    header.teacher.textColor = color
    header.teacher.text = "Last Submission Date"
    
    return header
  }

  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sender = courseTableView.cellForRow(at: indexPath)
    performSegue(withIdentifier: "ShowAssignment", sender: sender)
  }
  /************************************ Table View Related ***********************************/
  
  
  /************************************ Collection View Related ***********************************/
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return courses[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
    let course = courses[indexPath.section][indexPath.row]
    cell.name.text = course.name
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return coursesSections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    var view = CourseCollectionReusableView()
    
    if(kind == UICollectionElementKindSectionHeader){
      view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CourseCollectionViewHeader", for: indexPath) as! CourseCollectionReusableView
      view.header.text = coursesSections[indexPath.section]
    }
    
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sender = courseCollectionView.cellForItem(at: indexPath)
    performSegue(withIdentifier: "ShowAssignment", sender: sender)
  }
  
  /************************************ Collection View Related ***********************************/
  
  /************************************ Button CallBack **************************************/
  func optionBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func searchBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func homeBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  @IBAction func listViewBtnTapped(_ sender: UIButton) {
    //Change to listView
    collectionViewBtn.tintColor = UIColor.darkGray
    
    listViewBtn.tintColor = UIColor.white
    
    self.courseCollectionView.isHidden = true
    self.courseTableView.isHidden = false
    DispatchQueue.main.async(){
      //code
      self.animateTable()
    }
  }
  
  @IBAction func collectionViewBtnTapped(_ sender: Any) {
    //Change to collectionView
    collectionViewBtn.tintColor = UIColor.white
    
    listViewBtn.tintColor = UIColor.darkGray
    
    self.courseTableView.isHidden = true
    self.courseCollectionView.isHidden = false
    DispatchQueue.main.async(){
      //code
      self.animateCollection()
    }
    
    
  }
  
  
  /************************************ Button CallBack **************************************/
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "ShowAssignment" {
      let assignmentViewController = segue.destination as! AssignmentViewController
      if let selectedCourseTableViewCell = sender as? UITableViewCell {
        let indexPath = courseTableView.indexPath(for: selectedCourseTableViewCell)!
        let selectedCourse = courses[indexPath.section][indexPath.row]
        assignmentViewController.course = selectedCourse
      } else if let selectedCourseCollectionViewCell = sender as? CourseCollectionViewCell {
        let indexPath = courseCollectionView.indexPath(for: selectedCourseCollectionViewCell)!
        let selectedCourse = courses[indexPath.section][indexPath.row]
        assignmentViewController.course = selectedCourse
      }
    }

  }
  
}
