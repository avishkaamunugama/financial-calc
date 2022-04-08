//
//  Formulae.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

class Formulae {
    static func calculateMonthlyPayment(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let P: Double = mortgageDetail.borrowingAmount
        let r: Double = mortgageDetail.interestRate / 100.0
        let t: Double = isYears ? mortgageDetail.numOfPayments : mortgageDetail.numOfPayments/12
        let n: Double = 12

        let f1 = pow(1+(r/n), n*t)
        let f2 = ((P*(r/n)) * f1) / ( f1 - 1)
        
        return f2
    }
    
    static func calculateNumberOfPayments(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let P: Double = mortgageDetail.borrowingAmount
        let r: Double = mortgageDetail.interestRate / 100.0
        let pmt: Double = mortgageDetail.monthlyPayment
        let n: Double = 12
        
        let f1 = log10(1-((P/pmt) * (r/n)))
        let f2 = -log10((r/n) + 1)
        let f3 = f1/f2
        
        return isYears ? f3/12 : f3
    }
    
    static func calculateBorrowingAmount(inYears isYears:Bool, mortgageDetail:Mortgage)-> Double {
        let r: Double = mortgageDetail.interestRate / 100.0
        let pmt: Double = mortgageDetail.monthlyPayment
        let t: Double = isYears ? mortgageDetail.numOfPayments*12 : mortgageDetail.numOfPayments
        let n: Double = 12
        
        let f1 = (r/n)
        let f2 = (pmt*(pow(f1 + 1, t)-1)) * pow(f1 + 1, -t)
        let f3 = f2/f1
        
        return f3
    }
    
    static func calculateSavings(savingsDetail:Saving)-> Double {
        let pmt: Double = savingsDetail.montlyPayment
        let r: Double = savingsDetail.interestRate / 100.0
        let t: Double = savingsDetail.numOfYears
        let n: Double = 12
        
        let f1 = pow(Double(1+(r/n)), Double(n*t))
        let f2 = pmt * ((f1 - 1) / (r/n))
        
        return f2
    }
}
