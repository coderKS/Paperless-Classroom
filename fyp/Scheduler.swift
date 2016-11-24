//
//  Scheduler.swift
//  fyp
//
//  Created by wong on 24/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
class Scheduler {
  var timer: Timer
  
  init(){
    self.timer = Timer()
  }
  func sayHello()
  {
    print("hello World")
  }
  
  func run(){
    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("self.sayHello"), userInfo: nil, repeats: true)
    self.timer.fire()
  }
  
  func stop(){
    self.timer.invalidate()
  }
}
