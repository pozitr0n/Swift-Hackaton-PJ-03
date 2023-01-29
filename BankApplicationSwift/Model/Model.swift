//
//  Model.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 25/01/2023.
//

import Foundation
import RealmSwift

//  access to the realm
let realm = try! Realm()

let historyOfOperations = realm.objects(HistoryOfOperations.self)

// getting all the access to the balance
let balanceForLabel = realm.objects(BalanceDeposit.self).first
let detailedBalance = balanceForLabel?.balanceDeposit ?? 0.0

let balanceRounded = round(detailedBalance * 100) / 100
let balanceForShowing = String(balanceRounded)

var prevData: (String, String, Bool) = ("", "", false)

// Other protocol for bank operations
//
protocol OtherMethodsForBankOperationsProtocol {
    func getBalanceForShowing() -> String
}

// Enum with main bank operations
//
enum TypeOfBankOperations: String {
    
    case topUpDeposit               = "Top up bank deposit"
    case withdrawCashFromDeposit    = "Withdraw cash"
    case topUpMobilePhoneBalance    = "Top up mobile"
    
}

// Protocol for bank operations
//
protocol BankOperationsProtocol {
    
    var currentAmount: Float { get }
    var bankOperationType: String { get }
    
    func topUpDeposit(currentAmount: Float) -> Bool
    func withdrawCashFromDeposit(currentAmount: Float) -> Bool
    func addOperationToTheHistory(bankOperationType: TypeOfBankOperations, phoneNumber: String)
    
}

// Protocol for phone numbers operations
//
protocol PhoneNumbersProtocol {
    
    func addNewPhoneNumber(textNumber: String)
    func getCountOfPhoneNumbers() -> Int
    func deletePhoneFromDatabase(index: Int) -> Bool
    func getPhoneBySelection(currRow: Int) -> String
    
}

// Main class for bank operations
//
class ActionsWithBankOperations: BankOperationsProtocol {
    
    // amount for puttinf in/off or bank-transfer
    var currentAmount: Float
    
    // operation type
    var bankOperationType: String
    
    func topUpDeposit(currentAmount: Float) -> Bool {
        
        var resultOfTheOperation: Bool  = false
        let currBalance                 = realm.objects(BalanceDeposit.self).first
        
        if currBalance?.balanceDeposit != nil {
            
            let currentBalance  = currBalance!.balanceDeposit
            let updateBalance   = currentBalance + currentAmount
            
            try! realm.write {
                currBalance?.balanceDeposit = updateBalance
                resultOfTheOperation        = true
            }
            
        } else {
            
            let currentBalance  = 0.0
            let updateBalance   = Float(currentBalance) + currentAmount
            
            let currItem            = BalanceDeposit()
            currItem.balanceDeposit = updateBalance
            
            try! realm.write {
                realm.add(currItem)
                resultOfTheOperation = true
            }
            
        }
        
        return resultOfTheOperation
        
    }
    
    func withdrawCashFromDeposit(currentAmount: Float) -> Bool {
        
        var resultOfTheOperation: Bool  = false
        let currBalance                 = realm.objects(BalanceDeposit.self).first
        
        if currBalance?.balanceDeposit != nil {
        
            let currentBalance  = currBalance!.balanceDeposit
            let updateBalance   = currentBalance - currentAmount
            
            try! realm.write {
                currBalance?.balanceDeposit = updateBalance
                resultOfTheOperation        = true
            }
            
        }
        
        return resultOfTheOperation
    }
    
    func addOperationToTheHistory(bankOperationType: TypeOfBankOperations, phoneNumber: String = "") {
        
        let currentDateForRecord        = NSDate()
        let currentOperationForRecord   = bankOperationType
        let currentAmountForRecord      = currentAmount
        
        let currRecord = HistoryOfOperations()
        
        currRecord.operationData = currentDateForRecord as Date
        
        if phoneNumber.isEmpty {
            currRecord.operationType = currentOperationForRecord.rawValue
        } else {
            currRecord.operationType = currentOperationForRecord.rawValue + "\ninto the phone: \(phoneNumber)"
        }

        currRecord.amount = currentAmountForRecord
        
        try! realm.write {
            realm.add(currRecord)
        }
        
    }
    
    init(currentAmount: Float, bankOperationType: TypeOfBankOperations) {
        self.currentAmount      = currentAmount
        self.bankOperationType  = bankOperationType.rawValue
    }
    
}

// Main class for actions with phone numbers
//
class ActionsWithPhoneNumbers: PhoneNumbersProtocol {
       
    func addNewPhoneNumber(textNumber: String) {
        
        let currentNumber = realm.objects(PhoneNumbers.self).filter("phoneNumber == %@", textNumber).first
        
        if currentNumber == nil {
            
            let currIndex = getCountOfPhoneNumbers()
            let newNumber = PhoneNumbers()
            
            newNumber.phoneNumber   = textNumber
            newNumber.phoneID       = currIndex
            
            try! realm.write {
                realm.add(newNumber)
            }
            
        }
        
    }
    
    func getCountOfPhoneNumbers() -> Int {
    
        let array = realm.objects(PhoneNumbers.self).toArray(ofType: PhoneNumbers.self)
        return array.count > 0 ? array.count : 0
        
    }
    
    func getPhoneBySelection(currRow: Int) -> String {
    
        guard let connection = realm.objects(PhoneNumbers.self).filter("phoneID == %@", currRow).first else { return "" }
        return connection.phoneNumber
        
    }
    
    func deletePhoneFromDatabase(index: Int) -> Bool {
        
        var resultOfTheOperation: Bool  = false
        
        do {
            
            if let connection = realm.objects(PhoneNumbers.self).filter("phoneID == %@", index).first {
                
                try realm.write {
                    realm.delete(connection)
                    resultOfTheOperation = true
                }
            }
            
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
        
        return resultOfTheOperation
        
    }
    
}

class OtherMethodsForBankOperations: OtherMethodsForBankOperationsProtocol {
 
    func getBalanceForShowing() -> String {
        
        let _balanceForLabel = realm.objects(BalanceDeposit.self).first
        let _detailedBalance = _balanceForLabel?.balanceDeposit ?? 0.0

        let _balanceRounded = round(_detailedBalance * 100) / 100
        let _balanceForShowing = String(_balanceRounded)
        
        return _balanceForShowing
        
    }
}

extension Results {

    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
    
}
