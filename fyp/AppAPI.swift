
//  AppConnection.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
public enum ConnectorType {
  case Veriguide
  case Localhost
}
class AppAPI {
  var connectorType: ConnectorType
  var connector: Connector
  
  init?(connectorType: ConnectorType) {
    print("AppAPI# init - connectType=\(connectorType)")
    self.connectorType = connectorType
    switch connectorType {
    case ConnectorType.Veriguide:
      print("You select Veriguide")
      self.connector = MysqlConnector()
      break
    case ConnectorType.Localhost:
      print("You select Localhost")
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
  
  /**
   * An async function that return an array of Course by given userId
   * 1. create url with userId as parameters
   * 2. get the responseString
   * 3. parse the responseString to JSON
   * 4. convert the JSON into an array of Course Object
   */
  func getCourseList(userId: String, completion: @escaping ([Course])->()) {
    switch self.connectorType {
    case ConnectorType.Veriguide:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      //let param = "Course?userId=\(userId)"
      let urlWithParam = urlString + "Course/" + userId + "/course.json"
      
      print ("urlWithParam = \(urlWithParam)")
      
      connector.sendGetRequest(urlString: urlWithParam) {
        // 2. get the responseString
        (data) in
        print ("data = \(data)")
        // 3. parse the responseString to JSON
        let json = JSON(data: data!)
        // 4. convert the JSON into an array of Course Object
        let courses = Convertor.jsonToCourseList(json: json)
        completion(courses)
      }
      break
    case ConnectorType.Localhost:
      // 1. create url with userId as parameters
      let urlString = connector.baseUrl
      //let param = "Course?userId=\(userId)"
      let urlWithParam = urlString + "course.json"
      
      print ("urlWithParam = \(urlWithParam)")
      
      self.connector.sendGetRequest(urlString: urlWithParam) {
        // 2. get the responseString
        (data) in
        print ("data = \(data)")
        // 3. parse the responseString to JSON
        let json = JSON(data: data!)
        // 4. convert the JSON into an array of Course Object
        let courses = Convertor.jsonToCourseList(json: json)
        completion(courses)
      }
      break
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
  
  
  
}
