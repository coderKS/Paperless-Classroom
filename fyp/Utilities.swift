//
//  Utilities.swift
//  fyp
//
//  Created by wong on 24/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
import UIKit

extension Date {
  func isGreaterThanDate(dateToCompare: Date) -> Bool {
    //Declare Variables
    var isGreater = false
    
    //Compare Values
    if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
      isGreater = true
    }
    
    //Return Result
    return isGreater
  }
  
  func isLessThanDate(dateToCompare: Date) -> Bool {
    //Declare Variables
    var isLess = false
    
    //Compare Values
    if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
      isLess = true
    }
    
    //Return Result
    return isLess
  }
  
  func equalToDate(dateToCompare: Date) -> Bool {
    //Declare Variables
    var isEqualTo = false
    
    //Compare Values
    if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
      isEqualTo = true
    }
    
    //Return Result
    return isEqualTo
  }
  
  func addDays(daysToAdd: Int) -> Date {
    let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
    let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays) as Date
    
    //Return Result
    return dateWithDaysAdded
  }
  
  func addHours(hoursToAdd: Int) -> Date {
    let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
    let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours) as Date
    
    //Return Result
    return dateWithHoursAdded
  }
}

extension UIColor {
  
  func alpha() -> Float? {
    var fRed : CGFloat = 0
    var fGreen : CGFloat = 0
    var fBlue : CGFloat = 0
    var fAlpha: CGFloat = 0
    if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
      return Float(fAlpha)
    } else {
      // Could not extract RGBA components:
      return nil
    }
  }
  
  func red() -> Int? {
    var fRed : CGFloat = 0
    var fGreen : CGFloat = 0
    var fBlue : CGFloat = 0
    var fAlpha: CGFloat = 0
    if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
      return Int(fRed * 255)
    } else {
      // Could not extract RGBA components:
      return nil
    }
  }
  
  func green() -> Int? {
    var fRed : CGFloat = 0
    var fGreen : CGFloat = 0
    var fBlue : CGFloat = 0
    var fAlpha: CGFloat = 0
    if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
      return Int(fGreen * 255)
    } else {
      // Could not extract RGBA components:
      return nil
    }
  }
  
  func blue() -> Int? {
    var fRed : CGFloat = 0
    var fGreen : CGFloat = 0
    var fBlue : CGFloat = 0
    var fAlpha: CGFloat = 0
    if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
      return Int(fBlue * 255)
    } else {
      // Could not extract RGBA components:
      return nil
    }
  }
}

class Utilities {
  
  private static func s4() -> String {
    return String(format: "%04x", Int(arc4random() % 65535))
    
  }
  
  static func getReferenceId() -> String {
    return s4() + s4() + "-" + s4() + "-" + s4() + "-" + s4() + "-" + s4() + s4() + s4()
  }
  
}
