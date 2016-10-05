//
//  AssignmentRecord.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecord: NSObject {
  var submissionDateTime: String
  var studentID: String
  var isMarked: Bool
  var assignmentRecordImage: UIImage?
  var score: Int?
  var assignmentURL: String
  
  init?(studentID: String, image: UIImage?, dateTime: String, isMarked: Bool, score: Int?, url: String){
    self.studentID = studentID
    self.assignmentRecordImage = image
    self.submissionDateTime = dateTime
    self.isMarked = isMarked
    self.score = score
    self.assignmentURL = url
    
    super.init()
    
    if studentID.isEmpty {
      return nil
    }
  }
}
