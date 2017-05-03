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
        cloudKitManager.privateDatabase.save(record) { (_,error) in
            
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
    
    // MARK: - Delete
    func deleteJournal(withRecordID recordID: CKRecordID, completion: @escaping (CKRecordID?, Error?) -> Void) {
        cloudKitManager.privateDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if let error = error {
                print("There was an error deleting from CloudKit. \(error.localizedDescription)")
                completion(recordID, error)
            }
        }
    }

    // MARK: - Update
    func update(journal: JournalDaily) {
        
        let record = CKRecord(journalDaily: journal)
        
        cloudKitManager.modifyRecords([record], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchJournalsFromCloudKit(completion: @escaping () -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "JournalDaily", predicate: predicate)
        
        cloudKitManager.privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            let journals = records.flatMap({ JournalDaily(record: $0)})
            self.journals = journals
            completion()
        }
    }
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.doesRelativeDateFormatting = false
        
        return dateFormatter
    }()
    
    func filterJournalsBy(month: String) -> [JournalDaily] {
        
        var filteredJournals: [JournalDaily] = []
        
        for journal in self.journals {
            let timestampString =  journal.timeStamp.returnMonthOfTimestamp()
            if timestampString.contains(month) {
                filteredJournals.append(journal)
            }
        }
        
        let sortedJournals = filteredJournals.sorted(by: { $0.0.timeStamp > $0.1.timeStamp } )
        return sortedJournals
    }
}

extension Date {
    
    func returnMonthOfTimestamp() -> String {
        
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.doesRelativeDateFormatting = false
            
            return dateFormatter
        }()
        
        let month = formatter.string(from: self)
        return month
    }
}



