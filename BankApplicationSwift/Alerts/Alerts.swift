//
//  Alerts.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 27/01/2023.
//

import Foundation
import RealmSwift
import UIKit

// All the protocols for alerts
//
protocol AlertsProtocol {
    func topUpDeposit(mainController: UIViewController)
    func withdrawCashFromDeposit(mainController: UIViewController)
    func moneyLackAlert(mainController: UIViewController)
    func checkRequiredFieldsBeforePuttingMoney(mainController: UIViewController)
}

// Class of all the main custom alerts
//
class Alerts: AlertsProtocol {
    
    private init(){}
    static let sharingClass = Alerts()
    
    // Alert-method for top the money into deposit
    //
    func topUpDeposit(mainController: UIViewController) {
        
        guard let myMainViewController = mainController as? ViewController else { return }
        
        let alert = UIAlertController(title: "Top up deposit", message: "You can top up your bank deposit...", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter the amount here..."
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Put in", style: .cancel) { action in
            
            guard let textAmount = alert.textFields?.first, let amountNumber = Float(textAmount.text ?? "0.0") else { return }
            
            let operation = ActionsWithBankOperations(currentAmount: amountNumber,
                                                      bankOperationType: .topUpDeposit)
            
            if operation.topUpDeposit(currentAmount: amountNumber) {
                
                operation.addOperationToTheHistory(bankOperationType: .topUpDeposit)
                
                let newBalanceDeposit = realm.objects(BalanceDeposit.self)
                let newBalanceDepositLabel = newBalanceDeposit.first
                let newBalanceDepositRounded = round(newBalanceDepositLabel!.balanceDeposit * 100) / 100
                
                let roundedAmount = round(amountNumber * 100) / 100
                
                let textMessage = """
                Your deposit has been
                replenished by the
                amount \(roundedAmount) zł
                """
                
                myMainViewController.currentOperationLabel.text = textMessage
                
                myMainViewController.balanceLabel.text = String(newBalanceDepositRounded) + " zł"
                myMainViewController.tableView.reloadData()
                
            }

        })
        
        mainController.present(alert, animated: true, completion: nil)
        
    }
    
    // Alert-method for withdraw cash from the deposit
    //
    func withdrawCashFromDeposit(mainController: UIViewController) {
        
        guard let myMainViewController = mainController as? ViewController else { return }
        
        let alert = UIAlertController(title: "Withdraw cash from bank deposit", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter the amount..."
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Withdraw", style: .cancel) { action in
            
            guard let textAmount = alert.textFields?.first, let amountNumber = Float(textAmount.text ?? "0.0") else { return }
            
            let currentBalance = realm.objects(BalanceDeposit.self)
            let currentBalanceCheck = currentBalance.first
            let currentBalanceRounded = round(currentBalanceCheck!.balanceDeposit * 100) / 100
            
            if amountNumber <= currentBalanceRounded {
                
                let operation = ActionsWithBankOperations(currentAmount: amountNumber, bankOperationType: .withdrawCashFromDeposit)
                
                if operation.withdrawCashFromDeposit(currentAmount: amountNumber) {
                    
                    operation.addOperationToTheHistory(bankOperationType: .withdrawCashFromDeposit)
                    
                    let newBalanceDeposit = realm.objects(BalanceDeposit.self)
                    let newBalanceDepositLabel = newBalanceDeposit.first
                    let newBalanceDepositRounded = round(newBalanceDepositLabel!.balanceDeposit * 100) / 100
                    
                    let roundedAmount = round(amountNumber * 100) / 100
                    
                    let textMessage = """
                    \(roundedAmount) zł has
                    been withdrawn from
                    your deposit
                    """
                    
                    myMainViewController.currentOperationLabel.text = textMessage
                    
                    myMainViewController.balanceLabel.text = String(newBalanceDepositRounded) + " zł"
                    myMainViewController.tableView.reloadData()
                    
                }
                
            } else {
                self.moneyLackAlert(mainController: myMainViewController)
            }
            
        })
        
        mainController.present(alert, animated: true, completion: nil)
        
    }
    
    // Alert-method for checking the money
    //
    func moneyLackAlert(mainController: UIViewController) {
     
        let alert = UIAlertController(title: "Warning!", message: "There're not enough money on your bank deposit for this operation", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        mainController.present(alert, animated: true)
        
    }
   
    // Alert-method for checking before user will put money into mobile phone
    //
    func checkRequiredFieldsBeforePuttingMoney(mainController: UIViewController) {
        
        let alert = UIAlertController(title: "Warning!", message: "Required fields not filled! Repeat the operation again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        mainController.present(alert, animated: true)
        
    }
    
}
