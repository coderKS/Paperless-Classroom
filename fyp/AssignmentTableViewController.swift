//
//  AssignmentTableViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentTableViewController: UITableViewController {
  
  var course: Course?
  var assignments = [Assignment]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    loadAssignments()
    self.navigationItem.title = course?.name
  }
  
  func loadAssignments(){
    let defaultImg = UIImage(named: "default")
    let assignment1 = Assignment(name: "Assignment 1", image: defaultImg)!
    let assignment2 = Assignment(name: "Assignment 2", image: defaultImg)!
    let assignment3 = Assignment(name: "Mid-Term Paper", image: defaultImg)!
    let assignment4 = Assignment(name: "Final Paper", image: defaultImg)!
    assignments += [assignment1, assignment2, assignment3, assignment4]
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
    return assignments.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "AssignmentTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssignmentTableViewCell
    
    // Configure the cell...
    let assignment = assignments[indexPath.row]
    cell.assignmentName.text = assignment.name
    cell.assignmentImage.image = assignment.image
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
    if segue.identifier == "ShowAssignmentRecord" {
      let assignmentRecordTableViewController = segue.destination as! AssignmentRecordTableViewController
      if let selectedAssignmentTableViewCell = sender as? AssignmentTableViewCell {
        let indexPath = tableView.indexPath(for: selectedAssignmentTableViewCell)!
        let selectedAssignment = assignments[indexPath.row]
        assignmentRecordTableViewController.assignment = selectedAssignment
      }
    }
  }
  
  
}
