//
//  HelpPopUpInstructions.swift
//  financial-calculator
//
//  Created by Avishka Amunugama on 4/11/22.
//

import Foundation
import UIKit

// Mortgage calculation screen help popup instructions
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

// Simple savings calculation screen help popup instructions
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

// Compound savings calculation screen help popup instructions
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

// History screen help popup instructions
func historyViewHelpInstructions() -> NSAttributedString {
    
    let attributedTxt:NSAttributedString = NSMutableAttributedString()
        .bold("1").normal(" - Delete all saved calculations from history.\n")
        .bold("2").normal(" - Swipe left and click delete button that then appears to delete a single calculation.\n")
        .bold("3").normal(" - Click on any calculation to edit.\n\n")
        .normal("For help regarding formulas or any other please check the main help page.\n")
        
    return attributedTxt
}


// This extension was refered from the following link - used for adding text attributes to popup instructions
// https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift

extension NSMutableAttributedString {
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
