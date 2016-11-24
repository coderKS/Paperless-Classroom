//
//  DrawObject.swift
//  fyp
//
//  Created by wong on 22/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

public enum DrawObjectType {
  case Line
  case LinePath
  case ErasedLinePath
}

import Foundation
class DrawObject: NSObject{
  var type: DrawObjectType
  var refId: String
  
  init?(type: DrawObjectType, refId: String){
    self.type = type
    self.refId = refId
    super.init()
  }
  
}
