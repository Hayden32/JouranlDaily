//
//  splashScreenViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/5/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController {

    @IBOutlet weak var journalDailyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        perform(#selector(splashScreenViewController.showNavController), with: nil, afterDelay: 3)
        
        self.journalDailyLabel.center.x = self.view.frame.width + 105
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: .allowAnimatedContent, animations: ({
            self.journalDailyLabel.center.x = self.view.frame.width / 2
        }), completion: nil)
    }

    func showNavController() {
        performSegue(withIdentifier: "splashScreen", sender: self)
    }
}

