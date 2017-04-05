//
//  JournalDailyController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/2/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class JournalDailyController {
    
    var journals: [JournalDaily] = []
    
    static let shared = JournalDailyController()
    
    let cloudKitManager = CloudKitManager()

    func createJournal(image: UIImage, title: String, journalText: String, completion: @escaping (Error?) -> Void) {
        // Set's the properties of the jpg image
        guard let data = UIImageJPEGRepresentation(image, 0.5)
            else { return }
        
        let journal = JournalDaily(photoData: data, title: title, journalText: journalText)
        
        let record = CKRecord(journalDaily: journal)
        cloudKitManager.save(record) { (error) in
            
            if let error = error {
                print("There was a error saving to CK. JournalDailyController: createJournal()")
                completion(error)
            } else {
                print("Record successfully saved to CK")
                self.journals.append(journal)
                completion(nil)
            }
        }
        
    }
    
//    func update(journal: JournalDaily) {
//        
//        journal.journalText =
//    }
    
    func fetchJournalsFromCloudKit(completion: @escaping ([JournalDaily]) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "JournalDaily", predicate: predicate)
        
        cloudKitManager.privateDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            let journals = records.flatMap({ JournalDaily(record: $0)})
            completion(journals)
        }
    }
    
}


