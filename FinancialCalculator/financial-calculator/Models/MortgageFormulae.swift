//
//  MortgageFormulae.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

// For the exact latex mathematical formulaes used here please refer the FinancialFormula.pdf in main repository

import Foundation

class MortgageFormulae {
    
    // Calculates the monthly payment values based on other details provided
    static func calculateMonthlyPayment(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let P: Double = mortgageDetail.borrowingAmount
        let r: Double = mortgageDetail.interestRate / 100.0
        let t: Double = isYears ? mortgageDetail.numOfPayments : mortgageDetail.numOfPayments/12
        let n: Double = 12

        let f1: Double = pow(1+(r/n), n*t)
        let f2: Double = ((P*(r/n)) * f1) / ( f1 - 1)
        
        return f2
    }
    
    // Calculates the number of payments required based on other details provided
    static func calculateNumberOfPayments(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let P: Double = mortgageDetail.borrowingAmount
        let r: Double = mortgageDetail.interestRate / 100.0
        let pmt: Double = mortgageDetail.monthlyPayment
        let n: Double = 12
        
        let f1: Double = log10(1-((P/pmt) * (r/n)))
        let f2: Double = -log10((r/n) + 1)
        let f3: Double = f1/f2
        
        return isYears ? f3/12 : f3
    }
    
    // Calculates the max amount that can be borrowed based on other details provided
    static func calculateBorrowingAmount(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let r: Double = mortgageDetail.interestRate / 100.0
        let pmt: Double = mortgageDetail.monthlyPayment
        let t: Double = isYears ? mortgageDetail.numOfPayments*12 : mortgageDetail.numOfPayments
        let n: Double = 12
        
        let f1: Double = (r/n)
        let f2: Double = (pmt*(pow(f1 + 1, t)-1)) * pow(f1 + 1, -t)
        let f3: Double = f2/f1
        
        return f3
    }
    
}
