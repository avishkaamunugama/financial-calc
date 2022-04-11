//
//  HelpViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet var darkSectionBackgroundViews: [UIView]!
    @IBOutlet var lightSectionBackgroundViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
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
            bgView.layer.borderColor = UIColor.lightGray.cgColor
            bgView.backgroundColor = UIColor.systemBackground
        }
    }
}

