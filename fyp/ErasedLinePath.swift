//
//  ErasedLinePath.swift
//  fyp
//
//  Created by wong on 22/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import UIKit

class ErasedLinePath: DrawObject {
  var positions: [CGPoint]
  var smoothPositions: [CGPoint]
  var lineWidth: CGFloat
  var category: String
  
  var pageID: Int
  
  //Document Related Attributes
  var userID: Int
  var assignmentRecordID: Int
  var assignmentID: Int
  
  init?(positions: [CGPoint], smoothPositions: [CGPoint], lineWidth: CGFloat, category: String, pageID: Int,
        userID: Int, assignmentRecordID: Int, assignmentID: Int, refId: String){
    self.positions = positions
    self.smoothPositions = smoothPositions
    self.lineWidth = lineWidth
    self.category = category
    
    self.pageID = pageID
    
    self.userID = userID
    self.assignmentID = assignmentID
    self.assignmentRecordID = assignmentRecordID
    
    super.init(type: DrawObjectType.ErasedLinePath, refId: refId)
  }

}
