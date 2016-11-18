//
//  Course.swift
//  fyp
//
//  Created by Ka Hong Ngai on 4/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class Course: NSObject {
  var id: String
  var name: String
  var image: UIImage?
  var term: String
  var year: String
  var code: String
  var enrollmentNumber: Int
  
  init?(id: String, name: String, image: UIImage?, term: String, year: String, code: String, enrollmentNumber: Int){
    self.id = id
    self.name = name
    self.image = image
    self.term = term
    self.year = year
    self.code = code
    self.enrollmentNumber = enrollmentNumber
    
    super.init()
    
    if id.isEmpty || name.isEmpty || term.isEmpty || year.isEmpty || code.isEmpty {
      return nil
    }
  }
}
