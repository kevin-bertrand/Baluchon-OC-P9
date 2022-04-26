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
        exchangeRate.getRates()
        NotificationCenter.default.addObserver(self, selector: #selector(updateExchangeRate), name: Notification.BaluchonNotification.updateExchangeRate.notificationName, object: nil)
    }
    
    // MARK: Methods
    @objc func updateExchangeRate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Return the number of cell the table view will have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeRate.rates.count
    }
    
    /// Return a configurated cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell to reuse
        let exchangeCell = tableView.dequeueReusableCell(withIdentifier: "exchangeRateCell", for: indexPath)
        
        // Check if the iOS version is/is older than iOS 14
        if #available(iOS 14.0, *) {
            // Configure the content of the cell
            var content = exchangeCell.defaultContentConfiguration()
            content.text = exchangeRate.rates[indexPath.row].symbol
            content.secondaryText = "\(exchangeRate.rates[indexPath.row].value) \(exchangeRate.rates[indexPath.row].currency)"
            
            // Set the configuration to the cell
            exchangeCell.contentConfiguration = content
        } else {
            // Configure the cell
            exchangeCell.textLabel?.text = exchangeRate.rates[indexPath.row].symbol
            exchangeCell.detailTextLabel?.text = "\(exchangeRate.rates[indexPath.row].value) \(exchangeRate.rates[indexPath.row].currency)"
        }
        
        return exchangeCell
    }
    
    // MARK: Private
    // MARK: Properties
    private let exchangeRate = ExchangeRates()
    
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
