//
//  User.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import UIKit

public enum UserRole: Int {
  case INSTRUCTOR = 2
  case STUDENT = 1
}

class User: NSObject {
  var id: String
  var account: String
  var password: String
  var role: UserRole
  var lastLogin: DateFormatter
  
  init?(id: String, account: String, password: String, role: UserRole, lastLogin: DateFormatter){
    self.id = id
    self.account = account
    self.password = password
    self.role = role
    self.lastLogin = lastLogin
    
    super.init()
    
    if id.isEmpty || account.isEmpty || password.isEmpty {
      return nil
    }
  }
  
}
