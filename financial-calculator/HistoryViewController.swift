//
//  HistoryViewController.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCalcHistory()
        historyTableView.reloadData()
    }
    
    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        
        mortgageList?.removeAll()
        savingsList?.removeAll()
        
        updateCalcHistory()
        historyTableView.reloadData()
    }
    
    @IBAction func viewHelpScreen(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "helpView") as? HelpViewController {
            
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
            cell.textLabel?.text = "\(pastCalcs[indexPath.row])"
        }
        
        return cell
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
            
            updateCalcHistory()
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
        print("not yet done")
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
