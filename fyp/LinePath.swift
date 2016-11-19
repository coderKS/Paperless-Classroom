//
//  LinePath.swift
//  fyp
//
//  Created by Ka Hong Ngai on 17/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class LinePath: NSObject {
  var type = "LinePath"
  var positions = [CGPoint]()
  var color: UIColor
  var lineWidth: CGFloat
  var category: String
  
  //Document Related Attributes
  var userID: Int
  var assignmentRecordID: Int
  var assignmentID: Int
  
  init?(positions: [CGPoint], color:UIColor, lineWidth: CGFloat, category: String, userID: Int,
        assignmentRecordID: Int, assignmentID: Int){
    self.positions = positions
    self.color = color
    self.lineWidth = lineWidth
    self.category = category
    
    self.userID = userID
    self.assignmentID = assignmentID
    self.assignmentRecordID = assignmentRecordID
    
    super.init()
  }
}
