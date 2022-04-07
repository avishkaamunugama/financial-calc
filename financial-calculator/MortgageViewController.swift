//
//  MortgageViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import UIKit

class MortgageViewController: UIViewController {

    
    @IBOutlet var txtFieldCollection: [UITextField]!
    @IBOutlet weak var btnCalculateMortgage: UIButton!
    
    var loanAmount: Float = 0.0
    var interestRate: Float = 0.0
    var numberOfYears: Float = 0.0
    var monthlyPayment: Float = 0.0
    
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
    
    @IBAction func calculateMortgage(_ sender: Any) {
        
        // hide keyboard
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
        
        // calculation
        let mortgage : Mortgage = Mortgage(loanAmount: self.loanAmount, interestRate: self.interestRate, numOfYears: self.numberOfYears)
        
        var mothlyPaymentTxt: Float = Formulae.calculateMortgage(mortgageDetail: mortgage)
        
        if mothlyPaymentTxt.isNaN {
            mothlyPaymentTxt  = 0.0
        }
        
        txtFieldCollection[3].text = String(format: "%.2f", mothlyPaymentTxt)

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

extension MortgageViewController: UITextFieldDelegate {
    

    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
    }
    
    func getTextFromTextField(_ textField: UITextField) {
        
        if textField == self.txtFieldCollection[0] {
            
            if let amount = Float(textField.text!), amount > 0.0 {
                self.loanAmount = amount
            }
            else {
                self.loanAmount = 0.0
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

