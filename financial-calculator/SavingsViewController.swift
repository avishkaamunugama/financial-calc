//
//  CompoundSavingsViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import UIKit

class SavingsViewController: UIViewController {

    @IBOutlet var txtFieldCollection: [UITextField]!
    @IBOutlet weak var btnCalculateSavings: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var paymentValueView: UIStackView!
    
    var monthlyAmount: Float = 0.0
    var interestRate: Float = 0.0
    var numberOfYears: Float = 0.0
    var amountSaved: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for txtField: UITextField in txtFieldCollection {
            txtField.delegate = self
            addDoneButtonOnNumpad(textField: txtField)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
      }
    
    @IBAction func changedSavingsType(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            paymentValueView.isHidden = true
        case 1:
            paymentValueView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func calculateSavings(_ sender: Any) {
        
        // hide keyboard
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
        
        let saving : Saving = Saving(interestRate: self.interestRate, montlyPayment: self.monthlyAmount, numOfYears: self.numberOfYears)
        
        var amountSavedTxt: Float = Formulae.calculateSavings(savingsDetail: saving)
        
        if amountSavedTxt.isNaN {
            amountSavedTxt  = 0.0
        }
        
        txtFieldCollection[3].text = String(format: "%.2f", amountSavedTxt)
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 35.0))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder))
        
        keypadToolbar.items=[flexSpace,doneButton]
        
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }
    
}

extension SavingsViewController: UITextFieldDelegate {
    

    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
    }
    
    func getTextFromTextField(_ textField: UITextField) {
        
        if textField == self.txtFieldCollection[0] {
            
            if let amount = Float(textField.text!), amount > 0.0 {
                self.monthlyAmount = amount
            }
            else {
                self.monthlyAmount = 0.0
            }
        }
        else if textField == self.txtFieldCollection[1] {
            
            if let amount = Float(textField.text!), amount > 0.0 {
                self.interestRate = amount
            }
            else {
                self.interestRate = 0.0
            }
        }
        else if textField == self.txtFieldCollection[2] {
            
            if let amount = Float(textField.text!), amount > 0.0 {
                self.numberOfYears = amount
            }
            else {
                self.numberOfYears = 0.0
            }
        }
    }
}
