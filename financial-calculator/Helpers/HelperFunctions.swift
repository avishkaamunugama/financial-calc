//
//  HelperFunctions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import Foundation
import UIKit

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


func mortgageViewHelpInstructions() -> NSAttributedString {
    
    let attributedTxt:NSAttributedString = NSMutableAttributedString()
        .bold("1").normal(" - Clear all fields in page.\n")
        .bold("2").normal(" - Show the number of payments in years or months.\n")
        .bold("3").normal(" - Save the current calculation to memory.\n")
        .bold("4").normal(" - View all saved mortgage calculations.\n")
        .bold("5").normal(" - Calculate and populate the empty field in page.\n\n")
        .normal("For help regarding formulas or any other please check the main help page.\n")
        
    return attributedTxt
}

func simpleSavingsViewHelpInstructions() -> NSAttributedString {
    
    let attributedTxt:NSAttributedString = NSMutableAttributedString()
        .bold("1").normal(" - Clear all fields in page.\n")
        .bold("2").normal(" - Change the calculation type to Compound Savings.\n")
        .bold("3").normal(" - Show the number of payments in years or months.\n")
        .bold("4").normal(" - Save the current calculation to memory.\n")
        .bold("5").normal(" - View all saved simple saving calculations.\n")
        .bold("6").normal(" - Calculate and populate the empty field in page.\n\n")
        .normal("For help regarding formulas or any other please check the main help page.\n")
        
    return attributedTxt
}

func compundSavingsViewHelpInstructions() -> NSAttributedString {
    
    let attributedTxt:NSAttributedString = NSMutableAttributedString()
        .bold("1").normal(" - Clear all fields in page.\n")
        .bold("2").normal(" - Change the calculation type to Simple Savings.\n")
        .bold("3").normal(" - Show the number of payments in years or months.\n")
        .bold("4").normal(" - Save the current calculation to memory.\n")
        .bold("5").normal(" - View all saved compound saving calculations.\n")
        .bold("6").normal(" - Calculate and populate the empty field in page.\n\n")
        .normal("For help regarding formulas or any other please check the main help page.\n")
        
    return attributedTxt
}

func historyViewHelpInstructions() -> NSAttributedString {
    
    let attributedTxt:NSAttributedString = NSMutableAttributedString()
        .bold("1").normal(" - Delete all saved calculations from history.\n")
        .bold("2").normal(" - Swipe left and click delete button that then appears to delete a single calculation.\n")
        .bold("3").normal(" - Click on any calculation to edit.\n\n")
        .normal("For help regarding formulas or any other please check the main help page.\n")
        
    return attributedTxt
}


extension NSMutableAttributedString {
    //This extension was refered from the following link https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .black)}
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
