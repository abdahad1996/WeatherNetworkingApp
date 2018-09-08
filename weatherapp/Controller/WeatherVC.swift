//
//  ViewController.swift
//  weatherapp
//
//  Created by Admin on 20/08/2018.
//  Copyright © 2018 abdulahad. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController,CLLocationManagerDelegate,ChangeCityDelegate{
    
    let locationManager=CLLocationManager()
    let weatherDataModel=WeatherDataModel()

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!

    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a423f95b6ff89daf61efaf3a17f46c41"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String,parameters:[String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Succes! got the weather data")
                let weatherJSON :JSON = JSON(response.result.value!)
            self.updateWeatherData(json:weatherJSON)
                print(weatherJSON)
                
            }
            else{
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json:JSON){
        if let tempResult = json["main"]["temp"].double {
        weatherDataModel.temperature = Int(tempResult-273.15)
            
        weatherDataModel.city=json["name"].stringValue
        weatherDataModel.condition = json["weather"]["0"]["id"].intValue
        weatherDataModel.weatherIconName=weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
    }
        else {
            cityLabel.text="Weather Unavailable"
        }
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text="\(weatherDataModel.temperature)°"
        weatherIcon.image=UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //location gets updated and the last location is the most accurate
        let location = locations[locations.count-1]
        //when we get valid result stop updating as it destroys battery
        if location.horizontalAccuracy>0{
            locationManager.startUpdatingLocation()
            locationManager.delegate=nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude=String(location.coordinate.latitude)
            let longitude=String(location.coordinate.longitude)
            let params : [String:String]=["lat":latitude,"lon":longitude,"appid":APP_ID]
            getWeatherData(url:WEATHER_URL,parameters:params)
        }
    }
    
    //Write the didUpdateLocations method here:
    
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text="location Unavailable"
    }
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        let params : [String:String] = ["q":city,"appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the PrepareForSegue Method here
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC=segue.destination as! ChangeWeatherVC
            destinationVC.delegate=self
        }
    }
    
    
    


}

