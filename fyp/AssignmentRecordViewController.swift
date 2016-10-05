//
//  AssignmentRecordViewController.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordViewController: UIViewController {
  
  var assignmentRecord: AssignmentRecord?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    loadAssignmentRecordURL()
    self.navigationItem.title = assignmentRecord?.studentID
    
    //Add a image view into this view to be the canvas
    loadCanvas()
  }
  
  func loadAssignmentRecordURL() {
    //Load PDF into the Webview
    let webView = UIWebView(frame: CGRect(x: 100, y: 100, width: 800, height: 1000))
    print(assignmentRecord!.assignmentURL)
    let fileExtension = "pdf"
    let localFilePath = Bundle.main.url(forResource: assignmentRecord!.assignmentURL, withExtension: fileExtension)
    let request = NSURLRequest(url: localFilePath!)
    webView.isUserInteractionEnabled = false
    webView.loadRequest(request as URLRequest)
    self.view.addSubview(webView)
  }
  
  func loadCanvas() {
    //Load a UIImageView
    let assignmentRecordCanvas = AssignmentRecordCanvas(frame: CGRect(x: 100, y: 100, width: 800, height: 1000))
    assignmentRecordCanvas.isUserInteractionEnabled = true
    self.view.addSubview(assignmentRecordCanvas)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
