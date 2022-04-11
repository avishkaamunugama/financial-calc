//
//  CompundSavingsFormulae.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

class CompundSavingsFormulae {

    static func compundInterestForPrincipleAmount(_ isYears:Bool, _ savingsDetail:Saving)-> Double {
        let P: Double = savingsDetail.principleAmount
        let n: Double = 12
        let r: Double = savingsDetail.interestRate / 100.0
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = 1 + (r/n)
        let f2: Double = P*pow(f1,n*t)

        return f2
    }
    
    static func compundFutureValueOfASeries(_ isYears:Bool, _ savingsDetail:Saving)-> Double {
        let PMT: Double = -1 * savingsDetail.monthlyPayment
        let n: Double = 12
        let r: Double = savingsDetail.interestRate / 100.0
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = r/n
        let f2: Double = ((pow(1+f1, n*t) - 1)/f1)
        let f3: Double = PMT*f2

        return -1 * f3
    }
    
    static func calculateCompundFutureValue(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        
        let f1: Double = compundInterestForPrincipleAmount(isYears, savingsDetail)
        let f2: Double = compundFutureValueOfASeries(isYears, savingsDetail)
        let f3: Double = f1 + f2
        return f3
        
    }
    
    static func calculateCompundPrincipleAmount(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        
        let PMT: Double = savingsDetail.monthlyPayment
        let A: Double = savingsDetail.futureValue
        let n: Double = 12
        let r: Double = savingsDetail.interestRate / 100.0
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = r/n
        let f2: Double = n*t
        let f3: Double = (pow(1+f1,f2)-1) / f1
        let f4: Double = (A-(PMT*f3)) / pow(1+f1,f2)
        
        return f4
    }
    
    static func calculateCompundMonthlyPayment(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        
        let P: Double = savingsDetail.principleAmount
        let A: Double = savingsDetail.futureValue
        let n: Double = 12
        let r: Double = savingsDetail.interestRate / 100.0
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = r/n
        let f2: Double = n*t
        let f3: Double = A-(P*(pow(1+f1,f2)))
        let f4: Double = (pow(1+f1,f2)-1)/f1
        let f5: Double = f3/f4
        
        return f5
        
    }
    
    static func calculateCompoundNumberOfPayments(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        
        let P: Double = savingsDetail.principleAmount
        let PMT: Double = savingsDetail.monthlyPayment
        let A: Double = savingsDetail.futureValue
        let r: Double = savingsDetail.interestRate / 100.0
        let n: Double = 12
        
        let f1: Double = PMT*n
        let f2: Double = log(A+(f1/r)) - log(((r*P)+f1)/r)
        let f3: Double = n * log(1+(r/n))
        let f4 : Double = f2/f3
        
        return isYears ? f4 : f4*12
        
    }
}
