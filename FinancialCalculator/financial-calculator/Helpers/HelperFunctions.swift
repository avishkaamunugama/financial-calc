//
//  HelperFunctions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import Foundation
import UIKit

// Encodes the mortgage object and save to user defaults
func saveMortgage(mortgages:[Mortgage]) {
    
    if let encodedData = try? JSONEncoder().encode(mortgages) {
        UserDefaults.standard.set(encodedData, forKey: mortgageKey)
    }
}

// Encodes the saving object and save to user defaults
func saveSavings(savings:[Saving]) {
    
    if let encodedData = try? JSONEncoder().encode(savings) {
        UserDefaults.standard.set(encodedData, forKey: savingsKey)
    }
}

//Fectch the saved encoded mortgages, decodes them and casts back to mortgage type
func fetchMortgage() -> [Mortgage]? {
    
    guard
        let data = UserDefaults.standard.data(forKey: mortgageKey),
        let savedmortgages = try? JSONDecoder().decode([Mortgage].self, from: data)
    else {
        return nil
    }
    
    return savedmortgages
}

//Fectch the saved encoded savings, decodes them and casts back to saving type
func fetchSavings() -> [Saving]? {
    
    guard
        let data = UserDefaults.standard.data(forKey: savingsKey),
        let savedSavings = try? JSONDecoder().decode([Saving].self, from: data)
    else {
        return nil
    }
    
    return savedSavings
}

// Rounds off doubles to the number of decimal places required
func round(number num:Double, to dp:Int) -> String {
    
    if num == 0.0 {
        return ""
    }
    
    return String(format: "%.\(dp)f", num)
}

// Updates the past calculation global variable with calculation of the required type
func updateCalcHistory(_ calcType:CalculationType) {
    
    switch calcType {
    case .mortgage:
        pastCalculations = mortgageList!
    case .simpleSaving:
        pastCalculations = returnSimpleSavings()
    case .compoundSaving:
        pastCalculations = returnCompundSavings()
    case .all:
        pastCalculations = (mortgageList! + savingsList!)
    }
}

// From a list of savings return the compund savings in it
func returnCompundSavings() -> [Saving] {
    
    var compSavings:[Saving] = []
    
    for calc in savingsList! {
        if calc.isCompoundSaving {
            compSavings.append(calc)
        }
    }
    
    return compSavings
}

// From a list of savings return the simple savings in it
func returnSimpleSavings() -> [Saving] {
    
    var simpSavings:[Saving]  = []
    
    for saving in savingsList! {
        if !(saving.isCompoundSaving) {
            simpSavings.append(saving)
        }
    }
    
    return simpSavings
}

// Displays an alert with the required details
func displayAlert(withTitle title:String, withMessage message:String, viewController:UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
