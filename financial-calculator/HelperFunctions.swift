//
//  HelperFunctions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import Foundation

enum CalculationType {
  case mortgage, simpleSaving, compoundSaving, all
}

let mortgageKey: String = "mortgage-list"
let savingsKey: String = "savings-list"

var pastCalculations : [Any]?

var mortgageList:[Mortgage]? {
    didSet{
        saveMortgage(mortgages: mortgageList!)
    }
}

var savingsList:[Saving]? {
    didSet{
        saveSavings(savings: savingsList!)
    }
}

func saveMortgage(mortgages:[Mortgage]) {
    
    if let encodedData = try? JSONEncoder().encode(mortgages) {
        UserDefaults.standard.set(encodedData, forKey: mortgageKey)
    }
}

func saveSavings(savings:[Saving]) {
    
    if let encodedData = try? JSONEncoder().encode(savings) {
        UserDefaults.standard.set(encodedData, forKey: savingsKey)
    }
}

func fetchMortgage() -> [Mortgage]? {
    
    guard
        let data = UserDefaults.standard.data(forKey: mortgageKey),
        let savedmortgages = try? JSONDecoder().decode([Mortgage].self, from: data)
    else {
        return nil
    }
    
    return savedmortgages
}

func fetchSavings() -> [Saving]? {
    
    guard
        let data = UserDefaults.standard.data(forKey: savingsKey),
        let savedSavings = try? JSONDecoder().decode([Saving].self, from: data)
    else {
        return nil
    }
    
    return savedSavings
}

func round(number num:Double, to dp:Int) -> String {
    
    if num == 0.0 {
        return ""
    }
    return String(format: "%.\(dp)f", num)
}

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

func returnCompundSavings() -> [Saving] {
    
    var compSavings:[Saving] = []
    
    for calc in savingsList! {
        if calc.isCompoundSaving {
            compSavings.append(calc)
        }
    }
    
    return compSavings
}

func returnSimpleSavings() -> [Saving]? {
    
    var simpSavings:[Saving]  = []
    
    for saving in savingsList! {
        if !(saving.isCompoundSaving) {
            simpSavings.append(saving)
        }
    }
    
    return simpSavings
}
