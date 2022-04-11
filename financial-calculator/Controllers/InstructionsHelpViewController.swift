//
//  InstructionsHelpViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class InstructionsHelpViewController: UIViewController {
    
    @IBOutlet weak var instructionsViewImgView: UIImageView!
    @IBOutlet weak var intructionsViewTextLabel: UILabel!
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var instructionsScrollView: UIScrollView!
    
    var instructionsImg:String?
    var instructionsTxt:NSAttributedString?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.transparentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        self.instructionsScrollView.layer.masksToBounds = true
        self.instructionsScrollView.layer.cornerRadius = 10.0
        
        self.instructionsViewImgView.image = UIImage(named: instructionsImg!)
        self.intructionsViewTextLabel.attributedText = instructionsTxt
        
        enableTapGesture()
    }
    
    func enableTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.transparentView.addGestureRecognizer(tap)
        self.transparentView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismissPopUp()
    }
    
    @IBAction func dissmissPopUp(_ sender: UIButton) {
        dismissPopUp()
    }
    
    func dismissPopUp(){
        self.dismiss(animated: true, completion: nil)
    }
}
