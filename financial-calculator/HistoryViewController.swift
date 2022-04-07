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
        historyTableView.reloadData()
    }
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount : Int = 0
        
        if let mortgages = mortageList {
            rowsCount += mortgages.count
        }
        
//        if let savings = savingsList {
//            rowsCount += savings.count
//        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 0
        
        if let mortgages = mortageList {
            cell.textLabel?.text = "Mortgage : \(mortgages[indexPath.row])"
        }
        
//        if let savings = savingsList {
//            cell.textLabel?.text = "Saving : \(savings[indexPath.row])"
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            mortageList?.remove(at: indexPath.row)
            historyTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyBoard.instantiateViewController(withIdentifier: "mortgageView") as? MortgageViewController {
            
            if let mortgages = mortageList {
                destVC.prevMorgage = mortgages[indexPath.row]
            }

           self.navigationController!.pushViewController(destVC, animated: true)
        }
    }
    
}
