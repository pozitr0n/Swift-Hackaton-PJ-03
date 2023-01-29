//
//  ContactsViewController.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 27/01/2023.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
    }
    
    @IBAction func addNewContact(_ sender: Any) {
        
        let alert = UIAlertController(title: "New mobile phone", message: "Add a new phone into contacts...", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Write mobile phone here..."
            textField.keyboardType = .decimalPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            
            if textField?.text != nil
                && !textField!.text!.isEmpty
                && textField!.text!.isNumber {
            
                ActionsWithPhoneNumbers().addNewPhoneNumber(textNumber: textField!.text!)
                self.contactsTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            
            } else {
                return
            }
        
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionsWithPhoneNumbers().getCountOfPhoneNumbers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currCell = contactsTableView.dequeueReusableCell(withIdentifier: "MobilePhoneCell") as? MobilePhoneCell
        else {
            return UITableViewCell()
        }
                
        currCell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let currPhone = ActionsWithPhoneNumbers().getPhoneBySelection(currRow: indexPath.row)
        currCell.insertPhoneIntoCell(phone: currPhone)
        
        return currCell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            
            if ActionsWithPhoneNumbers().deletePhoneFromDatabase(index: indexPath.row) {
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                tableView.reloadData()
            }
    
       }
        
    }
    
}

extension String {
    
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
    
}
