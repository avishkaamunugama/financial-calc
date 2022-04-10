//
//  ViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func viewHelpScreen(_ sender: UIButton) {
        
        
    }
    
    @IBAction func navigateToSimpleSavingsScreen(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "savingsView") as? SavingsViewController {
            
            destVC.isCompoundSaving = false
            destVC.navigationTitle = "Simple Savings"

            self.navigationController!.pushViewController(destVC, animated: true)
        }
        
    }
    @IBAction func navigateToCompoundSavingsScreen(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "savingsView") as? SavingsViewController {
            
            destVC.isCompoundSaving = true
            destVC.navigationTitle = "Compound Savings"

            self.navigationController!.pushViewController(destVC, animated: true)
        }
        
    }
    
}

