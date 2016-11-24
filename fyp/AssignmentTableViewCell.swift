//
//  AssignmentTableViewCell.swift
//  fyp
//
//  Created by Ka Hong Ngai on 23/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var assignmentImage: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var subTitle: UILabel!
  @IBOutlet weak var submittedNumber: UILabel!
  @IBOutlet weak var submittedProgress: UIProgressView!
  @IBOutlet weak var lastSubmissionDateTime: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
