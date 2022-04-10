//
//  HelperFunctions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import Foundation

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

func updateCalcHistory() {
    pastCalculations = (mortgageList! + savingsList!)
}

func round(number num:Double, to dp:Int) -> String {
    return String(format: "%.\(dp)f", num)
}

