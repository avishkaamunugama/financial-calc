//
//  HistoryViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var calcType:CalculationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if self.calcType == nil {
            self.calcType = .all
        }
        
        updateCalcHistory(self.calcType!)
        historyTableView.reloadData()
    }
    
    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        
        let refreshAlert = UIAlertController(title: "Delete All!", message: "All saved calculations will be permanently removed from history.", preferredStyle: .alert)

        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            mortgageList?.removeAll()
            savingsList?.removeAll()
            
            updateCalcHistory(self.calcType!)
            self.historyTableView.reloadData()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func popViewToPreviousScreen(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "InstructionsHelpView") as? InstructionsHelpViewController {
            
            destVC.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(destVC, animated: true)
        }
    }
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount : Int = 0
        
        if let pastCalcs = pastCalculations {
            rowsCount += pastCalcs.count
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.numberOfLines = 0
        
        if let pastCalcs = pastCalculations {
            
            let arrangedTxt = arrangeTextForPreview(pastCalcs[indexPath.row])
            let txtAttribute = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .medium)]
            let attrarrangedTxt = NSAttributedString(string: arrangedTxt, attributes: txtAttribute)
            
            cell.textLabel?.attributedText = attrarrangedTxt
        }
        
        return cell
    }
    
    func arrangeTextForPreview(_ calc:Any) ->String {

        if type(of: calc) == type(of: Saving()) {
            return savingsPreview(calc)

        }
        else if type(of: calc) == type(of: Mortgage()) {
           return mortgagePreview(calc)
        }
        
        return "Unknown Object Type"
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let removeIdx : Int = getSelectedIndexPathRowNumber(from: indexPath)
            
            // Removes the selected item
            if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
                savingsList?.remove(at: removeIdx)
            }
            else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
                mortgageList?.remove(at: removeIdx)
            }
            
            updateCalcHistory(self.calcType!)
            historyTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
            navigateToSavingsScreen(from: indexPath)
            
        }
        else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
            navigateToMortgageScreen(from: indexPath)
        }
    }
    
    func navigateToSavingsScreen(from indexPath:IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "savingsView") as? SavingsViewController {
            
            if let savings = savingsList {
                
                let selectedIdx: Int = getSelectedIndexPathRowNumber(from: indexPath)
                destVC.prevSaving = savings[selectedIdx]
                destVC.isCompoundSaving = savings[selectedIdx].isCompoundSaving
                destVC.navigationTitle = savings[selectedIdx].isCompoundSaving ? "Compound Savings" :"Simple Savings"
            }
            
            self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
    func navigateToMortgageScreen(from indexPath:IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "mortgageView") as? MortgageViewController {
            
            if let mortgages = mortgageList {
                
                let selectedIdx: Int = getSelectedIndexPathRowNumber(from: indexPath)
                destVC.prevMorgage = mortgages[selectedIdx]
            }
            
            self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
    func getSelectedIndexPathRowNumber(from indexPath: IndexPath)-> Int {
        
        // count number of mortgages and savings before the removing index
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
        
        // Calc selected index
        if type(of: pastCalculations![indexPath.row]) == type(of: Saving()) {
            selectedIdx -= mortsCount
        }
        else if type(of: pastCalculations![indexPath.row]) == type(of: Mortgage()) {
            selectedIdx -= savesCount
        }
        
        return selectedIdx
    }
}
