//
//  Scheduler.swift
//  fyp
//
//  Created by wong on 24/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
class Scheduler {
  var fileId: String
  var updateTimePeriod: Float
  var lastModifiedTime: Date?
  var lastUpdatedTime: Date
  var api = AppAPI()
  
  init(fileId: String, updateTimePeriod: Float) {
    self.fileId = fileId
    self.updateTimePeriod = updateTimePeriod
    self.lastUpdatedTime = Date()
  }
  
  func addAnnotation(fileId: String, lastModifiedTime: Date, pageDrawObjects: [Int: [DrawObject]]){
    let elapsed_1 = Date().timeIntervalSince(lastUpdatedTime)
    let elapsed_2 = lastModifiedTime.timeIntervalSince(lastUpdatedTime)
    if Float(elapsed_1) >= updateTimePeriod && Float(elapsed_2) > 0.0 {
      print ("addAnnotation# ready to add annotation...")
      self.api.addAnnotation(fileId: fileId, pageDrawObjects: pageDrawObjects, version: "1", gradeId: "1"){
        (success, error) in
        if(!success){
          /* Fail to add Annocation */
          /* Error handling here */
          print ("sche addAnnotation# fail to add annotation")
          return
        } else {
          print ("sche addAnnotation# success to add annotation")
          self.lastUpdatedTime = Date()
        }
      }
      self.api.writeLocalAnnotations(fileId: fileId, pageDrawObjects: pageDrawObjects)
    } else {
      print ("sche addAnnotation# not ready to add annotation")
    }
  }
//  var pageDrawObjects: [Int:[DrawObject]]
//  var timer: Timer
//  
//  init(pageDrawObjects: [Int:[DrawObject]]){
//    self.timer = Timer()
//    self.pageDrawObjects = pageDrawObjects
//  }
//  
//  func addAnnotation(timer: Timer)
//  {
//    let pageDrawObjects = timer.userInfo as! [Int:[DrawObject]]
//    if let json = Convertor.pageDrawObjectsToJson(pageDrawObjects: pageDrawObjects) {
//      print ("addAnnotation# json=\(json)")
//      
//    }
//    
//  }
//  
//  func run(){
//    self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: Selector("addAnnotation"), userInfo: pageDrawObjects, repeats: true)
//    self.timer.fire()
//  }
  
}
