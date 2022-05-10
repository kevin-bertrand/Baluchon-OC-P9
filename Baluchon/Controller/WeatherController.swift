//
//  WeatherController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation
import UIKit

class WeatherController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCityField: UITextField!
    
    // MARK: Initialisation fucntion
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        newCityField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeather), name: Notification.BaluchonNotification.updateWeather.notificationName, object: nil)
    }
    
    // MARK: Methods
    /// Return the number of cell the collection view will have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather.weathers.count
    }
    
    /// Return a configurated cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        // Get a reusable cell with a specific identifier and with the "CollectionViewCell" class
        if let weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? CollectionViewCell {
            weatherCell.configure(with: weather.weathers[indexPath.row])
            cell = weatherCell
        }
        
        return cell
    }
    
    /// Function called when the return button of the keyboard is touched
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCityField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    @IBAction func addCityButtonTouched() {
        if var newCity = newCityField.text {
            newCity = newCity.replacingOccurrences(of: " ", with: "-")
            newCity = newCity.folding(options: .diacriticInsensitive, locale: nil)
            print(newCity)
            weather.getTemperatureOf(city: newCity)
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let weather = WeatherManager()
    
    @objc private func updateWeather() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
