//
//  JournalDaily.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/2/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class JournalDaily: CloudKitSyncable, Equatable {
    
    static let kType = "JouranlDaily"
    static let kPhotoData = "photoData"
    static let kTitle = "title"
    static let kTimeStamp = "timeStamp"
    static let kJournaltext = "journalText"
    
    var photoData: Data?
    var title: String
    var journalText: String
    var timeStamp: Date
    var cloudKitRecordID: CKRecordID?
    
    init(photoData: Data?, title: String, journalText: String, timeStamp: Date = Date()) {
        self.photoData = photoData
        self.title = title
        self.journalText = journalText
        self.timeStamp = timeStamp
    }
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    // MARK: - CloudKitSyncable
    
    var recordType: String {
        return JournalDaily.kType
    }
    
    // Takes in a CKRecord and turns in into a model Object.
    convenience required init?(record: CKRecord) {
        guard let title = record[JournalDaily.kTitle] as? String,
            let journalText = record[JournalDaily.kJournaltext] as? String,
            let timeStamp = record[JournalDaily.kTimeStamp] as? Date,
            let photoAsset = record[JournalDaily.kPhotoData] as? CKAsset
            else { return nil }
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(photoData: photoData, title: title, journalText: journalText, timeStamp: timeStamp)
        
        cloudKitRecordID = record.recordID
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDictionary = NSTemporaryDirectory()
        let temporaryDictionaryURL = URL(fileURLWithPath: temporaryDictionary)
        let fileURL = temporaryDictionaryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: .atomic)
        return fileURL
    }
    
}

// Turns model into a CKRecord and saves it in cloudKit
extension CKRecord {
    
    convenience init(journalDaily: JournalDaily) {
       
        let recordID = journalDaily.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "JournalDaily", recordID: recordID)
        self.setValue(journalDaily.title, forKey: JournalDaily.kTitle)
        self.setValue(journalDaily.journalText, forKey: JournalDaily.kJournaltext)
        self[JournalDaily.kTimeStamp] = journalDaily.timeStamp as CKRecordValue?
        self.setValue(CKAsset(fileURL: journalDaily.temporaryPhotoURL), forKey: JournalDaily.kPhotoData)
    }
}

func ==(lhs: JournalDaily, rhs: JournalDaily) -> Bool {
    return lhs === rhs
}
