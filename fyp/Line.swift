//
//  Line.swift
//  fyp
//
//  Created by wong on 22/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//


import UIKit

class Line: DrawObject {
  var startPoint: CGPoint
  var endPoint: CGPoint
  var color: UIColor
  var lineWidth: CGFloat
  var category: String
  
  var pageID: Int
  
  //Document Related Attributes
  var userID: Int
  var assignmentRecordID: Int
  var assignmentID: Int
  
  init?(startPoint: CGPoint, endPoint: CGPoint, color:UIColor, lineWidth: CGFloat, category: String, pageID: Int,
        userID: Int, assignmentRecordID: Int, assignmentID: Int, refId: String){
    self.startPoint = startPoint
    self.endPoint = endPoint
    
    self.color = color
    self.lineWidth = lineWidth
    self.category = category
    
    self.pageID = pageID
    
    self.userID = userID
    self.assignmentID = assignmentID
    self.assignmentRecordID = assignmentRecordID
    
    super.init(type: DrawObjectType.Line, refId: refId)

  }
}
