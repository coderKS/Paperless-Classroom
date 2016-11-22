//
//  DrawObject.swift
//  fyp
//
//  Created by wong on 22/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
class DrawObject: NSObject{
  var type: String
  
  init?(type: String){
    self.type = type
    super.init()
  }
  
}
