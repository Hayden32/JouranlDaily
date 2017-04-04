//
//  JouranlDailyEditingViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/4/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class JouranlDailyEditingViewController: UIViewController {
    
    var journal: JournalDaily?
    
    @IBOutlet weak var journalPictureImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    
    
    func updateViews() {
        guard let journal = journal else { return }
        titleTextField.text = journal.title
        journalPictureImageView.image = journal.photo
        journalTextView.text = journal.journalText
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJournalEditingVC" {
            guard let viewController = segue.destination as? JournalDailyViewController else { return }
            
        }
    }
}

