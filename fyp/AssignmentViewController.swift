//
//  AssignmentViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 23/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentViewController: UIViewController,
  //For Table View
  UITableViewDelegate, UITableViewDataSource,
  //For Collection View
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  var course: Course?
  var assignments = [Assignment]()
  
  @IBOutlet weak var listViewBtn: UIButton!
  
  @IBOutlet weak var collectionViewBtn: UIButton!
  
  @IBOutlet weak var homeBtn: UIButton!
  @IBOutlet weak var indicatorImage: UIImageView!
  
  @IBOutlet weak var assignmentBtn: UIButton!
  
  @IBOutlet weak var secondaryMenu: UIView!
  @IBOutlet weak var assignmentTableView: UITableView!
  @IBOutlet weak var assignmentCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let nib = UINib(nibName: "AssignmentTableViewHeaderView", bundle: nil)
    self.assignmentTableView.register(nib, forHeaderFooterViewReuseIdentifier: "AssignmentTableViewHeaderView")
    
    //Init background color
    self.assignmentTableView.backgroundColor = Theme.navigationBackgroundColor
    self.assignmentCollectionView.backgroundColor = Theme.navigationBackgroundColor
    self.view.backgroundColor = Theme.navigationBackgroundColor
    
    //Init breadcrumb text
    initSecondaryMenu()
    
    
    loadAssignment()
    navigationController?.navigationBar.barTintColor = .black
    navigationController?.navigationBar.tintColor = .white
    navigationItem.setHidesBackButton(true, animated: true)
    
    self.view.bringSubview(toFront: secondaryMenu)
    self.assignmentCollectionView.isHidden = true
    self.assignmentTableView.isHidden = false
    
    //animate
    animateTable()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Init
  func loadAssignment() {
    let defaultImg = UIImage(named: "folder")
    let assignment1 = Assignment(id: "0", name: "Assignment 1", image: defaultImg, submittedNum: 18, lastModified: Date(), status: AssignmentStatus.OPENED_FOR_SUBMISSION, dueDate: Convertor.stringToDate(dateString: "2016-11-15 23:59:59")!)!
    let assignment2 = Assignment(id: "0", name: "Assignment 2", image: defaultImg, submittedNum: 18, lastModified: Date(), status: AssignmentStatus.OPENED_FOR_SUBMISSION, dueDate: Convertor.stringToDate(dateString: "2016-11-15 23:59:59")!)!
    let assignment3 = Assignment(id: "0", name: "Assignment 3", image: defaultImg, submittedNum: 18, lastModified: Date(), status: AssignmentStatus.OPENED_FOR_SUBMISSION, dueDate: Convertor.stringToDate(dateString: "2016-11-15 23:59:59")!)!
    let assignment4 = Assignment(id: "0", name: "Assignment 4", image: defaultImg, submittedNum: 18, lastModified: Date(), status: AssignmentStatus.OPENED_FOR_SUBMISSION, dueDate: Convertor.stringToDate(dateString: "2016-11-15 23:59:59")!)!
    assignments += [assignment1, assignment2, assignment3, assignment4]
  }
  
  func animateTable() {
    assignmentTableView.reloadData()
    let cells = assignmentTableView.visibleCells
    let tableHeight: CGFloat = assignmentTableView.bounds.size.height
    
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
    assignmentCollectionView.reloadData()
    assignmentCollectionView.layoutIfNeeded()
    let cells = assignmentCollectionView.visibleCells
    let tableHeight: CGFloat = assignmentCollectionView.bounds.size.height
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
    self.secondaryMenu.backgroundColor = Theme.navigationBarTintColor
    
    var img = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
    listViewBtn.setImage(img, for: .normal)
    listViewBtn.tintColor = Theme.navigationBarTextColor
    
    img = UIImage(named: "collection")?.withRenderingMode(.alwaysTemplate)
    collectionViewBtn.setImage(img, for: .normal)
    collectionViewBtn.tintColor = Theme.navigationBarTextColor
    
    img = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
    homeBtn.setImage(img, for: .normal)
    homeBtn.setTitle("Home", for: .normal)
    homeBtn.tintColor = Theme.navigationBarTextColor

    img = UIImage(named: "folder")
    let resizedImg = imageWithImage(image: img!, scaledToSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
    assignmentBtn.setImage(resizedImg, for: .normal)
    assignmentBtn.setTitle(course?.code ?? "Assignment", for: .normal)
    assignmentBtn.tintColor = Theme.navigationBarTextColor
    
    indicatorImage.image = (indicatorImage.image?.withRenderingMode(.alwaysTemplate))!
    indicatorImage.tintColor = Theme.navigationBarTextColor
  }
  
  func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  /************************************* Table View Related **********************************/
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100.0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return assignments.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "AssignmentTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssignmentTableViewCell
    // Configure the cell...
    let assignment = assignments[indexPath.row]
    cell.name.text = assignment.name
    cell.assignmentImage.image = UIImage(named: "folder")//assignment.image
    cell.subTitle.text = "DUE " + Convertor.dateToMonthDay(date: assignment.dueDate)!
    cell.submittedNumber.text = String(assignment.submittedNum) + " / " + "20"//assignment.totalNum
    cell.submittedProgress.setProgress(Float(assignment.submittedNum) / Float(20), animated: true)
    cell.lastSubmissionDateTime.text = Convertor.dateToMonthDayHourMin(date: assignment.lastModified)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = assignmentTableView.dequeueReusableHeaderFooterView(withIdentifier: "AssignmentTableViewHeaderView") as! AssignmentTableViewHeaderView
    
    var font = UIFont(name: "Helvetica Neue", size: CGFloat(40.0))
    let color = UIColor.darkGray
    
    header.name.font = font
    header.name?.textColor = color
    header.name.text = "Name"
    
    font = UIFont(name: "Helvetica Neue", size: CGFloat(20.0))
    header.progress.font = font
    header.progress.textColor = color
    header.progress.text = "Progress"
    
    header.lastSubmissionDateTime.font = font
    header.lastSubmissionDateTime.textColor = color
    header.lastSubmissionDateTime.text = "Last Submission Time"
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sender = assignmentTableView.cellForRow(at: indexPath)
    performSegue(withIdentifier: "ShowAssignmentRecord", sender: sender)
  }
  
  /************************************ Table View Related ***********************************/
  
  
  /************************************ Collection View Related ***********************************/
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assignments.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssignmentCollectionViewCell", for: indexPath) as! AssignmentCollectionViewCell
    let course = assignments[indexPath.row]
    cell.name.text = course.name
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    var view = AssignmentCollectionReusableView()
    
    if(kind == UICollectionElementKindSectionHeader){
      view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AssignmentCollectionReusableView", for: indexPath) as! AssignmentCollectionReusableView
      view.header.text = "Name"
    }
    
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sender = assignmentCollectionView.cellForItem(at: indexPath)
    performSegue(withIdentifier: "ShowAssignmentRecord", sender: sender)
  }
  
  /************************************ Collection View Related ***********************************/
  
  /************************************ Button CallBack **************************************/
  func optionBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func searchBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func homeBtnTapped(_ sender: UIBarButtonItem){
    
  }
  @IBAction func assignmentHomeBtnTapped(_ sender: Any) {
    print("Back to home")
    performSegue(withIdentifier: "backToHome", sender: nil)
  }
  
  
  @IBAction func listViewBtnTapped(_ sender: Any) {
    //Change to listView
    self.assignmentCollectionView.isHidden = true
    self.assignmentTableView.isHidden = false
    DispatchQueue.main.async(){
      //code
      self.animateTable()
    }
  }
  
  @IBAction func collectionViewBtnTapped(_ sender: Any) {
    //Change to collectionView
    self.assignmentTableView.isHidden = true
    self.assignmentCollectionView.isHidden = false
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
    if segue.identifier == "ShowAssignmentRecord" {
      let assignmentRecordViewController = segue.destination as! AssignmentRecordViewController
      if let selectedAssignmentTableViewCell = sender as? AssignmentTableViewCell {
        let indexPath = assignmentTableView.indexPath(for: selectedAssignmentTableViewCell)!
        let selectedAssignment = assignments[indexPath.row]
        assignmentRecordViewController.assignment = selectedAssignment
        assignmentRecordViewController.course = self.course
      } else  if let selectedAssignmentCollectionViewCell = sender as? AssignmentCollectionViewCell {
        let indexPath = assignmentCollectionView.indexPath(for: selectedAssignmentCollectionViewCell)!
        let selectedAssignment = assignments[indexPath.row]
        assignmentRecordViewController.assignment = selectedAssignment
        assignmentRecordViewController.course = self.course
      }
    }
  }
  
  
}
