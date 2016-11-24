
//  AppConnection.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import UIKit
import Foundation

class AppAPI {
  var connectorType: ConnectorType
  var connector: Connector
  let fileNamePrefix = "paperless-classroom-"
  
  init(){
    self.connectorType = ConnectorType.Veriguide
    self.connector = MysqlConnector()
  }
  
  init?(connectorType: ConnectorType) {
    self.connectorType = connectorType
    switch connectorType {
    case ConnectorType.Veriguide:
      self.connector = MysqlConnector()
      break
    case ConnectorType.Localhost:
      self.connector = DummyConnector()
      break
    }
  }
  
  func verifyUser(account: String, password: String) -> Bool {
    if(account == "king" && password == "king"){
      return true;
    }
    return false;
  }
  
  func getLastModifiedTime(fileId: String, completion: @escaping (Date?, ConnectionError?)->()) {
    let urlWithParam: String
    switch self.connectorType {
    case ConnectorType.Veriguide:
      // 1. create url with fileId as parameters
      let urlString = connector.baseUrl
      urlWithParam = urlString + "Annotations?gradeId=" + fileId + "&action=last-update-time"
      break
      
    case ConnectorType.Localhost:
      // 1. create url with fileId as parameters
      let urlString = connector.baseUrl
      urlWithParam = urlString + "course.json"
      break
    }
    print ("urlWithParam = \(urlWithParam)")
    
    self.connector.sendGetRequest(urlString: urlWithParam) {
      // 2. get the responseString
      (data, error) in
      print ("data = \(data)")
      if data == nil {
        // get local data
        let date = self.readLastModifiedTime(fileId: fileId)
        if date == nil {
          completion(nil, error)
        } else {
          completion(date, nil)
        }
        return
      }
      // write the data into local file
      let dataString = String(data: data!, encoding: String.Encoding.utf8)
      let result = self.writeLastModifiedTime(fileId: fileId, date: dataString!)
      if(!result){
        print ("Fail to write back the file")
      }
      let date = Convertor.stringToDate(dateString: dataString!)
      completion(date, nil)
    }
  }
    
  
  /**
   * An async function that return an array of Course by given userId
   * 1. create url with userId as parameters
   * 2. get the responseString
   * 3. parse the responseString to JSON
   * 4. convert the JSON into an array of Course Object
   */
  func getCourseList(userId: String, completion: @escaping ([Course]?, ConnectionError?)->()) {
    let urlWithParam: String
    switch self.connectorType {
    case ConnectorType.Veriguide:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      urlWithParam = urlString + "Course/" + userId + "/course.json"
      break
      
    case ConnectorType.Localhost:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      urlWithParam = urlString + "course.json"
      break
    }
    
    print ("urlWithParam = \(urlWithParam)")
    
    self.connector.sendGetRequest(urlString: urlWithParam) {
      // 2. get the responseString
      (data, error) in
      print ("data = \(data)")
      if data == nil {
        // get local course list data
        let courses = self.readLocalCourseList(userId: userId)
        if courses == nil {
          completion(nil, error)
        } else {
          completion(courses, nil)
        }
        return
      }
      
      // if able to get data from server,
      // parse the responseString to JSON
      let json = JSON(data: data!)
      // write the data into local course file
      let dataString = String(data: data!, encoding: String.Encoding.utf8)
      let result = self.writeLocalCourseList(userId: userId, content: dataString!)
      if(!result){
        print ("Fail to write back the file")
      }
      // convert the JSON into an array of Course Object
      let courses = Convertor.jsonToCourseList(json: json)
      
      completion(courses, nil)
    }

  }
  
  
  func getAssignmentList(courseId: String) -> Array<Assignment> {
    var assignments = [Assignment]()
    return assignments
  }
  
  func getAssignmentRecordList(assignmentId: String) -> Array<AssignmentRecord> {
    var assignemntRecords = [AssignmentRecord]()
    
    return assignemntRecords
  }
  
  func addAnnotation() {
    
  }
  
  func getAnnotation(pageId: String, completion: @escaping ([DrawObject]?, ConnectionError?)->()) {
    
    let urlWithParam: String
    
    switch self.connectorType {
    case ConnectorType.Veriguide:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      //let param = "Course?userId=\(userId)"
      urlWithParam = urlString + "Annotations?version=1&gradeId=1&page=" + pageId
      break
    case ConnectorType.Localhost:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      //let param = "Course?userId=\(userId)"
      urlWithParam = urlString + "page/" + pageId + "/getAnnotation.json"
      break
    }
    print ("urlWithParam = \(urlWithParam)")
    
    self.connector.sendGetRequest(urlString: urlWithParam) {
      // 2. get the responseString
      (data, error) in
      print ("data = \(data)")
      if data == nil {
        // if cannot get data from server, try to read it in local file
        let drawObjects = self.readLocalAnnotation(pageId: pageId)
        if drawObjects == nil {
          completion(nil, error)
        } else {
          completion(drawObjects, nil)
        }
        return
      }
      // if able to get data from server,
      // parse the responseString to JSON
      let json = JSON(data: data!)
      // convert the JSON into an array of Course Object
      let drawObjects = Convertor.jsonToDrawObjectList(json: json)
      print ("AppAPI# return drawObjects size=\(drawObjects.count) in page=[\(pageId)]")
      completion(drawObjects, nil)
    }
  }
  
  func addAnnotation(linePathJSON: JSON,completion: @escaping ()->()) {
    //var msg = "Success"
    
    switch self.connectorType {
    case .Veriguide:
      print("Not yet implemented")
      break
    case .Localhost:
      print("Send LinePath to the server")
      let urlWithParam = connector.baseUrl
      break
    }
  }
  
  func readLastModifiedTime(fileId: String) -> Date?{
    let fileName = self.fileNamePrefix + "-file-" + fileId + "-last-modified-time"
    if let content = self.readFile(fileName: fileName) {
      // if content not nil
      // convert the JSON into an array of Course Object
      let date = Convertor.stringToDate(dateString: content)
      return date
    }
    return nil
  }
  
  func writeLastModifiedTime(fileId: String, date: String) -> Bool{
    let fileName = self.fileNamePrefix + "-file-" + fileId + "-last-modified-time"
    return self.writeFile(fileName: fileName, content: date)
  }
  
  func readLocalAnnotation(pageId: String) -> [DrawObject]?{
    print ("getLocalAnnotation#start")
    return nil
  }
  
  func readLocalCourseList(userId: String) -> [Course]? {
    let fileName = self.fileNamePrefix + "course-" + String(userId)
    if let content = self.readFile(fileName: fileName) {
      // if content not nil
      let data = content.data(using: .utf8)

      // parse the responseString to JSON
      let json = JSON(data: data!)
      // convert the JSON into an array of Course Object
      let courses = Convertor.jsonToCourseList(json: json)
      return courses
    }
    return nil
  }
  
  func writeLocalCourseList(userId: String, content: String) -> Bool {
    let fileName = self.fileNamePrefix + "course-" + String(userId)
    return self.writeFile(fileName: fileName, content: content)
  }
  
  func readLocalAssignmentList(courseId: String, completion: @escaping ([Assignment]?)->()) {
    
  }
  
  func readLocalAssignmentRecordList(assignmentId: String, completion: @escaping ([AssignmentRecord]?)->()) {
    var assignemntRecords = [AssignmentRecord]()
    return
  }
  
  func readFile(fileName: String) -> String? {
    
    let fileName = self.fileNamePrefix + fileName
    print ("AppAPI.readFile# fileName=\(fileName)")
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      
      let path = dir.appendingPathComponent(fileName)

      //reading
      do {
        let content = try String(contentsOf: path, encoding: String.Encoding.utf8)
        print ("AppAPI.readFile# content=\(content)")
        return content
      }
      catch {
        print ("AppAPI.readFile# file:\(fileName) not found")
        return nil
      }
    }
    print ("AppAPI.readFile# dir is empty")
    return nil

  }
  
  func writeFile(fileName: String, content: String) -> Bool {
    
    let fileName = self.fileNamePrefix + fileName
    print ("AppAPI.writeFile# fileName=\(fileName), content=\(content)")
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      
      let path = dir.appendingPathComponent(fileName)
      
      //writing
      do {
        try content.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        return true
      }
      catch {
        print ("AppAPI.writeFile# Fail to write file")
        return false
      }
      
    }
    print ("AppAPI.writeFile# dir is empty")
    return false

  }
  
}
