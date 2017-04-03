//
//  CloudKitManager.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/2/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    let publicDataBase = CKContainer.default().publicCloudDatabase
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    func fetchRecords(ofType type: String, withSortDescriptors sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        privateDataBase.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        privateDataBase.save(record) { (record, error) in
            completion(error)
        }
    }
    
    func subscribeToCreationOfRecords(withType type: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let subscrption = CKQuerySubscription(recordType: type, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "There's a new post on the bulletin board!"
        subscrption.notificationInfo = notificationInfo
        privateDataBase.save(subscrption) { (_, error) in
            if let error = error {
                NSLog("Error: Error in subscription:\n\(error)")
            }
            completion(error)
        }
    }
}
