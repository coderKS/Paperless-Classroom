//
//  LinePath.swift
//  fyp
//
//  Created by Ka Hong Ngai on 17/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class LinePath: DrawObject {
  var positions: [CGPoint]
  var smoothPositions: [CGPoint]
  var color: UIColor
  var lineWidth: CGFloat
  var category: String
  
  var pageID: Int
  
  //Document Related Attributes
  var userID: Int
  var assignmentRecordID: Int
  var assignmentID: Int
  
  init?(positions: [CGPoint], smoothPositions: [CGPoint], color:UIColor, lineWidth: CGFloat, category: String, pageID: Int,
        userID: Int, assignmentRecordID: Int, assignmentID: Int, refId: String){
    self.positions = positions
    self.smoothPositions = smoothPositions
    self.color = color
    self.lineWidth = lineWidth
    self.category = category
    
    self.pageID = pageID
    
    self.userID = userID
    self.assignmentID = assignmentID
    self.assignmentRecordID = assignmentRecordID
    
    super.init(type: DrawObjectType.LinePath, refId: refId)
  }
  
  static func toJSON(_ linePath: LinePath) -> JSON {
    var jsonDict = Dictionary<String, Any>()
    var subJSON = Dictionary<String, Any>()
    var json: JSON?
    
    subJSON["category"] = linePath.category
    subJSON["pointColor"] = linePath.color
    subJSON["pointSize"] = linePath.lineWidth
    subJSON["pointCoordinatePairs"] = linePath.positions
    subJSON["smoothedPointCoordinatePairs"] = linePath.positions
    
    
    jsonDict["pageID"] = linePath.pageID
    jsonDict["assignmentID"] = linePath.assignmentID
    jsonDict["assignmentRecordID"] = linePath.assignmentRecordID
    jsonDict["className"] = linePath.type
    jsonDict["data"] = subJSON
    
    //print(jsonDict)
    json = JSON(jsonDict)
    //print(json?["pointCoordinatePairs"].arrayObject as! [[Float]])
    
    return json!
  }
  
  
}
