//
//  Formulae.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

class Formulae {
    static func calculateMortgage(mortgageDetail:Mortgage)-> Float {
        let P: Float = mortgageDetail.loanAmount
        let r: Float = mortgageDetail.interestRate / 100.0
        let t: Float = mortgageDetail.numOfYears
        let n: Float = 12
        
        let f1 = pow(Float(1+(r/n)), Float(n*t))
        let f2 = ((P*(r/n)) * f1) / ( f1 - 1)
        
        return f2
    }
    
    static func calculateSavings(savingsDetail:Saving)-> Float {
        let pmt: Float = savingsDetail.montlyPayment
        let r: Float = savingsDetail.interestRate / 100.0
        let t: Float = savingsDetail.numOfYears
        let n: Float = 12
        
        let f1 = pow(Float(1+(r/n)), Float(n*t))
        let f2 = pmt * ((f1 - 1) / (r/n))
        
        return f2
    }
}
