//
//  AppStructures.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

public struct Mortgage: Codable {
    
    var borrowingAmount:Double = 0.0
    var interestRate: Double = 0.0
    var monthlyPayment: Double = 0.0
    var numOfPayments: Double = 0.0
    var isShownInYears: Bool = false
}

public struct Saving: Codable {
    
    var interestRate: Double = 0.0
    var montlyPayment: Double = 0.0
    var numOfYears: Double = 0.0
    var savedAmount:Double = 0.0
    var regularContributionValue:Double = 0.0
}
