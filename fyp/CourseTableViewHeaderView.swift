//
//  CourseTableViewHeaderView.swift
//  fyp
//
//  Created by Ka Hong Ngai on 24/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CourseTableViewHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  @IBOutlet weak var name: UILabel!

  @IBOutlet weak var enrollmentNumber: UILabel!
  @IBOutlet weak var teacher: UILabel!
}
