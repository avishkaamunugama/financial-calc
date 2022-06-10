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
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var showInYearsSwitch: UISwitch!
    
    // Instance variables
    var mortgage : Mortgage?
    var prevMorgage : Mortgage?
    var borrowingAmount: Double = 0.0
    var interestRate: Double = 0.0
    var monthlyPayment: Double = 0.0
    var numberOfPayments: Double = 0.0
    var showInYears: Bool = false
    var isAbleToCalculate: Bool = false {
        didSet {
            updateCalculateButtonState(isAbleToCalculate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousCalculation()
        populateFields()
        configureGestures()
        checkIfCalculationsPossible()
        updateSaveButtonState(false)
    }
    
    // Loads the last saved calculation
    func loadPreviousCalculation() {
        if prevMorgage == nil && mortgageList!.count > 0 {
            prevMorgage = mortgageList?.last
        }
        
        mortgage = prevMorgage
    }
    
    // Populate the fields with last calculation details
    func populateFields() {
        if let lastMortgage = prevMorgage {
            txtFieldCollection[0].text = round(number: lastMortgage.borrowingAmount, to: 2)
            txtFieldCollection[1].text = round(number: lastMortgage.interestRate, to: 2)
            txtFieldCollection[2].text = round(number: lastMortgage.monthlyPayment, to: 2)
            txtFieldCollection[3].text = round(number: lastMortgage.numOfPayments, to: 2)
            
            self.showInYears = lastMortgage.isShownInYears
            showInYearsSwitch.setOn(lastMortgage.isShownInYears, animated: true)
        }
        
        for txtField: UITextField in txtFieldCollection {
            
            // prevents text field UI changing once the color mode is chnaged
            if #available(iOS 13.0, *) {
                txtField.overrideUserInterfaceStyle = .light
            }
            
            txtField.delegate = self
            getTextFromTextField(txtField)
        }
    }
    
    // Adds a tap gesture recogniser to dismiss keyboard when tapped anywhere
    func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    // Handles tap gesture by hiding the keyboard
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
        }
    }
    
    // Finds the empty field and calculate the value
    @IBAction func calculateMissingField(_ sender: Any) {
        
        // Validate entered fields
        if emptyFieldCount() > 1 {
            displayAlert(withTitle: "Multiple Empty Fields Found!", withMessage: "Please ONLY leave the field that needs to be calculated blank for the calculations to proceed. Only 1 field can be calculated once.",viewController: self)
            return
        }
        else if self.monthlyPayment > self.borrowingAmount &&
                    !txtFieldCollection[0].text!.isEmpty &&
                    !txtFieldCollection[2].text!.isEmpty {
            displayAlert(withTitle: "Invalid Inputs!", withMessage: "The monthly payment value is larger than the borrowing amount. Please recheck the values and try again.",viewController: self)
            return
        }
        
        if txtFieldCollection[0].text!.isEmpty {
            self.borrowingAmount = MortgageFormulae.calculateBorrowingAmount(inYears: showInYears, mortgageDetail: mortgage!)
            
            if self.borrowingAmount.isNaN || self.borrowingAmount.isInfinite || self.borrowingAmount < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum borrowable amount exceeded. Try reducing borrowing amount or increasing the monthly payment.", viewController: self)
                return
            }
            
            txtFieldCollection[0].text = round(number: self.borrowingAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            displayAlert(withTitle: "Invalid Interest Rate!", withMessage: "To proceed with the calculations please enter a valid interest rate (%).",viewController: self)
            return
        }
        else if txtFieldCollection[2].text!.isEmpty {
            self.monthlyPayment = MortgageFormulae.calculateMonthlyPayment(inYears: showInYears, mortgageDetail: mortgage!)
            
            if self.monthlyPayment.isNaN || self.monthlyPayment.isInfinite || self.monthlyPayment < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum payable monthly payment exceeded. Try reducing borrowing amount or increasing the monthly payment.", viewController: self)
                return
            }
            
            txtFieldCollection[2].text = round(number: self.monthlyPayment, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.numberOfPayments = MortgageFormulae.calculateNumberOfPayments(inYears: showInYears, mortgageDetail: mortgage!)
            
            if self.numberOfPayments.isNaN || self.numberOfPayments.isInfinite || self.numberOfPayments < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum number of months exceeded. Try reducing borrowing amount or increasing the monthly payment.", viewController: self)
                return
            }
            
            txtFieldCollection[3].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.",viewController: self)
            return
        }
        
        updateMortgageModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
    }
    
    // Counts the number of empty fields
    func emptyFieldCount()->Int {
        var emptyFieldCount: Int = 0

        for txtField: UITextField in txtFieldCollection {
            
            if txtField.text!.isEmpty {
                emptyFieldCount += 1
            }
        }
        
        return emptyFieldCount
    }
    
    // Sets the calculate button state
    func updateCalculateButtonState(_ isBtnEnabled:Bool) {
        
        if isBtnEnabled{
            self.btnCalculate.alpha = 1.0
            self.btnCalculate.tintColor = .tintColor
        }
        else {
            self.btnCalculate.alpha = 0.5
            self.btnCalculate.tintColor = .gray
        }
    }
    
    // Checks if only one field in empty to calculate
    func checkIfCalculationsPossible() {
        if emptyFieldCount() == 1 {
            self.isAbleToCalculate = true
        }
        else {
            self.isAbleToCalculate = false
        }
    }
    
    // Sets the save button state
    func updateSaveButtonState(_ isBtnEnabled:Bool) {
        
        let saveImgView = self.saveButtonView.viewWithTag(103) as? UIImageView
        let saveBtnTxtLbl = self.saveButtonView.viewWithTag(104) as? UILabel
        let saveBtn = self.saveButtonView.viewWithTag(105) as? UIButton
        
        saveImgView!.image = saveImgView!.image?.withRenderingMode(.alwaysTemplate)
        
        if isBtnEnabled && emptyFieldCount() == 0 {
            self.saveButtonView.alpha = 1.0
            saveBtn!.tintColor = .tintColor
            saveImgView!.tintColor = .tintColor
            saveBtnTxtLbl!.textColor = .tintColor
        }
        else {
            self.saveButtonView.alpha = 0.5
            saveBtn!.tintColor = .gray
            saveImgView!.tintColor = .gray
            saveBtnTxtLbl!.textColor = .gray
        }
    }
    
    // Updates the Mortgage instant variable
    func updateMortgageModel() {
        mortgage = Mortgage(
            borrowingAmount: self.borrowingAmount,
            interestRate: self.interestRate,
            monthlyPayment: self.monthlyPayment,
            numOfPayments: self.numberOfPayments,
            isShownInYears: self.showInYears
        )
    }
    
    // Show Year Switch action
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
    
    // Change the number of months to years
    func changeToYears() {
        if let txt = self.txtFieldCollection[3].text, !txt.isEmpty {
            let numMonths = Double(txt) ?? 0.0
            self.txtFieldCollection[3].text = round(number: numMonths/12, to: 2)
            self.numberOfPayments = numMonths/12
            updateMortgageModel()
        }
    }
    
    // Change the number of years to months
    func changeToMonths() {
        if let txt = self.txtFieldCollection[3].text, !txt.isEmpty {
            let numYears = Double(txt) ?? 0.0
            self.txtFieldCollection[3].text = round(number: numYears*12, to: 2)
            self.numberOfPayments = numYears*12
            updateMortgageModel()
        }
    }
    
    // Save button action
    @IBAction func saveMortgage(_ sender: Any) {
        
        if let mortgage = self.mortgage, emptyFieldCount() == 0 {
            mortgageList?.append(mortgage)
            clearAllFields()
        }
        else {
            displayAlert(withTitle: "No Calculations Performed!", withMessage: "Please perform some changes to previous calculation or perform a new calculation before saving.",viewController: self)
        }
        
    }
    
    // History button action
    @IBAction func viewMortgageCalculationHistory(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "historyView") as? HistoryViewController {
            destVC.calcType = .mortgage
            self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
    // Back button action
    @IBAction func popToRootView(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Clear all button action
    @IBAction func clearAllTextFields(_ sender: UIBarButtonItem) {
        clearAllFields()
    }
    
    // Clears all fields and resets the view to original state
    func clearAllFields(){
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
            txtField.text = ""
            getTextFromTextField(txtField)
            updateSaveButtonState(false)
        }
        
        showInYearsSwitch.setOn(false, animated: true)
    }
    
    // Help button action
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "InstructionsHelpView") as? InstructionsHelpViewController {
            
            destVC.instructionsImg = "sc_mortage"
            destVC.instructionsTxt = mortgageViewHelpInstructions()
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
    }
}


// TextField delegate functions
extension MortgageViewController: UITextFieldDelegate {
    
    // Triggered when a textfield is changed - updates the morgage model
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
        updateMortgageModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
    }
    
    // Triggers when the clear button on each text field is tapped. Zeros the value and update the model
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        
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
        
        updateMortgageModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
        
        return true
    }
    
    // Reads the values entered by user in textfields
    // If any invalid characters are types they are Zeroed
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

