//
//  WeatherController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation
import CoreLocation
import UIKit

class WeatherController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, CLLocationManagerDelegate {
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
        _locationManager.delegate = self
        
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest
        
        NotificationCenter.default.addObserver(self, selector: #selector(_processNotification), name: Notification.BaluchonNotification.updateWeather.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_processNotification), name: Notification.BaluchonNotification.cityDoesntExist.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_processNotification), name: Notification.BaluchonNotification.cityAlreadyAdded.notificationName, object: nil)
    }
    
    // MARK: Methods
    /// Return the number of cell the collection view will have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _weather.weathers.count
    }
    
    /// Return a configurated cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        // Get a reusable cell with a specific identifier and with the "CollectionViewCell" class
        if let weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? CollectionViewCell {
            weatherCell.configure(with: _weather.weathers[indexPath.row])
            cell = weatherCell
        }
        
        return cell
    }
    
    /// Function called when the return button of the keyboard is touched
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCityField.resignFirstResponder()
        return true
    }
    
    /// Called when the user location changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            _weather.getTemperatureFromCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
    
    /// Called when an error occurs during getting user location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _showAlertViewFor(notification: .errorDuringDownloadingWeather)
    }
    
    // MARK: Actions
    @IBAction func addCityButtonTouched() {
        if var newCity = newCityField.text {
            newCity = newCity.replacingOccurrences(of: " ", with: "-")
            newCity = newCity.folding(options: .diacriticInsensitive, locale: nil)
            _weather.getTemperatureOf(city: newCity)
            newCityField.text = ""
            newCityField.resignFirstResponder()
        }
    }
    
    @IBAction func getCurrentLocationWeatherButtonTouched() {
        _locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            _locationManager.requestLocation()
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _weather = WeatherManager()
    private let _locationManager = CLLocationManager()
    
    // MARK: Methods
    /// Process notificaitons
    @objc private func _processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            DispatchQueue.main.async {
                switch notificationName {
                case Notification.BaluchonNotification.cityAlreadyAdded.notificationName:
                    self._showAlertViewFor(notification: .cityAlreadyAdded)
                case Notification.BaluchonNotification.cityDoesntExist.notificationName:
                    self._showAlertViewFor(notification: .cityDoesntExist)
                case Notification.BaluchonNotification.updateWeather.notificationName:
                        self.collectionView.reloadData()
                default:
                    return
                }
            }
        }
    }
    
    /// Show alert view
    private func _showAlertViewFor(notification: Notification.BaluchonNotification) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: notification.notificationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
