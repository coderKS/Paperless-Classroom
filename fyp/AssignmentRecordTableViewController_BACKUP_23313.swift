//
//  AssignmentRecordTableViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordTableViewController: UITableViewController {
  
  var assignment: Assignment?
  var assignmentRecords = [AssignmentRecord]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    loadAssignmentRecords()
    self.navigationItem.title = assignment?.name
  }
  
  func loadAssignmentRecords(){
    let defaultImg = UIImage(named: "folder")
    let asgRecord1 = AssignmentRecord(id: "0", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1155047854", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 100, grade: "A", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!, refID: "236693")!
    let asgRecord2 = AssignmentRecord(id: "1", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1155012345", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 90, grade: "A-", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!, refID: "866937")!
    let asgRecord3 = AssignmentRecord(id: "2", submissionStatus: 1, submissionDateTime: Convertor.stringToDate(dateString: "2016-10-15 23:59:59")!, studentID: "1234567890", studentName: "Wong Kam Shing", gradingStatus: AssignmentRecordStatus.IN_GRADING, image: defaultImg, score: 80, grade: "B+", assignmentURL: "abc.pdf", lastModified: Convertor.stringToDate(dateString: "2016-10-16 14:08:12")!, refID: "046296")!
    assignmentRecords += [asgRecord1, asgRecord2, asgRecord3]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return assignmentRecords.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "AssignmentRecordTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssignmentRecordTableViewCell
    
    // Configure the cell...
    let asgRecord = assignmentRecords[indexPath.row]
    cell.studentID.text = asgRecord.studentID
    cell.assignmentRecordImage.image = asgRecord.assignmentRecordImage
    cell.score.text = asgRecord.score?.description
    cell.submissionDateTime.text = Convertor.dateToString(date: asgRecord.submissionDateTime!)
    
    return cell
  }
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "ShowAssignmentURL" {
      
      let assignmentRecordViewController = segue.destination as! PDFPageViewController
      if let selectedAssignmentRecordTableViewCell = sender as? AssignmentRecordTableViewCell {
        let indexPath = tableView.indexPath(for: selectedAssignmentRecordTableViewCell)!
        let asgRecord = assignmentRecords[indexPath.row]
        assignmentRecordViewController.assignmentRecord = asgRecord
      }
    }
  }
  
  
}
