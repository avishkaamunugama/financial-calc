//
//  CompoundSavingsViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import UIKit

class SavingsViewController: UIViewController {
    
    // txtFieldCollection :  Order
    //    0 - Principle Amount
    //    1 - Interest Rate
    //    2 - Monthly Payment
    //    3 - Future Value
    //    4 - Number of Payments
    
    // Outlets
    @IBOutlet var txtFieldCollection: [UITextField]!
    @IBOutlet weak var btnCalculateSavings: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var showInYearsSwitch: UISwitch!
    @IBOutlet weak var monthlyPaymentView: UIStackView!
    
    // Instance variables
    var saving : Saving?
    var prevSaving : Saving?
    var principleAmount: Double = 0.0
    var interestRate: Double = 0.0
    var monthlyPayment: Double = 0.0
    var futureValue: Double = 0.0
    var numberOfPayments: Double = 0.0
    var isCompoundSaving: Bool = false
    var showInYears: Bool = false
    var navigationTitle: String = "Savings"
    var isAbleToCalculate: Bool = false {
        didSet {
            updateCalculateButtonState(isAbleToCalculate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        loadPreviousCalculation()
        populateFields()
        configureGestures()
        checkIfCalculationsPossible()
        updateSaveButtonState(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = navigationTitle // Sets the savings type title
    }
    
    // Apply color and font configurations
    func applyTheme(){
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0, weight: .bold)]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    // Loads the last saved calculation
    func loadPreviousCalculation() {
        
        if prevSaving == nil {
            loadPreviousBasedOnCalculationType()
        }
        saving = prevSaving
    }
    
    // Loads the last calculation depending on the type of calculation
    func loadPreviousBasedOnCalculationType(){
        
        if savingsList!.count > 0 {
            var lastSaving:Saving? = Saving()

            for i in 1...savingsList!.count {
                if let previous = savingsList?[savingsList!.count - i], previous.isCompoundSaving == self.isCompoundSaving {
                    lastSaving = savingsList?[savingsList!.count - i]
                    break
                }
            }
            
            prevSaving = lastSaving
        }
    }
    
    // Populate the fields with last calculation details
    func populateFields() {
        if let lastSaving = prevSaving {
            txtFieldCollection[0].text = round(number: lastSaving.principleAmount, to: 2)
            txtFieldCollection[1].text = round(number: lastSaving.interestRate, to: 2)
            txtFieldCollection[2].text = round(number: lastSaving.monthlyPayment, to: 2)
            txtFieldCollection[3].text = round(number: lastSaving.futureValue, to: 2)
            txtFieldCollection[4].text = round(number: lastSaving.numberOfPayments, to: 2)
            
            self.showInYears = lastSaving.isShownInYears
        }
        
        showInYearsSwitch.setOn(self.showInYears, animated: true)
        segmentedControl.selectedSegmentIndex = self.isCompoundSaving ? 1 : 0
        monthlyPaymentView.isHidden = !self.isCompoundSaving
        
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
    
    // Segmented control action - switches beween simple and compund saving calculations
    @IBAction func changedSavingsType(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.isCompoundSaving = false
            monthlyPaymentView.isHidden = true
            self.title = "Simple Savings"
        case 1:
            self.isCompoundSaving = true
            monthlyPaymentView.isHidden = false
            self.title = "Compound Savings"
        default:
            break
        }
        
        loadPreviousBasedOnCalculationType()
        populateFields()
        checkIfCalculationsPossible()
    }
    
    // Finds the empty field and calculate the value
    @IBAction func calculateMissingFields(_ sender: Any) {
        
        // Validate entered fields
        if emptyFieldCount() > 1 {
            displayAlert(withTitle: "Multiple Empty Fields Found!", withMessage: "Please ONLY leave the field that needs to be calculated blank for the calculations to proceed. Only 1 field can be calculated once.", viewController: self)
            return
        }
        else if self.principleAmount > self.futureValue &&
                    !txtFieldCollection[0].text!.isEmpty &&
                    !txtFieldCollection[3].text!.isEmpty {
            displayAlert(withTitle: "Invalid Inputs!", withMessage: "The principle amount is larger than the future amount. Please recheck the values and try again.",viewController: self)
            return
        }
        
        if isCompoundSaving {
            compoundSavingCalculations()
        }
        else {
            simpleSavingCalculations()
        }
    }
    
    // Calculates the missing field in compound savings calculations
    func compoundSavingCalculations() {

        if txtFieldCollection[0].text!.isEmpty {
            self.principleAmount = CompundSavingsFormulae.calculateCompundPrincipleAmount(inYears: showInYears, savingsDetail: saving!)
            
            if self.principleAmount.isNaN || self.principleAmount.isInfinite || self.principleAmount < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum principle amount exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[0].text = round(number: self.principleAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            displayAlert(withTitle: "Invalid Interest Rate!", withMessage: "To proceed with the calculations please enter a valid interest rate (%).", viewController: self)
            return
        }
        else if txtFieldCollection[2].text!.isEmpty {
            self.monthlyPayment = CompundSavingsFormulae.calculateCompundMonthlyPayment(inYears: showInYears, savingsDetail: saving!)
            
            if self.monthlyPayment.isNaN || self.monthlyPayment.isInfinite || self.monthlyPayment < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum monthly payment allowed exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[2].text = round(number: self.monthlyPayment, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.futureValue = CompundSavingsFormulae.calculateCompundFutureValue(inYears: showInYears, savingsDetail: saving!)
            
            if self.futureValue.isNaN || self.futureValue.isInfinite || self.futureValue < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum future value exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[3].text = round(number: self.futureValue, to: 2)
        }
        else if txtFieldCollection[4].text!.isEmpty {
            self.numberOfPayments = CompundSavingsFormulae.calculateCompoundNumberOfPayments(inYears: showInYears, savingsDetail: saving!)
            
            if self.numberOfPayments.isNaN || self.numberOfPayments.isInfinite || self.numberOfPayments < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum number of payments exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[4].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.", viewController: self)
            return
        }
        
        updateSavingsModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
    }
    
    // Calculates the missing field in simple savings calculations
    func simpleSavingCalculations() {

        if txtFieldCollection[0].text!.isEmpty {
            self.principleAmount = SimpleSavingsFormulae.calculateSimplePrincipleAmount(inYears: showInYears, savingsDetail: saving!)
            
            if self.principleAmount.isNaN || self.principleAmount.isInfinite || self.principleAmount < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum principle amount exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[0].text = round(number: self.principleAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            self.interestRate = SimpleSavingsFormulae.calculateSimpleInterestRate(inYears: showInYears, savingsDetail: saving!)
            
            if self.interestRate.isNaN || self.interestRate.isInfinite || self.interestRate < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum interest rate exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[1].text = round(number: self.interestRate, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.futureValue = SimpleSavingsFormulae.calculateSimpleFutureValue(inYears: showInYears, savingsDetail: saving!)
            
            if self.futureValue.isNaN || self.futureValue.isInfinite || self.futureValue < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum future value exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[3].text = round(number: self.futureValue, to: 2)
        }
        else if txtFieldCollection[4].text!.isEmpty {
            self.numberOfPayments = SimpleSavingsFormulae.calculateSimpleNumberOfPayments(inYears: showInYears, savingsDetail: saving!)
            
            if self.numberOfPayments.isNaN || self.numberOfPayments.isInfinite || self.numberOfPayments < 0 {
                displayAlert(withTitle: "Calculation Error!", withMessage: "Maximum number of payments exceeded. Please recheck the values and try again.", viewController: self)
                return
            }
            
            txtFieldCollection[4].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.",viewController: self)
            return
        }
        
        updateSavingsModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
    }
    
    // Counts the number of empty fields
    func emptyFieldCount()->Int {
        var emptyFieldCount: Int = 0

        for txtField: UITextField in txtFieldCollection {
            // simple savings calculations does not have a monthly payment field
            if (txtField==txtFieldCollection[2]) && !isCompoundSaving {
                continue
            }
            
            if txtField.text!.isEmpty {
                emptyFieldCount += 1
            }
        }
        
        return emptyFieldCount
    }
        
    // Sets the calculate button state
    func updateCalculateButtonState(_ isBtnEnabled:Bool) {
        
        if isBtnEnabled{
            self.btnCalculateSavings.alpha = 1.0
            self.btnCalculateSavings.tintColor = .tintColor
        }
        else {
            self.btnCalculateSavings.alpha = 0.5
            self.btnCalculateSavings.tintColor = .gray
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
    
    // Updates the Saving instant variable
    func updateSavingsModel() {
        saving = Saving(
            principleAmount: self.principleAmount,
            interestRate: self.interestRate,
            monthlyPayment: self.monthlyPayment,
            futureValue: self.futureValue,
            numberOfPayments: self.numberOfPayments,
            isCompoundSaving: self.isCompoundSaving,
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
        if let txt = self.txtFieldCollection[4].text, !txt.isEmpty {
            let numMonths = Double(txt) ?? 0.0
            self.txtFieldCollection[4].text = round(number: numMonths/12, to: 2)
            self.numberOfPayments = numMonths/12
            updateSavingsModel()
        }
    }
    
    // Change the number of years to months
    func changeToMonths() {
        if let txt = self.txtFieldCollection[4].text, !txt.isEmpty {
            let numYears = Double(txt) ?? 0.0
            self.txtFieldCollection[4].text = round(number: numYears*12, to: 2)
            self.numberOfPayments = numYears*12
            updateSavingsModel()
        }
    }
    
    // Save button action
    @IBAction func saveSaving(_ sender: Any) {
        
        if let saving = self.saving, emptyFieldCount() == 0 {
            savingsList?.append(saving)
            clearAllFields()
        }
        else {
            displayAlert(withTitle: "No Calculations Performed!", withMessage: "Please perform some changes to previous calculation or perform a new calculation before saving.", viewController: self)
        }
    }
    
    // History button action
    @IBAction func viewSavingsCalculationHistory(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "historyView") as? HistoryViewController {
            
            if isCompoundSaving {
                destVC.calcType = .compoundSaving
            }
            else{
                destVC.calcType = .simpleSaving
            }
            
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
            
            if self.isCompoundSaving {
                destVC.instructionsImg = "sc_compound"
                destVC.instructionsTxt = compundSavingsViewHelpInstructions()
            }
            else {
                destVC.instructionsImg = "sc_simple"
                destVC.instructionsTxt = simpleSavingsViewHelpInstructions()
            }
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
    }
}


// TextField delegate functions
extension SavingsViewController: UITextFieldDelegate {
    
    // Triggered when a textfield is changed - updates the morgage model
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
        updateSavingsModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
    }
    
    // Triggers when the clear button on each text field is tapped. Zeros the value and update the model
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        
        if textField == self.txtFieldCollection[0] {
            self.principleAmount = 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.monthlyPayment = 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.futureValue = 0.0
        }
        else if textField == self.txtFieldCollection[4] {
            self.numberOfPayments = 0.0
        }
        
        updateSavingsModel()
        checkIfCalculationsPossible()
        updateSaveButtonState(true)
        
        return true
    }
    
    // Reads the values entered by user in textfields
    // If any invalid characters are types they are Zeroed
    func getTextFromTextField(_ textField: UITextField) {
        
        if textField == self.txtFieldCollection[0] {
            self.principleAmount = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[1] {
            self.interestRate = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[2] {
            self.monthlyPayment = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[3] {
            self.futureValue = Double(textField.text!) ?? 0.0
        }
        else if textField == self.txtFieldCollection[4] {
            self.numberOfPayments = Double(textField.text!) ?? 0.0
        }
    }
}
