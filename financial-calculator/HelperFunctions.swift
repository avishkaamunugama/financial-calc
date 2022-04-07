//
//  HelperFunctions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/7/22.
//

import Foundation

var mortageList:[Mortgage]? {
    didSet{
        saveMortgage(mortages: mortageList!)
    }
}
//var savingsList:[Saving]?

func saveMortgage(mortages:[Mortgage]) {
    print(mortages)
    
    if let encodedData = try? JSONEncoder().encode(mortages) {
        UserDefaults.standard.set(encodedData, forKey: "mortgage-list")
    }
}

//func saveSavings(savingsList:[Saving]) {
//    UserDefaults.standard.set(savingsList, forKey: "savings-list")
//}

func fetchMortgage() -> [Mortgage]? {
    
    guard
        let data = UserDefaults.standard.data(forKey: "mortgage-list"),
        let savedMortages = try? JSONDecoder().decode([Mortgage].self, from: data)
    else {
        return nil
    }
    
    return savedMortages
}

//func fetchSavings() -> [Saving]? {
//    if let savings = UserDefaults.standard.array(forKey: "savings-list") as? [Saving] {
//        return savings
//    }
//    else {
//        return nil
//    }
//}
