//
//  Course.swift
//  fyp
//
//  Created by Ka Hong Ngai on 4/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class Course: NSObject {
  var name: String
  var image: UIImage?
  
  init?(name: String, image: UIImage?){
    self.name = name
    self.image = image
    
    super.init()
    
    if name.isEmpty {
      return nil
    }
  }
}
