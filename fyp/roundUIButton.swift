//
//  roundUIButton.swift
//  fyp
//
//  Created by Ka Hong Ngai on 12/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class roundUIButton: UIButton {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    
    // set other operations after super.init, if required
    layer.cornerRadius = 20
    layer.borderWidth = 1
    layer.borderColor = UIColor.white.cgColor
  }
}
