//
//  ConnectionError.swift
//  fyp
//
//  Created by wong on 23/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation

public enum ConnectionError : Error {
  case NetworkError
  case NotFound
  case ConnectorNotSupport
}
