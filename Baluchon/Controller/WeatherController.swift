//
//  WeatherController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class WeatherController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let data: [Weather] = [Weather(city: "Saint-Remy-en-Bouzemont-Saint-Genest-et-Isson ", weatherCondition: "sunny", temperature: "10.0", minTemperature: "3", maxTemperature: "15", sunrise: "6:10", sunset: "20:54"), Weather(city: "Paris", weatherCondition: "rain", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "snow", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "bolt", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "cloudSunAndRain", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00"), Weather(city: "Paris", weatherCondition: "cloudAndSun", temperature: "15", minTemperature: "5", maxTemperature: "20", sunrise: "6:00", sunset: "21:00")]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? CollectionViewCell {
            weatherCell.configure(with: data[indexPath.row])
            cell = weatherCell
        }
        return cell
    }
}
