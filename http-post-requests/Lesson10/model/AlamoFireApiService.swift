//
//  AlamoFireApiService.swift
//  Lesson10
//
//  Created by Thomas Vandegriff on 2/26/19.
//  Copyright © 2019 Make School. All rights reserved.
//

    /*** AlamoFireApiService.swift is an API Service client designed to fetch, post and process data to and from the JSONPlaceholder web service:
 
        - Using Alamofire
            https://github.com/Alamofire/Alamofire
    ***/

import Foundation
import Alamofire

class AlamoFireApiService {
    
    // TODO: Create a function that implements a POST request using Using Alamofire
    func post() -> Void {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Couldn't create URL :(")
            return
        }
        let parameters: [String: Any] = ["userId": 99, "title": "Generic Title", "completed": true]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "zyxw09vut87srqp65onm"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response -> Void in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            guard response.result.error == nil else {
                print("POST Request communication error: \(String(describing: response.result.error))")
                return
            }
            guard let json = response.result.value as? Dictionary<String,Any> else {
                print("No JSON result")
                return
            }
            guard let todoTitle = json["title"] as? String else {
                print("Todo title not a string")
                return
            }
            
            print("JSON: \(json)")
            print("Todo Title: \(todoTitle)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        })
    }
    
    func delete() -> Void {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            print("Couldn't create URL :(")
            return
        }
        Alamofire.request(url, method: .delete).responseJSON(completionHandler: { response -> Void in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            guard response.result.error == nil else {
                print("DELETE Request communication error: \(String(describing: response.result.error))")
                return
            }
            guard let json = response.result.value as? Dictionary<String,Any> else {
                print("No JSON result")
                return
            }
            
            print("JSON: \(json)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        })
    }
    
}
