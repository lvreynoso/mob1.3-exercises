//
//  URLSessionApiService.swift
//  Lesson10
//
//  Created by Thomas Vandegriff on 2/26/19.
//  Copyright © 2019 Make School. All rights reserved.
//

    /*** URLSessionApiService.swift is an API Service client designed to fetch, post and process data to and from the JSONPlaceholder web service:
 
        - Using URLSession
 
     ***/

import Foundation

class URLSessionApiService {
    
    func postTODO() {
        
        // TODO: Implement a POST request using URLSession inside this function
        let session = URLSession.shared
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Couldn't create URL :(")
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("zyxw09vut87srqp65onm", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = ["userId": 99, "title": "Generic Title", "completed": true]
        do {
            let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonParams
        } catch {
            print("Error: unable to add parameters to POST Request")
        }
        
        session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print("POST Request: communication error \(error!)")
            }
            if data != nil {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    DispatchQueue.main.async {
                        print("Results from POST request:\n\(resultObject)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to parse JSON response")
                    } 
                }
            } else {
                DispatchQueue.main.async {
                    print("Received empty response")
                }
            }
        }).resume()
        
    }
}
