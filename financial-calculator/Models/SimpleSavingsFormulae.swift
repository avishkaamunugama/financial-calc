//
//  SimpleSavingsFormulae.swift
//  simple-financial-calculator
//
//  Created by Avishka Amunugama on 4/6/22.
//

import Foundation

class SimpleSavingsFormulae {
    
    static func calculateSimpleFutureValue(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        let P:Double = savingsDetail.principleAmount
        let r:Double = savingsDetail.interestRate / 100
        let n: Double = 12
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = 1 + r/n
        let f2: Double = P*(pow(f1, n*t))
        
        return f2
    }
    
    static func calculateSimplePrincipleAmount(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        let A:Double = savingsDetail.futureValue
        let r:Double = savingsDetail.interestRate / 100
        let n: Double = 12
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = 1 + r/n
        let f2: Double = A/(pow(f1, n*t))
        
        return f2
    }
    
    static func calculateSimpleInterestRate(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        let A:Double = savingsDetail.futureValue
        let P:Double = savingsDetail.principleAmount
        let n: Double = 12
        let t: Double = isYears ? savingsDetail.numberOfPayments : savingsDetail.numberOfPayments/12

        let f1: Double = 1/(n*t)
        let f2: Double = n*(pow(A/P, f1) - 1)

        return f2
    }
    
    static func calculateSimpleNumberOfPayments(inYears isYears:Bool, savingsDetail:Saving)-> Double {
        
        let A:Double = savingsDetail.futureValue
        let P:Double = savingsDetail.principleAmount
        let n: Double = 12
        let r:Double = savingsDetail.interestRate / 100

        let f1: Double = log(A/P)
        let f2: Double = n*log(1+(r/n))
        let f3: Double = f1/f2
        
        return isYears ? f3 : f3*12
        
    }
}
