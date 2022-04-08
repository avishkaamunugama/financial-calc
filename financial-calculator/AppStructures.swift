//
//  AppStructures.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

public struct Mortgage: Codable {
    
    var loanAmount:Float = 0.0
    var interestRate: Float = 0.0
    var numOfYears: Float = 0.0
    var monthlyPayment: Float = 0.0
}

public struct Saving: Codable {
    
    var interestRate: Float = 0.0
    var montlyPayment: Float = 0.0
    var numOfYears: Float = 0.0
    var savedAmount:Float = 0.0
    var regularContributionValue:Float = 0.0
}
