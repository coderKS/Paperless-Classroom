//
//  CourseTableViewCell.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

  @IBOutlet weak var courseImage: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var courseCode: UILabel!
  @IBOutlet weak var enrollmentNumber: UILabel!
  @IBOutlet weak var teacher: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
