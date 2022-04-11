//
//  MortgageViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import UIKit

class MortgageViewController: UIViewController {
    
// txtFieldCollection :  Order
    //    0 - Borrowing amount
    //    1 - Interest rate
    //    2 - Monthly payment
    //    3 - Number of payments
    
    
    // Outlets
    @IBOutlet var txtFieldCollection: [UITextField]!
    @IBOutlet weak var btnCalculate: UIButton!
    @IBOutlet weak var btnSaveMortgage: UIButton!
    @IBOutlet weak var showInYearsSwitch: UISwitch!
    
    // Instant variables
    var borrowingAmount: Double = 0.0
    var interestRate: Double = 0.0
    var monthlyPayment: Double = 0.0
    var numberOfPayments: Double = 0.0
    var showInYears: Bool = false
    
    var mortgage : Mortgage?
    var prevMorgage : Mortgage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousCalculation()
        configureTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // fills up the text fields with previous calculation details
    func loadPreviousCalculation() {
        if prevMorgage == nil && mortgageList!.count > 0 {
            prevMorgage = mortgageList?.last
        }
        
        if let lastMortgage = prevMorgage {
            txtFieldCollection[0].text = round(number: lastMortgage.borrowingAmount, to: 2)
            txtFieldCollection[1].text = round(number: lastMortgage.interestRate, to: 2)
            txtFieldCollection[2].text = round(number: lastMortgage.monthlyPayment, to: 2)
            txtFieldCollection[3].text = round(number: lastMortgage.numOfPayments, to: 2)
            
            self.showInYears = lastMortgage.isShownInYears
            showInYearsSwitch.setOn(lastMortgage.isShownInYears, animated: true)
        }
    }
    
    // text field delegate and main view gesture configs
    func configureTextFields() {
        for txtField: UITextField in txtFieldCollection {
            
            if #available(iOS 13.0, *) {
                txtField.overrideUserInterfaceStyle = .light
            }
            
            txtField.delegate = self
            getTextFromTextField(txtField)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    // handles tap gesture by hiding the keyboard
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
    }
    
    // finds the empty field and calculate the value
    @IBAction func calculateMissingField(_ sender: Any) {
        
        if emptyFieldCount() > 1 {
            displayAlert(withTitle: "Multiple Empty Fields Found!", withMessage: "Please ONLY leave the field that needs to be calculated blank for the calculations to proceed. Only 1 field can be calculated once.")
            return
        }
        
        if txtFieldCollection[0].text!.isEmpty {
            self.borrowingAmount = MortgageFormulae.calculateBorrowingAmount(inYears: showInYears, mortgageDetail: mortgage!)
            txtFieldCollection[0].text = round(number: self.borrowingAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            displayAlert(withTitle: "Invalid Interest Rate!", withMessage: "To proceed with the calculations please enter a valid interest rate (%).")
            return
        }
        else if txtFieldCollection[2].text!.isEmpty {
            self.monthlyPayment = MortgageFormulae.calculateMonthlyPayment(inYears: showInYears, mortgageDetail: mortgage!)
            
            txtFieldCollection[2].text = round(number: self.monthlyPayment, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.numberOfPayments = MortgageFormulae.calculateNumberOfPayments(inYears: showInYears, mortgageDetail: mortgage!)
            txtFieldCollection[3].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.")
            return
        }
        
        updateCurrentModel()
    }
    
    func emptyFieldCount()->Int {
        var emptyFieldCount: Int = 0

        // Hide keyboard
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
            
            if txtField.text!.isEmpty || Int(txtField.text!) == 0 {
                emptyFieldCount += 1
            }
        }
        
        return emptyFieldCount
    }
    
    func displayAlert(withTitle title:String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateCurrentModel() {
        mortgage = Mortgage(
            borrowingAmount: self.borrowingAmount,
            interestRate: self.interestRate,
            monthlyPayment: self.monthlyPayment,
            numOfPayments: self.numberOfPayments,
            isShownInYears: self.showInYears
        )
    }
    
    
    @IBAction func showPaymentsNumInYears(_ sender: UISwitch) {
        
        if (sender as AnyObject).isOn {
            showInYears = true
            changeToYears()
        }
        else {
            showInYears = false
            changeToMonths()
        }
    }
    
    func changeToYears() {
        if let txt = self.txtFieldCollection[3].text, !txt.isEmpty {
            let numMonths = Double(txt) ?? 0.0
            self.txtFieldCollection[3].text = round(number: numMonths/12, to: 2)
            self.numberOfPayments = numMonths/12
            updateCurrentModel()
        }
    }
    
    func changeToMonths() {
        if let txt = self.txtFieldCollection[3].text, !txt.isEmpty {
            let numYears = Double(txt) ?? 0.0
            self.txtFieldCollection[3].text = round(number: numYears*12, to: 2)
            self.numberOfPayments = numYears*12
            updateCurrentModel()
        }
    }
    
    
    @IBAction func saveMortgage(_ sender: Any) {
        
        if let mortgage = self.mortgage, emptyFieldCount() < 4 {
            mortgageList?.append(mortgage)
            clearAllFields()
        }
        else {
            displayAlert(withTitle: "No Calculations Performed!", withMessage: "Please perform some changes to previous calculation or perform a new calculation before saving.")
        }
        
    }
    
    @IBAction func viewMortgageCalculationHistory(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "historyView") as? HistoryViewController {
            destVC.calcType = .mortgage
            self.navigationController!.pushViewController(destVC, animated: true)
        }
        
    }
    
    @IBAction func popToRootView(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clearAllTextFields(_ sender: UIBarButtonItem) {
        clearAllFields()
    }
    
    func clearAllFields(){
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
            txtField.text = ""
            getTextFromTextField(txtField)
        }
        
        showInYearsSwitch.setOn(false, animated: true)
    }
    
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "InstructionsHelpView") as? InstructionsHelpViewController {
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
    }
}


extension MortgageViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
        updateCurrentModel()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == self.txtFieldCollection[0] {
            self.borrowingAmount = 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.monthlyPayment = 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.numberOfPayments = 0
        }
        
        updateCurrentModel()
        
        return true
    }
    
    func getTextFromTextField(_ textField: UITextField) {
        
        if textField == self.txtFieldCollection[0] {
            self.borrowingAmount = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.monthlyPayment = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.numberOfPayments = Double(textField.text!) ?? 0.0
        }
        
    }
}

