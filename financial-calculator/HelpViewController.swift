//
//  HelpViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var instructionsImgView: UIImageView!
    @IBOutlet weak var transparentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.transparentView.backgroundColor = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.5)
        self.instructionsImgView.image = UIImage(named: "img-help-mortgage")
        
        enableTapGesture()
    }
    
    func enableTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
      }
}
