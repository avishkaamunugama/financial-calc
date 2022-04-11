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
    
    @IBOutlet var txtFieldCollection: [UITextField]!
    @IBOutlet weak var btnCalculateSavings: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var showInYearsSwitch: UISwitch!
    
    @IBOutlet weak var monthlyPaymentView: UIStackView!
    
    var principleAmount: Double = 0.0
    var interestRate: Double = 0.0
    var monthlyPayment: Double = 0.0
    var futureValue: Double = 0.0
    var numberOfPayments: Double = 0.0
    var isCompoundSaving: Bool = false
    var showInYears: Bool = false
    var navigationTitle: String = "Savings"
    
    var saving : Saving?
    var prevSaving : Saving?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0, weight: .bold)]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        loadPreviousCalculation()
        populateFields()
        configureGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = navigationTitle
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func loadPreviousCalculation(){
        
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
            
            if #available(iOS 13.0, *) {
                txtField.overrideUserInterfaceStyle = .light
            }
            
            txtField.delegate = self
            getTextFromTextField(txtField)
        }
    }
    
    func configureGestures() {

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
        
        loadPreviousCalculation()
        populateFields()
    }
    
    @IBAction func calculateMissingFields(_ sender: Any) {
        
        if emptyFieldCount() > 1 {
            displayAlert(withTitle: "Multiple Empty Fields Found!", withMessage: "Please ONLY leave the field that needs to be calculated blank for the calculations to proceed. Only 1 field can be calculated once.")
            return
        }
        
        if isCompoundSaving {
            compoundSavingCalculations()
        }
        else {
            simpleSavingCalculations()
        }
        
        updateSavingsModel()
    }
    
    func compoundSavingCalculations() {

        if txtFieldCollection[0].text!.isEmpty {
            self.principleAmount = CompundSavingsFormulae.calculateCompundPrincipleAmount(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[0].text = round(number: self.principleAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            displayAlert(withTitle: "Invalid Interest Rate!", withMessage: "To proceed with the calculations please enter a valid interest rate (%).")
            return
        }
        else if txtFieldCollection[2].text!.isEmpty {
            self.monthlyPayment = CompundSavingsFormulae.calculateCompundMonthlyPayment(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[2].text = round(number: self.monthlyPayment, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.futureValue = CompundSavingsFormulae.calculateCompundFutureValue(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[3].text = round(number: self.futureValue, to: 2)
        }
        else if txtFieldCollection[4].text!.isEmpty {
            self.numberOfPayments = CompundSavingsFormulae.calculateCompoundNumberOfPayments(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[4].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.")
            return
        }
    }
    
    func simpleSavingCalculations() {

        if txtFieldCollection[0].text!.isEmpty {
            self.principleAmount = SimpleSavingsFormulae.calculateSimplePrincipleAmount(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[0].text = round(number: self.principleAmount, to: 2)
        }
        else if txtFieldCollection[1].text!.isEmpty {
            self.interestRate = SimpleSavingsFormulae.calculateSimpleInterestRate(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[1].text = round(number: self.interestRate, to: 2)
        }
        else if txtFieldCollection[3].text!.isEmpty {
            self.futureValue = SimpleSavingsFormulae.calculateSimpleFutureValue(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[3].text = round(number: self.futureValue, to: 2)
        }
        else if txtFieldCollection[4].text!.isEmpty {
            self.numberOfPayments = SimpleSavingsFormulae.calculateSimpleNumberOfPayments(inYears: showInYears, savingsDetail: saving!)
            txtFieldCollection[4].text = round(number: self.numberOfPayments, to: 2)
        }
        else {
            displayAlert(withTitle: "No Empty Fields Found!", withMessage: "Please leave the field that needs to be calculated blank for the calculations to proceed.")
            return
        }
    }
    
    func emptyFieldCount()->Int {
        var emptyFieldCount: Int = 0

        // Hide keyboard
        for txtField: UITextField in txtFieldCollection {
            txtField.resignFirstResponder()
            
            if (txtField==txtFieldCollection[2]) && !isCompoundSaving {
                continue
            }
            
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
        if let txt = self.txtFieldCollection[4].text, !txt.isEmpty {
            let numMonths = Double(txt) ?? 0.0
            self.txtFieldCollection[4].text = round(number: numMonths/12, to: 2)
            self.numberOfPayments = numMonths/12
            updateSavingsModel()
        }
    }
    
    func changeToMonths() {
        if let txt = self.txtFieldCollection[4].text, !txt.isEmpty {
            let numYears = Double(txt) ?? 0.0
            self.txtFieldCollection[4].text = round(number: numYears*12, to: 2)
            self.numberOfPayments = numYears*12
            updateSavingsModel()
        }
    }
    
    
    @IBAction func saveSaving(_ sender: Any) {
        
        let maxEmptyFields:Int = isCompoundSaving ? 5 : 4
        
        if let saving = self.saving, emptyFieldCount() < maxEmptyFields {
            savingsList?.append(saving)
            clearAllFields()
        }
        else {
            displayAlert(withTitle: "No Calculations Performed!", withMessage: "Please perform some changes to previous calculation or perform a new calculation before saving.")
        }
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
    
    @IBAction func popToRootView(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
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
}


extension SavingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getTextFromTextField(textField)
        updateSavingsModel()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
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
        
        return true
    }
    
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
