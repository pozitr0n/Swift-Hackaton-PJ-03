//
//  ViewController.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 25/01/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // creating outleets
    @IBOutlet weak var updateDepositBalance: UIButton!
    @IBOutlet weak var totalDepositBalanceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var depositBalanceView: UIView!
    @IBOutlet weak var currentOperationLabel: UILabel!
    @IBOutlet weak var currentOperationView: UIView!
    @IBOutlet weak var historyOfOperationsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyOfOperationsView: UIView!
    @IBOutlet weak var withdrawCash: UIButton!
    @IBOutlet weak var putMoneyIntoMobile: UIButton!
    @IBOutlet weak var showContacts: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var putIntoDeposit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        let arrayOfViews = [depositBalanceView, currentOperationView, buttonsView]
        
        for itemView in arrayOfViews {
            itemView?.layer.cornerRadius = 10
            itemView?.layer.shadowOffset = CGSize(width: 1, height: 2)
            itemView?.layer.shadowOpacity = 0.9
            itemView?.layer.shadowRadius = 1.5
        }
        
        currentOperationLabel.numberOfLines = 3
        
        let _balance = OtherMethodsForBankOperations().getBalanceForShowing()
        balanceLabel.text = _balance + " zł"
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if !prevData.0.isEmpty {
            currentOperationLabel.text = prevData.0
            prevData.0 = ""
        }
        
        if !prevData.1.isEmpty {
            balanceLabel.text = prevData.1
            prevData.1 = ""
        } else {
            let _balance = OtherMethodsForBankOperations().getBalanceForShowing()
            balanceLabel.text = _balance + " zł"
        }
        
        if prevData.2 {
            tableView.reloadData()
        }
        
    }
    
    @IBAction func updateDepositBalance(_ sender: Any) {
        let _balance = OtherMethodsForBankOperations().getBalanceForShowing()
        balanceLabel.text = _balance + " zł"
    }
    
    @IBAction func openContacts(_ sender: Any) {
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsViewController") as? ContactsViewController else { return }
        
        guard let navigator = navigationController else { return }
        
        navigator.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func putMoneyIntoMobile(_ sender: Any) {
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoneyIntoMobileViewController") as? MoneyIntoMobileViewController else { return }
        
        guard let navigator = navigationController else { return }
        
        navigator.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyOfOperations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let historyCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        
        let operationDataValue = historyOfOperations[indexPath.row].operationData
        let operationTypeValue = historyOfOperations[indexPath.row].operationType
        let amountValue = historyOfOperations[indexPath.row].amount
        
        historyCell.insertInfoAboutOperation(operationDataValue: operationDataValue,
                                             operationTypeValue: operationTypeValue,
                                             amountValue: amountValue)
        
        return historyCell
        
    }
    
    @IBAction func topUpDeposit(_ sender: Any) {
        Alerts.sharingClass.topUpDeposit(mainController: self)
    }
    
    @IBAction func withdrawCashFromDeposit(_ sender: Any) {
        Alerts.sharingClass.withdrawCashFromDeposit(mainController: self)
    }
        
}

