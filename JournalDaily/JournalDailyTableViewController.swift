//
//  JournalDailyTableViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/3/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class JournalDailyTableViewController: UITableViewController {
    
//    var journals: [JournalDaily] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JournalDailyController.shared.fetchJournalsFromCloudKit { (journals) in
            JournalDailyController.shared.journals = journals
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return JournalDailyController.shared.journals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? JournalDailyTableViewCell else { return UITableViewCell() }
        let journal = JournalDailyController.shared.journals[indexPath.row]
        
        cell.updateWithJournal(journal: journal)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJournalVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let journalDetailVC = segue.destination as? JouranlDailyEditingViewController else { return }
            let journals = JournalDailyController.shared.journals[indexPath.row]
            journalDetailVC.journal = journals
        }
    }
}
