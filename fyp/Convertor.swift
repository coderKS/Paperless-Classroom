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
  
  static func stringToRGB(rgbString: String) -> [Int] {
      do {
        let regex = try NSRegularExpression(pattern: "[0-9]+")
        let nsString = rgbString as NSString
        let results = regex.matches(in: rgbString, range: NSRange(location: 0, length: nsString.length))
        return results.map { Int(nsString.substring(with: $0.range))!}
      } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
      }
  }
  
  static func jsonToCourseList(json: JSON) -> [Course] {
    var courses = [Course]()
    for (_,subJson):(String, JSON) in json {
      let id = subJson["id"].string!
      let name = subJson["name"].string!
      let imageStr = subJson["image"].string!
      let term = subJson["term"].string!
      let startYear = subJson["startYear"].string!
      let endYear = subJson["endYear"].string!
      let code = subJson["code"].string!
      let enrollmentNumber = subJson["enrollmentNumber"].string!
      
      // print
      print ("id=\(id),name=\(name),imageStr=\(imageStr),term=\(term),startYear=\(startYear),endYear=\(endYear),code=\(code),enrolNum=\(enrollmentNumber)")
      
      var image: UIImage
      if imageStr == "" {
        image = UIImage(named: "folder")!
      } else {
        image = UIImage(named: imageStr)!
      }
      courses += [Course(id: id, name: name, image: image, term: term, startYear: startYear, endYear: endYear, code: code, enrollmentNumber: Int(enrollmentNumber)!)!]
      
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
  
  static func jsonToDrawObjectList(json: JSON) -> [DrawObject] {
    var drawObjects = [DrawObject]()
    for (_,subJson):(String, JSON) in json["shapes"] {
      if let className = subJson["className"].string {
        switch className {
        case "Line":
          if let line = Convertor.jsonToLine(json: subJson){
            drawObjects += [line]
          }
          break
        case "LinePath":
          if let linePath = Convertor.jsonToLinePath(json: subJson){
            drawObjects += [linePath]
          }
          break
        case "ErasedLinePath":
          if let erasedLinePath = Convertor.jsonToErasedLinePath(json: subJson){
            drawObjects += [erasedLinePath]
          }
          break
        default:
          continue
        }
      }
    }
    return drawObjects
  }
  
  static func jsonToLine(json: JSON) -> Line? {
    if let x1 = json["data"]["x1"].double,
      let y1 = json["data"]["y1"].double,
      let x2 = json["data"]["x2"].double,
      let y2 = json["data"]["y2"].double,
      let colorString = json["data"]["color"].string,
      let lineWidth = json["data"]["strokeWidth"].float{
      
      let startPoint = CGPoint(x: x1, y:y1)
      let endPoint = CGPoint(x: x2, y: y2)
      let colorArray = Convertor.stringToRGB(rgbString: colorString)
      let color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: 1.0)
      let category = "pen"
      
      let line = Line(startPoint: startPoint, endPoint: endPoint, color: color, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0)
      
      return line
    }
    
    return nil
  }
  
  static func jsonToLinePath(json: JSON) -> LinePath? {
    if let colorString = json["data"]["pointColor"].string,
      let lineWidth = json["data"]["pointSize"].float,
      let pointCoordinatePairs = json["data"]["pointCoordinatePairs"].array{
    
      let colorArray = Convertor.stringToRGB(rgbString: colorString)
      let color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: 1.0)
      let category = "pen"
      
      var positions = [CGPoint]()
      for i in 0...pointCoordinatePairs.count - 1 {
        positions += [CGPoint(x: pointCoordinatePairs[i][0].double!, y: pointCoordinatePairs[i][1].double!)]
      }
      
      let linePath = LinePath(positions: positions, color: color, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0)
      
      return linePath
    }
    
    return nil
  }
  
  static func jsonToErasedLinePath(json: JSON) -> ErasedLinePath? {
    if let lineWidth = json["data"]["pointSize"].float,
      let pointCoordinatePairs = json["data"]["pointCoordinatePairs"].array{
      let category = "eraser"
      
      var positions = [CGPoint]()
      for i in 0...pointCoordinatePairs.count - 1 {
        positions += [CGPoint(x: pointCoordinatePairs[i][0].double!, y: pointCoordinatePairs[i][1].double!)]
      }
      
      let erasedLinePath = ErasedLinePath(positions: positions, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0)
      
      return erasedLinePath
    }
    
    return nil
  }
}






















