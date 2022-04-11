//
//  HelpTabBarViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/10/22.
//

import UIKit

class HelpTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func popViewToPreviousScreen(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
