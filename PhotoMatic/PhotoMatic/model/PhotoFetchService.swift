//
//  PhotoFetchService.swift
//  PhotoMatic
//
//  Created by Thomas Vandegriff on 2/20/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import Foundation
import UIKit

/*** PhotoFetchService.swift is an API Service client that is designed to:
    - Fetch, post and process data to and from the target web services
    - Serialize JSON data for manipulation and presentation
    - Provide constructs for handling the successful or failed state of web service requests and responses
 ***/



  //DONE: Place Enums for Network calls and JSON processing functions here...
enum PhotoFetchResult {
    case success([Photo])
    case failure(Error)
}

enum ImageFetchResult {
    case success(UIImage)
    case failure(Error)
}

enum FlickrAPIError: Error {
    case invalidJSONData
}

enum ImageRequestError: Error {
    case imageCreationError
}

struct PhotoFetchService {
    
    //DONE: Insert your API Key here
    private let APIKey = "f7d78bfaf7565c499d32548c2b27822b"
    private let baseURLString = "https://api.flickr.com/services/rest"
    private let flickrMethod = "flickr.interestingness.getList"
    
    //DONE: Put your API Key, baseURLString, and flickrMethod method variables here...
    
 
    
    //DONE: Place any variables required for Network calls and JSON processing functions here...
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

   
    //DONE: Refactor/move Network calls and JSON processing functions here...
    
    func processImageRequest(data: Data?, error: Error?) -> ImageFetchResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Could not create an image from data
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(ImageRequestError.imageCreationError)
                }
        }
        
        return .success(image)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageFetchResult) -> Void) {
        
        guard let photoURL = photo.remoteURL else {
            preconditionFailure("Photo expected to have a remote URL.")
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func urlBuilder(parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": flickrMethod,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    func fetchPhotos(completion: @escaping (PhotoFetchResult) -> Void) {
        
        let url = urlBuilder(parameters: ["extras": "url_h,date_taken"])
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            let result = self.processPhotoFetchRequest(data: data, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
    }
    
    private func processPhotoFetchRequest(data: Data?, error: Error?) -> PhotoFetchResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        return self.photoItems(fromJSON: jsonData)
    }
    
    func photoItems(fromJSON data: Data) -> PhotoFetchResult {
        
        do {
            
            let decoder = JSONDecoder()
            let jsonReply = try decoder.decode(PhotoService.self, from: data)
            guard let rawPhotos = jsonReply.photos.photo else {
                // The JSON structure is not correct
                print(jsonReply)
                return .failure(FlickrAPIError.invalidJSONData)
            }
            let processedPhotos = rawPhotos.map { Photo(from: $0) }
            
            if processedPhotos.isEmpty {
                // unable to parse Photo items. Maybe the JSON formatting has changed
                return .failure(FlickrAPIError.invalidJSONData)
            }
            return .success(processedPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
}


