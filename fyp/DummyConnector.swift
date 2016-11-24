//
//  DummyConnector.swift
//  fyp
//
//  Created by wong on 16/11/2016.
//  Copyright © 2016年 IK1603. All rights reserved.
//

import Foundation
class DummyConnector: Connector {
  var baseUrl = "http://localhost/"
  
  func sendPostRequest(urlString: String, postString: String?, completion: @escaping (Data?, ConnectionError?) -> ()){
    
  }
  

  func sendGetRequest(urlString: String, completion: @escaping (Data?, ConnectionError?) -> ()){
    let url = URL(string: urlString)
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      guard let data = data, error == nil else {
        // check for fundamental/networking error
        print("error=\(error)")
        completion(nil, ConnectionError.NetworkError)
        return
      }
      
      if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        // check for http errors
        print("statusCode should be 200, but is \(httpStatus.statusCode)")
        print("response = \(response)")
        completion(nil, ConnectionError.NotFound)
        return
      }
      
      let responseString = String(data: data, encoding: .utf8)
      print("responseString = \(responseString)")

      
      completion(data, nil)
      
    }
    task.resume()
  }
  
}
