//
//  WeatherController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

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
    }
    
    // MARK: Methods
    /// Return the number of cell the collection view will have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    /// Return a configurated cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        // Get a reusable cell with a specific identifier and with the "CollectionViewCell" class
        if let weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? CollectionViewCell {
            weatherCell.configure(with: data[indexPath.row])
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
    }
    
    // MARK: Private
    // MARK: Properties
    private let data: [Weather] = [Weather(city: "Saint-Remy-en-Bouzemont-Saint-Genest-et-Isson ", weatherCondition: "sunny", temperature: "10.0", minTemperature: "3", maxTemperature: "15", sunrise: "6:10", sunset: "20:54"), Weather(city: "Paris", weatherCondition: "rain", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "snow", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "bolt", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "cloudSunAndRain", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "cloudAndSun", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00")]
}
