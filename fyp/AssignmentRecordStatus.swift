//
//  AssignmentRecordStatus.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

public enum AssignmentRecordStatus: Int {
  case DEFAULT = 0
  case NOT_GRADING = -1
  case IN_GRADING = 1
  case FINISHED_GRADING = -9
}
