//
//  HelpViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HelpViewController: UIViewController {
    
    // Outlets
    @IBOutlet var darkSectionBackgroundViews: [UIView]!
    @IBOutlet var lightSectionBackgroundViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
    // Apply color and other UI configurations
    func applyTheme() {
        for bgView in darkSectionBackgroundViews{
            bgView.layer.masksToBounds=true
            bgView.layer.cornerRadius = 10
            bgView.backgroundColor = UIColor(red: 214.0, green: 214.0, blue: 214.0, alpha: 1.0)
        }
        
        for bgView in lightSectionBackgroundViews{
            bgView.layer.masksToBounds=true
            bgView.layer.cornerRadius = 10
            bgView.layer.borderWidth = 1.5
            bgView.layer.borderColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.00).cgColor
            bgView.backgroundColor = UIColor.systemBackground
        }
    }
}

