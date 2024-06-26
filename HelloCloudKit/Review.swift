//
//  Review.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/29/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

struct Review {
    static let recordType = "Review"
    
    let authorName: String
    let comment: String
    let stars: Float
    let restaurantReference: CKRecord.Reference
    
    let record: CKRecord
    
    var recordID: CKRecord.ID?
    
    init(record: CKRecord) {
        self.record = record
        recordID = record.recordID
        authorName = record["author_name"] as! String
        comment = record["comment"] as! String
        stars = (record["stars"] as! NSNumber).floatValue
        restaurantReference = record["restaurant"] as! CKRecord.Reference
    }
    
    init(author: String, comment: String, rating: Float, restaurantID: CKRecord.ID) {
        let record = CKRecord(recordType: Review.recordType)
        record["author_name"] = author as NSString
        record["comment"] = comment as NSString
        record["stars"] = rating as NSNumber
        record["restaurant"] = CKRecord.Reference(recordID: restaurantID, action: .deleteSelf)
        self.init(record: record)
    }
}
