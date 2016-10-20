//
//  bottomBorderUITextField.swift
//  fyp
//
//  Created by Ka Hong Ngai on 12/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class bottomBorderUITextField: UITextField {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
  */
  
  var myValue: Int
  
  required init?(coder aDecoder: NSCoder) {
    // set myValue before super.init is called
    self.myValue = 0
    
    super.init(coder: aDecoder)
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
    
    // set other operations after super.init, if required
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = UIColor.white.cgColor
    border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
    
    border.borderWidth = width
    layer.addSublayer(border)
    layer.masksToBounds = true
  }
}
