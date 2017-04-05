//
//  splashScreenViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/5/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        perform(Selector(("showNavController")), with: nil, afterDelay: 3)
    }

    func showNavController() {
        performSegue(withIdentifier: "splashScreen", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

