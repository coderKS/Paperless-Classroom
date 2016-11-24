//
//  AssignmentRecordViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 23/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordViewController: UIViewController,
  //For Table View
UITableViewDelegate, UITableViewDataSource {
  
  var course: Course?
  var assignment: Assignment?
  var assignmentRecords = [AssignmentRecord]()
  
  
  @IBOutlet weak var homeBtn: UIButton!
  
  @IBOutlet weak var assignmentRecordBtn: UIButton!
  @IBOutlet weak var assignmentBtn: UIButton!
  
  
  @IBOutlet weak var indicatorA: UIImageView!
  
  @IBOutlet weak var indicatorB: UIImageView!
  
  @IBOutlet weak var assignmentRecordTableView: UITableView!
  
  @IBOutlet weak var secondaryMenuView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let nib = UINib(nibName: "AssignmentRecordTableViewHeaderView", bundle: nil)
    self.assignmentRecordTableView.register(nib, forHeaderFooterViewReuseIdentifier: "AssignmentRecordTableViewHeaderView")
    // Do any additional setup after loading the view.
    
    initSecondaryMenu()
    
    loadAssignmentRecords()
    
    self.view.backgroundColor = Theme.navigationBackgroundColor
    self.assignmentRecordTableView.backgroundColor = Theme.navigationBackgroundColor
    
    navigationItem.setHidesBackButton(true, animated: true)
    
    animateTable()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadAssignmentRecords(){
    let defaultImg = UIImage(named: "folder")
    let asgRecord1 = AssignmentRecord(id: "0", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1155047854", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 100, grade: "A", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!, refID: "583952")!
    let asgRecord2 = AssignmentRecord(id: "1", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1155012345", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 90, grade: "A-", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!,refID: "928472")!
    let asgRecord3 = AssignmentRecord(id: "2", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1234567890", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 80, grade: "B+", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!, refID: "748130")!
    assignmentRecords += [asgRecord1, asgRecord2, asgRecord3]
  }
  
  func animateTable() {
    assignmentRecordTableView.reloadData()
    let cells = assignmentRecordTableView.visibleCells
    let tableHeight: CGFloat = assignmentRecordTableView.bounds.size.height
    
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
  
  func initSecondaryMenu() {
    self.secondaryMenuView.backgroundColor = Theme.navigationBarTintColor
    
    var img = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
    homeBtn.setImage(img, for: .normal)
    homeBtn.setTitle("Home", for: .normal)
    homeBtn.tintColor = Theme.navigationBarTextColor
    
    img = UIImage(named: "folder")
    var resizedImg = imageWithImage(image: img!, scaledToSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
    assignmentBtn.setImage(resizedImg, for: .normal)
    assignmentBtn.setTitle(course?.code ?? "Course", for: .normal)
    assignmentBtn.tintColor = Theme.navigationBarTextColor
    
    img = UIImage(named: "calendar")
    resizedImg = imageWithImage(image: img!, scaledToSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
    assignmentRecordBtn.setImage(resizedImg, for: .normal)
    assignmentRecordBtn.setTitle(assignment?.name ?? "Assignment", for: .normal)
    assignmentRecordBtn.tintColor = Theme.navigationBarTextColor
    
    indicatorA.image = (indicatorA.image?.withRenderingMode(.alwaysTemplate))!
    indicatorA.tintColor = Theme.navigationBarTextColor
    
    indicatorB.image = (indicatorB.image?.withRenderingMode(.alwaysTemplate))!
    indicatorB.tintColor = Theme.navigationBarTextColor
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
    return 70.0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return assignmentRecords.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "AssignmentRecordTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssignmentRecordTableViewCell
    // Configure the cell...
    let assignmentRecord = assignmentRecords[indexPath.row]
    cell.name.text = assignmentRecord.studentName
    cell.assignmentRecordImage.image = UIImage(named: "calendar")//assignment.image
    cell.studentID.text = assignmentRecord.studentID
    cell.submissionDateTime.text = Convertor.dateToMonthDayHourMin(date: assignmentRecord.submissionDateTime!)
    cell.grade.text = assignmentRecord.grade //With point
    cell.status.text = "-"//assignmentRecord.gradingStatus
    cell.lastModifiedDateTime.text = Convertor.dateToMonthDayHourMin(date: assignmentRecord.lastModified)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = assignmentRecordTableView.dequeueReusableHeaderFooterView(withIdentifier: "AssignmentRecordTableViewHeaderView") as! AssignmentRecordTableViewHeaderView
    
    var font = UIFont(name: "Helvetica Neue", size: CGFloat(40.0))
    let color = UIColor.darkGray
    
    header.name.font = font
    header.name?.textColor = color
    header.name.text = "Name"
    
    font = UIFont(name: "Helvetica Neue", size: CGFloat(18.0))
    header.refID?.font = font
    header.refID?.textColor = color
    header.refID.text = "Ref ID"
    
    header.submissionDateTime.font = font
    header.submissionDateTime.textColor = color
    header.submissionDateTime.text = "Submission Time"
    
    header.grade.font = font
    header.grade.textColor = color
    header.grade.text = "Grade"
    
    header.status.font = font
    header.status.textColor = color
    header.status.text = "Status"
    
    header.lastModifiedDateTime.font = font
    header.lastModifiedDateTime.textColor = color
    header.lastModifiedDateTime.text = "Last Updated"
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sender = assignmentRecordTableView.cellForRow(at: indexPath)
    performSegue(withIdentifier: "ShowAssignmentRecordURL", sender: sender)
  }
  
  /************************************ Table View Related ***********************************/
  
  
  /************************************ Button CallBack **************************************/
  func optionBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func searchBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  func homeBtnTapped(_ sender: UIBarButtonItem){
    
  }
  
  @IBAction func assignmentRecordHomeBtnTapped(_ sender: Any) {
    performSegue(withIdentifier: "backToCourse", sender: nil)
  }
  
  @IBAction func assignmentRecordAssignmentBtnTapped(_ sender: Any) {
    performSegue(withIdentifier: "backToAssignment", sender: nil)
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "backToAssignment" {
      let assignmentViewController = segue.destination as! AssignmentViewController
      assignmentViewController.course = self.course
    } else if segue.identifier == "backToCourse" {
      
    }

  }
  
  
}
