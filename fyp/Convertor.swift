//
//  Convertor.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import UIKit

import Foundation
class Convertor {
  
  static func stringToDate(dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.date(from: dateString){
      return date
    }
    print ("Fail to convert dateString to date")
    return nil
  }
  
  static func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
  
  static func jsonToCourseList(json: JSON) -> [Course] {
    var courses = [Course]()
    for (_,subJson):(String, JSON) in json {
      let id = subJson["id"].string!
      let name = subJson["name"].string!
      let imageStr = subJson["image"].string!
      let term = subJson["term"].string!
      let year = subJson["year"].string!
      let code = subJson["code"].string!
      let enrollmentNumber = subJson["enrollmentNumber"].string!
      
      // print
      print ("id=\(id),name=\(name),imageStr=\(imageStr),term=\(term),year=\(year),code=\(code),enrolNum=\(enrollmentNumber)")
      
      var image: UIImage
      if imageStr == "" {
        image = UIImage(named: "folder")!
      } else {
        image = UIImage(named: imageStr)!
      }
      courses += [Course(id: id, name: name, image: image, term: term, year: year, code: code, enrollmentNumber: Int(enrollmentNumber)!)!]
      
    }
    return courses
  }
  
  static func jsonToAssignmentList(json: JSON) -> [Assignment] {
    var assignments = [Assignment]()
    
    return assignments
  }
  
  static func jsonToAssignmentRecordList(json: JSON) -> [AssignmentRecord] {
    var assignmentRecords = [AssignmentRecord]()
    
    return assignmentRecords
  }
}
