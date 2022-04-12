//
//  HistoryViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var historyTableView: UITableView!
    
    // Instance variables
    var calcType:CalculationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.calcType == nil {
            self.calcType = .all
        }
        
        updateCalcHistory(self.calcType!)
        historyTableView.reloadData()
    }
    
    // Clear all history button action
    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        
        let refreshAlert = UIAlertController(title: "Delete All!", message: "All saved calculations will be permanently removed from history.", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            
            // Removes all elements from global variables and update tableview
            mortgageList?.removeAll()
            savingsList?.removeAll()
            updateCalcHistory(self.calcType!)
            self.historyTableView.reloadData()
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    // Back button action
    @IBAction func popViewToPreviousScreen(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Help button action
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "InstructionsHelpView") as? InstructionsHelpViewController {
            
            destVC.instructionsImg = "sc_history"
            destVC.instructionsTxt = historyViewHelpInstructions()
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
    }
}


// Tableview delegate and datasource functions
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Defines the number of rows/cells required in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount : Int = 0
        if let pastCalcs = pastCalculations {
            rowsCount += pastCalcs.count
        }
        return rowsCount
    }
    
    // Populates the cells in tableview with past calculation data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiates a simple tableview cell of default style
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 0
        
        // If past calculations available adds the calculation details to the cell
        if let pastCalcs = pastCalculations {
            let arrangedTxt = arrangeTextForPreview(pastCalcs[indexPath.row])
            cell.textLabel?.attributedText = arrangedTxt
        }
        
        return cell
    }
    
    // Arrange the calaculation details in a readable manner for preview
    func arrangeTextForPreview(_ calc:Any) -> NSAttributedString {
        
        let txtAttribute = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        var attributedTxt: NSAttributedString = NSAttributedString(string: "",attributes: txtAttribute)

        if type(of: calc) == type(of: Saving()) {
            attributedTxt = NSAttributedString(string: savingsPreview(calc),attributes: txtAttribute)
        }
        else if type(of: calc) == type(of: Mortgage()) {
            attributedTxt = NSAttributedString(string: mortgagePreview(calc),attributes: txtAttribute)
        }
        
        return attributedTxt
    }
    
    // Format the savings calculations
    func savingsPreview(_ calc:Any) -> String {
        let sCalc:Saving? = calc as? Saving
        var sYearStr:String = "Years"
        if !(sCalc!.isShownInYears) {
            sYearStr = "Months"
        }
        
        if sCalc!.isCompoundSaving {
            return """
            Compund Savings:
            \t- Principle Amount: $\(round(number: sCalc!.principleAmount, to: 2))
            \t- Interest Rate: \(round(number: sCalc!.interestRate, to: 2))%
            \t- Monthly Payment: $\(round(number: sCalc!.monthlyPayment, to: 2))
            \t- Number of Payments: \(round(number: sCalc!.numberOfPayments, to: 2)) \(sYearStr)
            """
        }
        else {
            return """
            Simple Savings:
            \t- Principle Amount: $\(round(number: sCalc!.principleAmount, to: 2))
            \t- Interest Rate: \(round(number: sCalc!.interestRate, to: 2))%
            \t- Number of Payments: \(round(number: sCalc!.numberOfPayments, to: 2)) \(sYearStr)
            """
        }
    }
    
    // Format the savings calculations
    func mortgagePreview(_ calc:Any) -> String {
        let mCalc:Mortgage? = calc as? Mortgage
        var mYearStr:String = "Years"
        if !(mCalc!.isShownInYears) {
            mYearStr = "Months"
        }
        
        return """
        Loans & Mortgages:
        \t- Borrowing Amount: $\(round(number: mCalc!.borrowingAmount, to: 2))
        \t- Interest Rate: \(round(number: mCalc!.interestRate, to: 2))%
        \t- Monthly Payment: $\(round(number: mCalc!.monthlyPayment, to: 2))
        \t- Number of Payments: \(round(number: mCalc!.numOfPayments, to: 2)) \(mYearStr)
        """
    }
    
    // Handling delete calculation gesture
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let removeIdx : Int = getSelectedIndexPathRowNumber(from: indexPath)
            
            // Removes the element from global variables
            if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
                savingsList?.remove(at: removeIdx)
            }
            else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
                mortgageList?.remove(at: removeIdx)
            }
            
            // Update tableview
            updateCalcHistory(self.calcType!)
            historyTableView.reloadData()
        }
    }
    
    // Handling calculation selection action - once user taps on a calculation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
            navigateToSavingsScreen(from: indexPath)
        }
        else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
            navigateToMortgageScreen(from: indexPath)
        }
    }
    
    // Navigates to saving calculation screen with the tapped claculation details
    func navigateToSavingsScreen(from indexPath:IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "savingsView") as? SavingsViewController {
            
            // If not nil defines the calculation details in the instantiated view controller
            if let savings = savingsList {
                let selectedIdx: Int = getSelectedIndexPathRowNumber(from: indexPath)
                destVC.prevSaving = savings[selectedIdx]
                destVC.isCompoundSaving = savings[selectedIdx].isCompoundSaving
                destVC.navigationTitle = savings[selectedIdx].isCompoundSaving ? "Compound Savings" :"Simple Savings"
            }
            
            self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
    // Navigates to mortgage calculation screen with the tapped claculation details
    func navigateToMortgageScreen(from indexPath:IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "mortgageView") as? MortgageViewController {
            
            // If not nil defines the calculation details in the instantiated view controller
            if let mortgages = mortgageList {
                let selectedIdx: Int = getSelectedIndexPathRowNumber(from: indexPath)
                destVC.prevMorgage = mortgages[selectedIdx]
            }
            
            self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
    // Getting the exact selectd element index in global variables from the selected indexpath
    func getSelectedIndexPathRowNumber(from indexPath: IndexPath)-> Int {
        
        // Count number of mortgages and savings before the removing index
        var selectedIdx : Int = indexPath.row
        let itemsBeforeIdxList : ArraySlice<Any> = pastCalculations![0...selectedIdx]
        
        var mortsCount: Int = 0
        var savesCount: Int = 0
        
        for item in itemsBeforeIdxList {
            if type(of: item) == type(of: Saving()) {
                savesCount += 1
            }
            else if type(of: item) == type(of: Mortgage()) {
                mortsCount += 1
            }
        }
        
        // For any type of calculation
        //      Element index in global variable = (selected index row) - (count of other types of item before that index)
        
        if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
            selectedIdx -= mortsCount
        }
        else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
            selectedIdx -= savesCount
        }
        
        return selectedIdx
    }
}
