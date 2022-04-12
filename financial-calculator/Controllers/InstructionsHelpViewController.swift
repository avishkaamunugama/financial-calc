//
//  InstructionsHelpViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class InstructionsHelpViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var instructionsViewImgView: UIImageView!
    @IBOutlet weak var intructionsViewTextLabel: UILabel!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var instructionsScrollView: UIScrollView!
    
    // Instance variables
    var instructionsImg:String?
    var instructionsTxt:NSAttributedString?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        configureGestures()
    }
    
    // Apply color, text and image configurations
    func applyTheme() {
        self.transparentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.instructionsScrollView.layer.masksToBounds = true
        self.instructionsScrollView.layer.cornerRadius = 10.0
        self.instructionsViewImgView.image = UIImage(named: instructionsImg!)
        self.intructionsViewTextLabel.attributedText = instructionsTxt
    }
    
    // Adds a tap gesture recogniser to dismiss pop up when tapped on transparent area
    func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopUp(_:)))
        self.transparentView.addGestureRecognizer(tap)
        self.transparentView.isUserInteractionEnabled = true
    }
    
    // Handles tap gesture by dissmissing pop up
    @objc func dismissPopUp(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    // Close pop up button action
    @IBAction func closePopUpBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
