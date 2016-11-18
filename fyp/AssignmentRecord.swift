//
//  AssignmentRecord.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

public enum AssignmentRecordStatus: Int {
  case DEFAULT = 0
  case NOT_GRADING = -1
  case IN_GRADING = 1
  case FINISHED_GRADING = -9
}

class AssignmentRecord: NSObject {
  var id:String
  // 0 for not submitted, 1 for submitted
  var submissionStatus: Int
  // if submitted, store submission time
  var submissionDateTime: Date?
  var studentID: String
  var studentName: String
  var gradingStatus: AssignmentRecordStatus
  var assignmentRecordImage: UIImage?
  var score: Int?
  var grade: String?
  var assignmentURL: String?
  var lastModified: Date
  
  init?(id: String, submissionStatus: Int, submissionDateTime: Date?, studentID: String, studentName: String, gradingStatus: AssignmentRecordStatus, image: UIImage?, score: Int?, grade: String?, assignmentURL: String?, lastModified: Date){
    self.id = id
    self.submissionStatus = submissionStatus
    self.submissionDateTime = submissionDateTime
    self.studentID = studentID
    self.studentName = studentName
    self.gradingStatus = gradingStatus
    self.assignmentRecordImage = image
    self.score = score
    self.grade = grade
    self.assignmentURL = assignmentURL
    self.lastModified = lastModified
    
    super.init()
    
    if studentID.isEmpty {
      return nil
    }
  }
}
