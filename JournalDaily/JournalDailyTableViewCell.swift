//
//  JournalDailyTableViewCell.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/3/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class JournalDailyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var journalImageView: UIImageView!
    
    var journal: JournalDaily? {
        didSet {
            guard let journal = journal else { return }
            updateWithJournal(journal: journal)
        }
    }

    func updateWithJournal(journal: JournalDaily) {
        titleLable.text = journal.title
        journalImageView.image = journal.photo
    }
}
