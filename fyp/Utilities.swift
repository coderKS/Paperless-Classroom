//
//  Utilities.swift
//  fyp
//
//  Created by wong on 24/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation

class Utilities {
  
  private static func s4() -> String {
    return String(format: "%04x", Int(arc4random() % 65535))
    
  }
  
  static func getReferenceId() -> String {
    return s4() + s4() + "-" + s4() + "-" + s4() + "-" + s4() + "-" + s4() + s4() + s4()
  }
  
}
