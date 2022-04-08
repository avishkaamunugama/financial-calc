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
    @IBOutlet weak var btnSaveMortgage: UIButton!
    
    var loanAmount: Float = 0.0
    var interestRate: Float = 0.0
    var numberOfYears: Float = 0.0
    var monthlyPayment: Float = 0.0
    
    var mortgage : Mortgage = Mortgage()
    var prevMorgage : Mortgage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousCalculation()
        configureTextFields()
    }
    
    
    func configureTextFields() {
        for txtField: UITextField in txtFieldCollection {
            
            txtField.delegate = self
            addDoneButtonOnNumpad(textField: txtField)
            getTextFromTextField(txtField)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    
    func loadPreviousCalculation() {
        if prevMorgage == nil && mortgageList!.count > 0 {
            prevMorgage = mortgageList?.last
        }
        
        if let lastMortgage = prevMorgage {
            txtFieldCollection[0].text = "\(lastMortgage.loanAmount)"
            txtFieldCollection[1].text = "\(lastMortgage.interestRate)"
            txtFieldCollection[2].text = "\(lastMortgage.numOfYears)"
            txtFieldCollection[3].text = "\(lastMortgage.monthlyPayment)"
        }
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
        mortgage = Mortgage(loanAmount: self.loanAmount, interestRate: self.interestRate, numOfYears: self.numberOfYears, monthlyPayment: self.monthlyPayment)
        
        let mothlyPaymentTxt: Float = Formulae.calculateMortgage(mortgageDetail: mortgage)
        
        mortgage.monthlyPayment = mothlyPaymentTxt
        txtFieldCollection[3].text = String(format: "%.2f", mothlyPaymentTxt)
    }
    
    @IBAction func saveMortgage(_ sender: Any) {
        
        mortgageList?.append(mortgage)
        
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
            txtField.text = ""
        }
    }
    
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "helpView") as? HelpViewController {
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
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
            self.loanAmount = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.numberOfYears = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.monthlyPayment = Float(textField.text!) ?? 0.0
        }
    }
}

