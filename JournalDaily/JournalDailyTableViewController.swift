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
        // #warning Incomplete implementation, return the number of rows
        return JournalDailyController.shared.journals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? JournalDailyTableViewCell
        let journal = JournalDailyController.shared.journals[indexPath.row]
        
        cell?.updateWithJournal(journal: journal)
        return cell ?? UITableViewCell()
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJournalVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let journalDetailVC = segue.destination as? JournalDailyViewController else { return }
            let journals = JournalDailyController.shared.journals[indexPath.row]
            journalDetailVC.journal = journals
        }
        
    }
}
