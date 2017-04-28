//
//  JournalDailyTableViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/3/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class JournalDailyTableViewController: UITableViewController {

    let monthsInYear = ["December", "November", "October", "September", "August", "July", "June", "May", "April", "March", "February", "January"]
    
//    enum Months: String {
//        case January = monthsInYear[0]
//        case February = "February"
//        case March = "March"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JournalDailyController.shared.fetchJournalsFromCloudKit { 
            
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
        
        let filteredJournals = JournalDailyController.shared.filterJournalsBy(month: monthsInYear[section])
        return filteredJournals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? JournalDailyTableViewCell else { return UITableViewCell() }
        
        let filteredJournals = JournalDailyController.shared.filterJournalsBy(month: monthsInYear[indexPath.section])
        
        let journal = filteredJournals[indexPath.row]
        
        cell.updateWithJournal(journal: journal)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return monthsInYear.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return monthsInYear[section]
    }
//    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//       let backgroundColor = UIView.backgroundColor = UIColor(red: 21 / 255.0, green: 30 / 255.0, blue: 46 / 255.0, alpha: 100)
//
//        return
//    }
    
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
