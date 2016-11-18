//
//  CourseTableViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 4/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
  
  var userId = ""
  var courses = [Course]()
  
  let transition = CircularTransition()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    loadCourse()
    
    //Set navigation item title
    self.navigationItem.title = "Course"
    //Set the bar color
    self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: CGFloat(GL_RED), green: CGFloat(GL_GREEN), blue: CGFloat(GL_BLUE), alpha: CGFloat(1.0))
    self.tabBarController?.tabBar.barTintColor = UIColor.init(red: 34/255, green: 50/255, blue: 60/255, alpha: 1.0)
    
    self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: CGFloat(GL_RED), green: CGFloat(GL_GREEN), blue: CGFloat(GL_BLUE), alpha: CGFloat(1.0))
    self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 213/255, blue: 195/255, alpha: 1.0)
    
    //Set font color
    self.tabBarController?.tabBar.tintColor = UIColor.white
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    //Set title color
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  func loadCourse(){
    print("loadCourse# start")
    let connectorType = ConnectorType.Localhost
    print("loadCourse# connectorType=\(connectorType)")
    let api = AppAPI(connectorType: connectorType)
    if(api == nil){
      print ("Fail to load api")
      
    }
    api!.getCourseList(userId: self.userId){
      (courses) in
      self.courses = courses
      self.tableView.reloadData()
    }

//    let course1 = Course(name: "CSCI2100", image: defaultImg)!
//    let course2 = Course(name: "CSCI2720", image: defaultImg)!
//    let course3 = Course(name: "ELTU3003", image: defaultImg)!
//    let course4 = Course(name: "CPTH2100", image: defaultImg)!
//    courses += [course1, course2, course3, course4]
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
    return courses.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "CourseTableViewCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
    
    // Configure the cell...
    let course = courses[indexPath.row]
    cell.courseName.text = course.name
    cell.courseImage.image = course.image
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
    if segue.identifier == "ShowAssignment" {
      let assignmentTableViewController = segue.destination as! AssignmentTableViewController
      if let selectedCourseTableViewCell = sender as? CourseTableViewCell {
        let indexPath = tableView.indexPath(for: selectedCourseTableViewCell)!
        let selectedCourse = courses[indexPath.row]
        assignmentTableViewController.course = selectedCourse
      }
    }
  }
  
  
}
