//
//  ExchangeController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class ExchangeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let data: [Exchange] = [Exchange(currency: "Euro", value: 1.3), Exchange(currency: "Pounds", value: 0.5)]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyToExchangeField: UITextField!
    @IBOutlet weak var exchangedMoneyField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exchangeCell = tableView.dequeueReusableCell(withIdentifier: "exchangeRateCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var content = exchangeCell.defaultContentConfiguration()
            content.secondaryText = "\(data[indexPath.row].value)"
            content.text = data[indexPath.row].currency
            exchangeCell.contentConfiguration = content
        } else {
            exchangeCell.textLabel?.text = data[indexPath.row].currency
            exchangeCell.detailTextLabel?.text = "\(data[indexPath.row].value)"
        }
        
        return exchangeCell
    }
    
    
}
