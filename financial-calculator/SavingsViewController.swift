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
    var regularContribution: Float = 0.0
    
    var saving : Saving = Saving()
    var prevSaving : Saving?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousCalculation()
        configureTextFields()
    }
    
    func loadPreviousCalculation() {
        
        if prevSaving == nil && savingsList!.count > 0 {
            prevSaving = savingsList?.last
        }
        
        if let lastSaving = prevSaving {
            txtFieldCollection[0].text = "\(lastSaving.montlyPayment)"
            txtFieldCollection[1].text = "\(lastSaving.interestRate)"
            txtFieldCollection[2].text = "\(lastSaving.numOfYears)"
            txtFieldCollection[3].text = "\(lastSaving.savedAmount)"
            txtFieldCollection[4].text = "\(lastSaving.regularContributionValue)"
        }
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
    }
    
    @IBAction func changedSavingsType(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            paymentValueView.isHidden = true
            self.txtFieldCollection[4].text = ""
            self.regularContribution = 0.0
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
        
        saving = Saving(interestRate: self.interestRate, montlyPayment: self.monthlyAmount, numOfYears: self.numberOfYears, savedAmount: self.amountSaved, regularContributionValue: self.regularContribution)
        
        let amountSavedTxt: Float = Formulae.calculateSavings(savingsDetail: saving)
        
        saving.savedAmount = amountSavedTxt
        txtFieldCollection[3].text = String(format: "%.2f", amountSavedTxt)
    }
    
    @IBAction func saveSaving(_ sender: Any) {
        
        savingsList?.append(saving)
        
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


extension SavingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
    }
    
    func getTextFromTextField(_ textField: UITextField) {
        
        if textField == self.txtFieldCollection[0] {
            self.monthlyAmount = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.numberOfYears = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.amountSaved = Float(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[4] {
            self.regularContribution = Float(textField.text!) ?? 0.0
        }
    }
}
