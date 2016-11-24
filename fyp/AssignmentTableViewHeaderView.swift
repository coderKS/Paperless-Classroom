//
//  AssignmentTableViewHeaderView.swift
//  fyp
//
//  Created by Ka Hong Ngai on 23/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentTableViewHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

  @IBOutlet weak var lastSubmissionDateTime: UILabel!
  @IBOutlet weak var progress: UILabel!
  @IBOutlet weak var name: UILabel!
}
