//
//  Photo.swift
//  L08_sandbox1
//
//  Created by Thomas Vandegriff on 2/13/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import Foundation

//DONE: Recreate this as an object that implements the Codable interface

class Photo {

    let title: String?
    let dateTaken: Date?
    let photoID: String?
    let remoteURL: URL?
    
    private let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return formatter
            }()
    
    init(from raw: rawPhoto) {
        title = raw.title
        if let dateTaken = dateFormatter.date(from: raw.datetaken!) {
            self.dateTaken = dateTaken
        } else {
            dateTaken = nil
        }
        photoID = raw.id
        if let rawURL = raw.url_h {
            self.remoteURL = URL(string: rawURL)
        } else if let farmID = raw.farm, let serverID = raw.server, let id = photoID, let secret = raw.secret {
            remoteURL = URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg")
        } else {
            remoteURL = nil
        }
    }

}

struct PhotoService: Codable {
    let photos: photoJSON
}

struct photoJSON: Codable {
    let photo: [rawPhoto]?
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let stat: String?
}

struct rawPhoto: Codable {
    // the fields we want
    let title: String?
    let datetaken: String?
    let id: String?
    let url_h: String?
    let secret: String?
    let server: String?
    let farm: Int?
    
    // the ones we don't
//    let owner: String?
//    let ispublic: Int?
//    let isfriend: Int?
//    let isfamily: Int?
//    let datetakengranularity: String?
//    let datetakenunknown: String?
//    let height_h: String?
//    let width_h: String?
    
}
