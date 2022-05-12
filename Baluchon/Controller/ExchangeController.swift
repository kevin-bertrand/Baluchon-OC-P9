//
//  ExchangeController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit
import Foundation

class ExchangeController: UIViewController {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyToExchangeField: UITextField!
    @IBOutlet weak var exchangedMoneyField: UITextField!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var startCurrencyLabel: UILabel!
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        _containerView = UIView()
        _currencyPicker = UIPickerView()
        
        _delegateSetup()
        _dataSourceSetup()
        _setupTextFields()
        _exchangeRate.getRates()
        
        NotificationCenter.default.addObserver(self, selector: #selector(_updateExchangeRate), name: Notification.BaluchonNotification.updateExchangeRate.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_showAlertView), name: Notification.BaluchonNotification.errorDuringDownloadRates.notificationName, object: nil)
        
        _addTapGestureRecogniser(to: targetCurrencyLabel, perform: #selector(_displayPicker))
        _addTapGestureRecogniser(to: startCurrencyLabel, perform: #selector(_displayPicker))
    }
    
    // MARK: Methods
    /// Return the number of cell the table view will have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _exchangeRate.rates.count
    }
    
    /// Return a configurated cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell to reuse
        let exchangeCell = tableView.dequeueReusableCell(withIdentifier: "exchangeRateCell", for: indexPath)
        
        // Check if the iOS version is/is older than iOS 14
        if #available(iOS 14.0, *) {
            // Configure the content of the cell
            var content = exchangeCell.defaultContentConfiguration()
            content.text = _exchangeRate.rates[indexPath.row].symbol
            content.secondaryText = "\(_exchangeRate.rates[indexPath.row].value) \(_exchangeRate.rates[indexPath.row].currency)"
            
            // Set the configuration to the cell
            exchangeCell.contentConfiguration = content
        } else {
            // Configure the cell
            exchangeCell.textLabel?.text = _exchangeRate.rates[indexPath.row].symbol
            exchangeCell.detailTextLabel?.text = "\(_exchangeRate.rates[indexPath.row].value) \(_exchangeRate.rates[indexPath.row].currency)"
        }
        
        return exchangeCell
    }
    
    // MARK: Private
    // MARK: Properties
    private let _exchangeRate = ExchangeManager()
    private var _currencyPicker: UIPickerView!
    private var _containerView: UIView!
    private var _selectedPicker: Int = 0
    
    // MARK: Methods
    /// Adding gesture recogniser to a view
    private func _addTapGestureRecogniser(to view: UIView, perform selector: Selector) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }
    
    /// Setup a "Done" button on a toolbar above the keyboard
    private func _setupTextFields() {
        // Add the toolbar to the keyboard
        moneyToExchangeField.inputAccessoryView = _createDoneToolbar(with: #selector(_dismissKeyboard))
        
        // Adding target on didchange event
        moneyToExchangeField.addTarget(self, action: #selector(_moneyToExchangeDidChange), for: .editingChanged)
    }
    
    /// Configure the toolbar with done button for keyboard and pickers
    private func _createDoneToolbar(with selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    /// Configure picker
    private func _configurePicker(height: Double) {
        _currencyPicker.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        _currencyPicker.backgroundColor = .init(named: "defaultBackground")
        _configurePickerContainer(heigh: height)
    }
    
    /// Configure the picker container
    private func _configurePickerContainer(heigh: Double) {
        // Set up the picker container
        _containerView.frame = CGRect(x: 0, y: self.view.bounds.height, width: view.bounds.width, height: heigh)
        
        _containerView.addSubview(_currencyPicker)
        _containerView.addSubview(_configurePickerToolbar())
        view.addSubview(_containerView)
    }
    
    /// Configure the toolbar with the "done" button for the picker
    private func _configurePickerToolbar() -> UIToolbar {
        let doneToolbar = _createDoneToolbar(with: #selector(_dismissPicker))
        doneToolbar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 45)
        return doneToolbar
    }
    
    /// Dismiss the picker
    @objc private func _dismissPicker() {
        UIView.animate(withDuration: 0.2) {
            self._containerView.frame.origin.y = self.view.frame.height
        }
    }
    
    /// Update rates when receive notification
    @objc private func _updateExchangeRate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Function called when the done button of the keyboard's toolbar is pressed
    @objc private func _dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Get the result of the exchange
    @objc private func _moneyToExchangeDidChange() {
        if let moneyToExchange = moneyToExchangeField.text?.replacingOccurrences(of: ",", with: "."),
           let moneyToExchange = Double(moneyToExchange) {
            exchangedMoneyField.text = _exchangeRate.convertValue(moneyToExchange)
        } else {
            exchangedMoneyField.text = ""
        }
    }
    
    /// Display a UIPickerView
    @objc private func _displayPicker(sender: UITapGestureRecognizer) {
        if let selectedPickerTag = sender.view?.tag {
            _selectedPicker = selectedPickerTag
        }
        
        let pickerViewHeight = self.view.bounds.height / 3
        _configurePicker(height: pickerViewHeight)
        _dismissKeyboard()
        
        // Animation
        UIView.animate(withDuration: 0.2) {
            self._containerView.frame.origin.y = (self.view.frame.height - pickerViewHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0)/2)
        }
    }
    
    /// Getting alert and show an UIAlert
    @objc private func _showAlertView() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: Notification.BaluchonNotification.errorDuringDownloadRates.notificationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: Delegate extension
extension ExchangeController: UIPickerViewDelegate, UITableViewDelegate {
    // MARK: Public method
    /// Called when an item is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch _selectedPicker {
        case 1:
            _exchangeRate.startLanguage = _exchangeRate.rates[row].currency
            _moneyToExchangeDidChange()
            startCurrencyLabel.text = "▼ \(_exchangeRate.rates[row].symbol) (\(_exchangeRate.rates[row].currency))"
        case 2:
            _exchangeRate.exchangedCurrency = _exchangeRate.rates[row].currency
            _moneyToExchangeDidChange()
            targetCurrencyLabel.text = "\(_exchangeRate.rates[row].symbol) (\(_exchangeRate.rates[row].currency)) ▼"
        default:
            break
        }
    }
    
    // MARK: Private method
    /// Setup delegates for this controller
    private func _delegateSetup() {
        tableView.delegate = self
        _currencyPicker.delegate = self
    }
}

// MARK: Data Source extension
extension ExchangeController: UIPickerViewDataSource, UITableViewDataSource {
    // MARK: Public methods
    /// Return the number of column the picker will have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Return a cell of the picker. Called once per item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(_exchangeRate.rates[row].symbol) (\(_exchangeRate.rates[row].currency))"
    }
    
    /// Return the number of items in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _exchangeRate.rates.count
    }
    
    // MARK: Private method
    /// Setup the source of data for views
    private func _dataSourceSetup() {
        tableView.dataSource = self
    }
}
