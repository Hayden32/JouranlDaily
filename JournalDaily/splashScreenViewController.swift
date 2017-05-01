//
//  splashScreenViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/5/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController, HolderViewDelegate {

var holderView = HolderView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHolderView()
        DispatchQueue.main.async {
            self.holtForASec()
        }
    }
    
    func segueToProfile() {
        self.performSegue(withIdentifier: "splashScreen", sender: self)
    }
    
    func holtForASec() {
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(splashScreenViewController.segueToProfile), userInfo: nil, repeats: false)
    }

    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.expandView()
    }
    
    func animateLabel() {
        holderView.removeFromSuperview()
        view.backgroundColor = UIColor(red: 21 / 255.0, green: 30 / 255.0, blue: 46 / 255.0, alpha: 100)
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = UIColor.white
        label.font = UIFont(name: "cochin", size: 170.0)
        label.textAlignment = NSTextAlignment.center
        label.text = "JT"
        label.transform = label.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(label)
        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveLinear, animations: ({ label.transform = label.transform.scaledBy(x: 4.0, y: 4.0) }), completion: { finished in
        })
    }

}

