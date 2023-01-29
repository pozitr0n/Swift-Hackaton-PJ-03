//
//  MoneyIntoMobileViewController.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 29/01/2023.
//

import UIKit
import RealmSwift

class MoneyIntoMobileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var balanceToPutIn: Float = 0.0
    
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var minusOneZlotyButton: UIButton!
    @IBOutlet weak var plusOneZlotyButton: UIButton!
    @IBOutlet weak var putInButton: UIButton!
    @IBOutlet weak var currentBalanceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let arrayOfViews = [currentBalanceView, mobilePhoneTextField, amountTextField, putInButton]
        
        for itemView in arrayOfViews {
            itemView?.layer.cornerRadius = 10
            itemView?.layer.shadowOffset = CGSize(width: 1, height: 2)
            itemView?.layer.shadowOpacity = 0.9
            itemView?.layer.shadowRadius = 1.5
        }
        
        currentBalanceLabel.text = OtherMethodsForBankOperations().getBalanceForShowing() + " zł"
        amountTextField.keyboardType = .decimalPad
        
        let newPickerView = UIPickerView()
        newPickerView.delegate = self
        
        mobilePhoneTextField.inputView = newPickerView
       
    }
    
    @IBAction func endEditing(_ sender: Any) {
        balanceToPutIn = Float(amountTextField.text!) ?? 0.0
        amountTextField.text = String(balanceToPutIn)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ActionsWithPhoneNumbers().getCountOfPhoneNumbers()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ActionsWithPhoneNumbers().getPhoneBySelection(currRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mobilePhoneTextField.text = ActionsWithPhoneNumbers().getPhoneBySelection(currRow: row)
    }
    
    @IBAction func minusOneZlotyButton(_ sender: Any) {
      
        if balanceToPutIn - 1 < 0 {
            balanceToPutIn = 0
        } else {
            balanceToPutIn -= 1
        }
        
        amountTextField.text = String(balanceToPutIn)
        
    }
    
    @IBAction func plusOneZlotyButton(_ sender: Any) {
        balanceToPutIn += 1
        amountTextField.text = String(balanceToPutIn)
    }
    
    
    @IBAction func putInButton(_ sender: Any) {
        
       if mobilePhoneTextField.text != nil
            && !mobilePhoneTextField.text!.isEmpty
            && balanceToPutIn != 0 {
           
           let curPhone = mobilePhoneTextField.text!
           
           if balanceToPutIn <= balanceRounded {
               
               let operation = ActionsWithBankOperations(currentAmount: balanceToPutIn, bankOperationType: .withdrawCashFromDeposit)
               
               if operation.withdrawCashFromDeposit(currentAmount: balanceToPutIn) {
               
                   operation.addOperationToTheHistory(bankOperationType: .topUpMobilePhoneBalance, phoneNumber: curPhone)
                   
                   let newBalanceDeposit = realm.objects(BalanceDeposit.self)
                   let newBalanceDepositLabel = newBalanceDeposit.first
                   let newBalanceDepositRounded = round(newBalanceDepositLabel!.balanceDeposit * 100) / 100
                   
                   let roundedAmount = round(balanceToPutIn * 100) / 100
                   
                   let textMessage = """
                   Put \(roundedAmount) zł into
                   mobile phone number
                   \(curPhone)
                   """
                   
                   prevData.0 = textMessage
                   prevData.1 = String(newBalanceDepositRounded) + " zł"
                   prevData.2 = true
                   
                   let _balanceForShowing = OtherMethodsForBankOperations().getBalanceForShowing()
                   
                   currentBalanceLabel.text = _balanceForShowing + " zł"
                   amountTextField.text = ""
                   
               }
               
           } else {
               Alerts.sharingClass.moneyLackAlert(mainController: self)
           }
           
       } else {
           Alerts.sharingClass.checkRequiredFieldsBeforePuttingMoney(mainController: self)
       }
        
    }
    
}
