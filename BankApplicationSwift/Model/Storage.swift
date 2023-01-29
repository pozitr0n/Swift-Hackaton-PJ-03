//
//  Storage.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 25/01/2023.
//

import Foundation
import RealmSwift

// Table with saving a bank deposit value
//
class BalanceDeposit: Object {
    
    // current bank deposit balance
    @objc dynamic var balanceDeposit: Float = 0.0
    
}

// Table with saving mobile numbers
//
class PhoneNumbers: Object {
    
    // phone number
    @objc dynamic var phoneNumber = ""
    
    // phone number ID
    @objc dynamic var phoneID = 0
    
}

// Table with saving a history of all the operations
//
class HistoryOfOperations: Object {
    
    // date of operation
    @objc dynamic var operationData = Date()
    
    // type of the operation
    @objc dynamic var operationType = ""
    
    // amount of the current operation
    @objc dynamic var amount: Float = 0.0
    
}
