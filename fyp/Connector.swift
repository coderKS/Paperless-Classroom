//
//  Connector.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation

public enum ConnectorType {
  case Veriguide
  case Localhost
}

protocol Connector {
  // MARK: Properties
  var baseUrl: String {get}
  // MARK: Action
  
  // An async function that return the response by given url, parameters
  // @return: responseString
  func sendPostRequest(urlString: String, postString: String?, completion: @escaping (Data?, ConnectionError?) -> ())
  
  // An async function that return the response by given url
  // @return: responseString
  func sendGetRequest(urlString: String, completion: @escaping (Data?, ConnectionError?) -> ())
  
}
