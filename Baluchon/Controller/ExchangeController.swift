//
//  ExchangeController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class ExchangeController: UIViewController {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyToExchangeField: UITextField!
    @IBOutlet weak var exchangedMoneyField: UITextField!
    @IBOutlet weak var languageToTranslateLabel: UILabel!
    @IBOutlet weak var startLanguageLabel: UILabel!
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIView()
        currencyPicker = UIPickerView()
        
        delegateSetup()
        dataSourceSetup()
        setupTextFields()
        exchangeRate.getRates()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateExchangeRate), name: Notification.BaluchonNotification.updateExchangeRate.notificationName, object: nil)
        
        addTapGestureRecogniser(to: languageToTranslateLabel, perform: #selector(displayPicker))
        addTapGestureRecogniser(to: startLanguageLabel, perform: #selector(displayPicker))
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
    private var currencyPicker: UIPickerView!
    private var containerView: UIView!
    private var selectedPicker: Int = 0
    
    // MARK: Methods
    /// Adding gesture recogniser to a view
    private func addTapGestureRecogniser(to view: UIView, perform selector: Selector) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }
    
    /// Setup a "Done" button on a toolbar above the keyboard
    private func setupTextFields() {
        // Add the toolbar to the keyboard
        moneyToExchangeField.inputAccessoryView = createDoneToolbar(with: #selector(dismissKeyboard))
        
        // Adding target on didchange event
        moneyToExchangeField.addTarget(self, action: #selector(moneyToExchangeDidChange), for: .editingChanged)
    }
    
    /// Configure the toolbar with done button for keuboard and pickers
    private func createDoneToolbar(with selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    /// Function called when the done button of the keyboard's toolbar is pressed
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Get the result of the exchange
    @objc private func moneyToExchangeDidChange() {
        if let moneyToExchange = moneyToExchangeField.text?.replacingOccurrences(of: ",", with: "."),
           let moneyToExchange = Double(moneyToExchange) {
            exchangedMoneyField.text = exchangeRate.convertValue(moneyToExchange)
        } else {
            exchangedMoneyField.text = ""
        }
    }
    
    @objc private func displayPicker(sender: UITapGestureRecognizer) {
        if let selectedPickerTag = sender.view?.tag {
            selectedPicker = selectedPickerTag
        }
        
        let pickerViewHeight = self.view.bounds.height / 3
        configurePicker(height: pickerViewHeight)
        dismissKeyboard()
        
        // Animation
        UIView.animate(withDuration: 0.2) {
            self.containerView.frame.origin.y = (self.view.frame.height - pickerViewHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0)/2)
        }
    }
    
    /// Configure picker
    private func configurePicker(height: Double) {
        currencyPicker.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        currencyPicker.backgroundColor = .init(named: "defaultBackground")
        configurePickerContainer(heigh: height)
    }
    
    /// Configure the picker container
    private func configurePickerContainer(heigh: Double) {
        // Set up the picker container
        containerView.frame = CGRect(x: 0, y: self.view.bounds.height, width: view.bounds.width, height: heigh)
        
        containerView.addSubview(currencyPicker)
        containerView.addSubview(configurePickerToolbar())
        view.addSubview(containerView)
    }
    
    /// Configure the toolbar with the "done" button for the picker
    private func configurePickerToolbar() -> UIToolbar {
        let doneToolbar = createDoneToolbar(with: #selector(dismissPicker))
        doneToolbar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 45)
        return doneToolbar
    }
    
    /// Dismiss the picker
    @objc private func dismissPicker() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.frame.origin.y = self.view.frame.height
        }
    }
}

// MARK: Delegate extension
extension ExchangeController: UIPickerViewDelegate, UITableViewDelegate {
    /// Setup delegates for this controller
    private func delegateSetup() {
        tableView.delegate = self
        currencyPicker.delegate = self
    }
    
    /// Called when an item is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedPicker {
        case 1:
            exchangeRate.startLanguage = exchangeRate.rates[row].currency
            moneyToExchangeDidChange()
            startLanguageLabel.text = "▼ \(exchangeRate.rates[row].symbol) (\(exchangeRate.rates[row].currency))"
        case 2:
            exchangeRate.exchangedCurrency = exchangeRate.rates[row].currency
            moneyToExchangeDidChange()
            languageToTranslateLabel.text = "\(exchangeRate.rates[row].symbol) (\(exchangeRate.rates[row].currency)) ▼"
        default:
            break
        }
    }
}

// MARK: Data Source extension
extension ExchangeController: UIPickerViewDataSource, UITableViewDataSource {
    /// Setup the source of data for views
    private func dataSourceSetup() {
        tableView.dataSource = self
//        currencyPicker.dataSource = self
    }
    
    /// Return the number of column the picker will have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Return a cell of the picker. Called once per item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(exchangeRate.rates[row].symbol) (\(exchangeRate.rates[row].currency))"
    }
    
    /// Return the number of items in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exchangeRate.rates.count
    }
}
