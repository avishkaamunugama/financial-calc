//
//  GlobalVariables.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/10/22.
//

import Foundation

// Contant keys used for storing the data in userdefaults
let mortgageKey: String = "mortgage-list"
let savingsKey: String = "savings-list"

// Types of calculation for diplaying populating the tableview
enum CalculationType {
  case mortgage, simpleSaving, compoundSaving, all
}

// List for holding all mortgage calculations
var mortgageList:[Mortgage]? {
    didSet{
        saveMortgage(mortgages: mortgageList!)
    }
}

// List for holding all saving calculations
var savingsList:[Saving]? {
    didSet{
        saveSavings(savings: savingsList!)
    }
}

// List for holding all saved calculations, used when populating tableview
var pastCalculations : [Any]?
