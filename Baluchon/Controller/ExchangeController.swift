//
//  ExchangeController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class ExchangeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyToExchangeField: UITextField!
    @IBOutlet weak var exchangedMoneyField: UITextField!
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTextFields()
    }
    
    // MARK: Methods
    /// Return the number of cell the table view will have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    /// Return a configurated cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell to reuse
        let exchangeCell = tableView.dequeueReusableCell(withIdentifier: "exchangeRateCell", for: indexPath)
        
        // Check if the iOS version is/is older than iOS 14
        if #available(iOS 14.0, *) {
            // Configure the content of the cell
            var content = exchangeCell.defaultContentConfiguration()
            content.text = data[indexPath.row].currency
            content.secondaryText = "\(data[indexPath.row].value)"
            
            // Set the configuration to the cell
            exchangeCell.contentConfiguration = content
        } else {
            // Configure the cell
            exchangeCell.textLabel?.text = data[indexPath.row].currency
            exchangeCell.detailTextLabel?.text = "\(data[indexPath.row].value)"
        }
        
        return exchangeCell
    }
    
    // MARK: Private
    // MARK: Properties
    private let data: [Exchange] = [Exchange(currency: "Euro", value: 1.3), Exchange(currency: "Pounds", value: 0.5)]
    
    // MARK: Methods
    /// Setup a "Done" button on a toolbar above the keyboard
    private func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Space before the button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        // Add the toolbar to the keyboard
        moneyToExchangeField.inputAccessoryView = toolbar
    }
    
    /// Function called when the done button of the keyboard's toolbar is pressed
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
}
