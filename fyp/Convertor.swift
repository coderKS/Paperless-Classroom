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
  
  /**
   * Input: "2016-11-15 23:59:59"
   * Output: Nov 15
   */
  static func dateToMonthDay(date: Date) -> String?{
    
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let dateFormatter = DateFormatter()
    let months = dateFormatter.shortMonthSymbols
    let result = (months?[month-1])!.uppercased() + " " + String(day)
    return result
  }
  
  /**
   * Input: "2016-11-15 23:59:59"
   * Output: Nov 15 23:59
   */
  static func dateToMonthDayHourMin(date: Date) -> String?{
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    let min = calendar.component(.minute, from: date)
    let dateFormatter = DateFormatter()
    let months = dateFormatter.shortMonthSymbols
    let result = (months?[month-1])!.uppercased() + " " + String(day) + " " + String(format: "%02d", hour) + ":" + String(format: "%02d", min)
    return result
  }
  
  static func stringToDate(dateString: String) -> Date? {
    var ds = dateString
    if ds.characters.contains(".") {
      ds.remove(at: ds.index(before: ds.endIndex))
      ds.remove(at: ds.index(before: ds.endIndex))
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.date(from: ds){
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
  
  
  static func stringToRGB(rgbString: String) -> [Float] {
    do {
      let regex = try NSRegularExpression(pattern: "(0\\.)?[0-9]+")
      let nsString = rgbString as NSString
      let results = regex.matches(in: rgbString, range: NSRange(location: 0, length: nsString.length))
      return results.map { Float(nsString.substring(with: $0.range))!}
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
  
  static func RGBToString(color: UIColor) -> String {
    let alpha = color.alpha()!
    let red = color.red()!
    let green = color.green()!
    let blue = color.blue()!
    
    let result = "rgba(" + String(red) + "," + String(green) + "," + String(blue) + "," + String(alpha) + ")"
    print ("RGBToString# result=\(result)")
    return result
  }
  private static func drawObjectsToDataJson(drawObjects: [DrawObject], pageId: String) -> JSON?{
    if drawObjects.count == 0 {
      return nil
    }
    
    var json: JSON = ["page": 0, "data": []]
    json["page"] = JSON(pageId)
    var dataJSON = [JSON]()
    
    for i in 0...drawObjects.count - 1 {
      dataJSON.append(self.drawObjectToDataJson(drawObject: drawObjects[i], pageId: pageId))
    }
    
    json["data"] = JSON(dataJSON)
    //print ("drawObjectsToDataJson# json=\(json)")
    return json
  }
  
  static func drawObjectsToLocalDataJson(pageDrawObjects: [DrawObject]) -> JSON? {
    if(pageDrawObjects.count == 0){
      return nil
    }
    
    var json: JSON = ["shapes": []]
    var jsonArray = [JSON]()
    for i in 0...pageDrawObjects.count - 1 {
      jsonArray.append(self.drawObjectToLocalDataJson(drawObject: pageDrawObjects[i]))
    }
    
    json["shapes"] = JSON(jsonArray)
    //print ("drawObjectToLocalDataJson# json=\(json)")
    return json
  }
  
  private static func drawObjectToLocalDataJson(drawObject: DrawObject) -> JSON {
    var json: JSON = ["className": "", "data": [], "id": ""]
    
    let dataJSON = self.drawObjectToJson(drawObject: drawObject)
    var className: String
    switch(drawObject.type){
    case DrawObjectType.Line:
      className = "Line"
    case DrawObjectType.LinePath:
      className = "LinePath"
    case DrawObjectType.ErasedLinePath:
      className = "ErasedLinePath"
    }
    
    json["className"] = JSON(className)
    json["data"] = JSON(dataJSON)
    json["id"] = JSON(drawObject.refId)
    //print ("drawObjectToLocalDataJson# json=\(json)")
    return json
  }
  
  private static func drawObjectToDataJson(drawObject: DrawObject, pageId: String) -> JSON {
    var json: JSON = ["pageId": 0, "className": "", "data": "", "refId": ""]
    
    let dataJSON = self.drawObjectToJson(drawObject: drawObject)
    let dataString = dataJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions(rawValue: 0))!
    var className: String
    switch(drawObject.type){
    case DrawObjectType.Line:
      className = "Line"
    case DrawObjectType.LinePath:
      className = "LinePath"
    case DrawObjectType.ErasedLinePath:
      className = "ErasedLinePath"
    }
    json["pageId"] = JSON(pageId)
    json["className"] = JSON(className)
    json["data"] = JSON(dataString)
    json["refId"] = JSON(drawObject.refId)
    //print ("drawObjectToDataJson# json=\(json)")
    return json
  }
  
  private static func drawObjectToJson(drawObject: DrawObject) -> JSON {
    let json: JSON
    switch(drawObject.type){
    case DrawObjectType.Line:
      json = self.LineToJson(line: drawObject as! Line)
    case DrawObjectType.LinePath:
      json = self.LinePathToJson(linePath: drawObject as! LinePath)
    case DrawObjectType.ErasedLinePath:
      json = self.EraserLinePathToJson(eraserLinePath: drawObject as! ErasedLinePath)
    }
    //print ("drawObjectToJson# json=\(json)")
    return json
  }
  
  private static func LineToJson(line: Line) -> JSON {
    //{\"x1\":291.5,\"y1\":133,\"x2\":664.5,\"y2\":284,\"strokeWidth\":20,\"color\":\"rgba(255,0,0,1)\",\"capStyle\":\"round\",\"dash\":null,\"endCapShapes\":[null,null]}
    var json: JSON =  ["x1": 0, "y1": 0, "x2": 0, "y2": 0, "strokeWidth": 0, "color": "", "capStyle": "round", "dash": "null", "endCapShapes": ["null","null"]]
    json["x1"] = JSON(line.startPoint.x)
    json["y1"] = JSON(line.startPoint.y)
    json["x2"] = JSON(line.endPoint.x)
    json["y2"] = JSON(line.endPoint.y)
    json["color"] = JSON(self.RGBToString(color: line.color))
    
    return json
  }
  
  private static func LinePathToJson(linePath: LinePath) -> JSON {
    var json: JSON =  ["order": 3, "tailSize": 3, "smooth": true, "pointCoordinatePairs": [], "smoothedPointCoordinatePairs": [], "pointSize": 0, "pointColor": ""]
    
    var positions = [[Float]]()
    for i in 0...linePath.positions.count - 1 {
      positions.append([Float(linePath.positions[i].x), Float(linePath.positions[i].y)])
    }
    let positionsJSON = JSON(positions)
    
    var smoothPositions = [[Float]]()
    for i in 0...linePath.smoothPositions.count - 1 {
      smoothPositions.append([Float(linePath.smoothPositions[i].x), Float(linePath.smoothPositions[i].y)])
    }
    let smoothPositionsJSON = JSON(smoothPositions)
    
    json["pointSize"] = JSON(linePath.lineWidth)
    json["pointColor"] = JSON(self.RGBToString(color: linePath.color))
    json["pointCoordinatePairs"] = positionsJSON
    json["smoothedPointCoordinatePairs"] = smoothPositionsJSON
    
    return json
  }
  
  private static func EraserLinePathToJson(eraserLinePath: ErasedLinePath) -> JSON {
    var json: JSON =  ["order": 3, "tailSize": 3, "smooth": true, "pointCoordinatePairs": [], "smoothedPointCoordinatePairs": [], "pointSize": 0, "pointColor": ""]
    
    var positions = [[Float]]()
    for i in 0...eraserLinePath.positions.count - 1 {
      positions.append([Float(eraserLinePath.positions[i].x), Float(eraserLinePath.positions[i].y)])
    }
    let positionsJSON = JSON(positions)
    
    var smoothPositions = [[Float]]()
    for i in 0...eraserLinePath.smoothPositions.count - 1 {
      smoothPositions.append([Float(eraserLinePath.smoothPositions[i].x), Float(eraserLinePath.smoothPositions[i].y)])
    }
    let smoothPositionsJSON = JSON(smoothPositions)
    
    json["pointSize"] = JSON(eraserLinePath.lineWidth)
    json["pointColor"] = "#000"
    json["pointCoordinatePairs"] = positionsJSON
    json["smoothedPointCoordinatePairs"] = smoothPositionsJSON
    
    return json
  }
  
  static func pageDrawObjectsToJson(pageDrawObjects: [Int:[DrawObject]]) -> JSON? {
    if  pageDrawObjects.count == 0 {
      return nil
    }
    var jsonArr = [JSON]()
    for i in 0...pageDrawObjects.count - 1 {
      if pageDrawObjects[i]?.count == 0 {
        continue
      }
      jsonArr.append(self.drawObjectsToDataJson(drawObjects: pageDrawObjects[i]!, pageId: String(i+1))!)
    }
    
    let json = JSON(jsonArr)
    //print ("pageDrawObjectsToJson# json=\(json)")
    return json
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
      let instructor = subJson["instructor"].string!
      // print
      print ("id=\(id),name=\(name),imageStr=\(imageStr),term=\(term),startYear=\(startYear),endYear=\(endYear),code=\(code),enrolNum=\(enrollmentNumber),instructor=\(instructor)")
      
      var image: UIImage
      if imageStr == "" {
        image = UIImage(named: "folder")!
      } else {
        image = UIImage(named: imageStr)!
      }
      courses += [Course(id: id, name: name, image: image, term: term, startYear: startYear, endYear: endYear, code: code, enrollmentNumber: Int(enrollmentNumber)!, instructor: instructor)!]
      
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
    print ("jsonToDrawObjectList# returned drawObjects size=\(drawObjects.count)")
    return drawObjects
  }
  
  static func jsonToLine(json: JSON) -> Line? {
    if let x1 = json["data"]["x1"].double,
      let y1 = json["data"]["y1"].double,
      let x2 = json["data"]["x2"].double,
      let y2 = json["data"]["y2"].double,
      let colorString = json["data"]["color"].string,
      let lineWidth = json["data"]["strokeWidth"].float,
      let refId = json["id"].string{
      
      print ("refId=\(refId)")
      let startPoint = CGPoint(x: x1, y:y1)
      let endPoint = CGPoint(x: x2, y: y2)
      let colorArray = Convertor.stringToRGB(rgbString: colorString)
      let color: UIColor
      switch(colorArray.count){
      case 3:
        print ("red=\(colorArray[0]), green=\(colorArray[1]), blue=\(colorArray[2])")
        color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: 1)
        break
      case 4:
        print ("red=\(colorArray[0]), green=\(colorArray[1]), blue=\(colorArray[2]), alpha=\(colorArray[3])")
        color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: CGFloat(colorArray[3]))
        break
      default:
        // it should be either 3 or 4, error handling here
        return nil
      }
      
      let category = "pen"
      
      let line = Line(startPoint: startPoint, endPoint: endPoint, color: color, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0, refId: refId)
      
      return line
    }
    
    return nil
  }
  
  static func jsonToLinePath(json: JSON) -> LinePath? {
    if let colorString = json["data"]["pointColor"].string,
      let lineWidth = json["data"]["pointSize"].float,
      let pointCoordinatePairs = json["data"]["pointCoordinatePairs"].array,
      let smoothPointCoordinateParis = json["data"]["smoothedPointCoordinatePairs"].array,
      let refId = json["id"].string{
      
      var category = "pen"
      print ("refId=\(refId)")
      let colorArray = Convertor.stringToRGB(rgbString: colorString)
      let color: UIColor
      switch(colorArray.count){
      case 3:
        print ("red=\(colorArray[0]), green=\(colorArray[1]), blue=\(colorArray[2])")
        color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: 1)
        category = "pen"
        break
      case 4:
        print ("red=\(colorArray[0]), green=\(colorArray[1]), blue=\(colorArray[2]), alpha=\(colorArray[3])")
        color = UIColor.init(red: CGFloat(colorArray[0]/255), green: CGFloat(colorArray[1]/255), blue: CGFloat(colorArray[2] / 255), alpha: CGFloat(colorArray[3]))
        if colorArray[3] < 1.0 {
          category = "highlight"
        }
        break
      default:
        // it should be either 3 or 4, error handling here
        return nil
      }
      
      var positions = [CGPoint]()
      for i in 0...pointCoordinatePairs.count - 1 {
        positions += [CGPoint(x: pointCoordinatePairs[i][0].double!, y: pointCoordinatePairs[i][1].double!)]
      }
      
      var smoothPositions = [CGPoint]()
      for i in 0...smoothPointCoordinateParis.count - 1 {
        smoothPositions += [CGPoint(x: smoothPointCoordinateParis[i][0].double!, y: smoothPointCoordinateParis[i][1].double!)]
      }
      
      let linePath = LinePath(positions: positions, smoothPositions: smoothPositions, color: color, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0, refId: refId)
      
      return linePath
    }
    
    return nil
  }
  
  static func jsonToErasedLinePath(json: JSON) -> ErasedLinePath? {
    if let lineWidth = json["data"]["pointSize"].float,
      let pointCoordinatePairs = json["data"]["pointCoordinatePairs"].array,
      let smoothPointCoordinateParis = json["data"]["smoothedPointCoordinatePairs"].array,
      let refId = json["id"].string{
      let category = "eraser"
      
      var positions = [CGPoint]()
      print ("refId=\(refId)")
      for i in 0...pointCoordinatePairs.count - 1 {
        positions += [CGPoint(x: pointCoordinatePairs[i][0].double!, y: pointCoordinatePairs[i][1].double!)]
      }
      
      var smoothPositions = [CGPoint]()
      for i in 0...smoothPointCoordinateParis.count - 1 {
        smoothPositions += [CGPoint(x: smoothPointCoordinateParis[i][0].double!, y: smoothPointCoordinateParis[i][1].double!)]
      }
      
      let erasedLinePath = ErasedLinePath(positions: positions, smoothPositions: smoothPositions, lineWidth: CGFloat(lineWidth), category: category, pageID: 0, userID: 0, assignmentRecordID: 0, assignmentID: 0, refId: refId)
      
      return erasedLinePath
    }
    
    return nil
  }
}






















