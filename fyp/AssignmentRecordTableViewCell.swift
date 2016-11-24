//
//  AssignmentRecordTableViewCell.swift
//  fyp
//
//  Created by Ka Hong Ngai on 5/10/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class AssignmentRecordTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var assignmentRecordImage: UIImageView!
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var studentID: UILabel!
  @IBOutlet weak var refID: UILabel!
  
  @IBOutlet weak var submissionDateTime: UILabel!
  
  @IBOutlet weak var grade: UILabel!
  @IBOutlet weak var status: UILabel!
  @IBOutlet weak var lastModifiedDateTime: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
