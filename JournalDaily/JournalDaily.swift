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

class JournalDaily: CloudKitSyncable {
    
    static let kType = "JouranlDaily"
    static let kPhotoData = "photoData"
    static let kTitle = "title"
    static let kJournaltext = "journalText"
    
    let photoData: Data?
    let title: String
    let journalText: String
    var cloudKitRecordID: CKRecordID?
    
    init(photoData: Data?, title: String, journalText: String) {
        self.photoData = photoData
        self.title = title
        self.journalText = journalText
    }
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    // MARK: - CloudKitSyncable
    
    var recordType: String {
        return JournalDaily.kType
    }
    
    
    convenience required init?(record: CKRecord) {
        guard let title = record[JournalDaily.kTitle] as? String,
            let journalText = record[JournalDaily.kJournaltext] as? String,
            let photoAsset = record[JournalDaily.kPhotoData] as? CKAsset
            else { return nil }
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(photoData: photoData, title: title, journalText: journalText)
        
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
extension CKRecord {
    
    convenience init(journalDaily: JournalDaily) {
       
        let recordID = journalDaily.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "JournalDaily", recordID: recordID)
        self.setValue(journalDaily.title, forKey: JournalDaily.kTitle)
        self.setValue(journalDaily.journalText, forKey: JournalDaily.kJournaltext)
        self.setValue(CKAsset(fileURL: journalDaily.temporaryPhotoURL), forKey: JournalDaily.kPhotoData)
    }
    
}
