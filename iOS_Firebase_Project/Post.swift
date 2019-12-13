//
//  Post.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post {
    let id: String
       let photoUrl: String?
       let creatorID: String
       let dateCreated: Date?
       
       init(photoUrl: String? = nil, creatorID: String, dateCreated: Date? = nil) {
           self.creatorID = creatorID
           self.id = UUID().description
           self.dateCreated = dateCreated
           self.photoUrl = photoUrl
       }
    
       init?(from dict: [String: Any], id: String) {
           guard let userID = dict["creatorID"] as? String,
               let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue(),
                let photoUrl = dict["photoUrl"] as? String else { return nil }
           
           self.creatorID = userID
           self.id = id
           self.dateCreated = dateCreated
           self.photoUrl = photoUrl
       }
       
       var fieldsDict: [String: Any] {
           return [
               "photoUrl": self.photoUrl,
               "creatorID": self.creatorID
           ]
       }
}
