    //
//  ChangeWeatherVC.swift
//  weatherapp
//
//  Created by Admin on 20/08/2018.
//  Copyright © 2018 abdulahad. All rights reserved.
//

import UIKit
    protocol ChangeCityDelegate{
        func userEnteredANewCityName(city:String)
    }

class ChangeWeatherVC: UIViewController {

    var delegate : ChangeCityDelegate?

    @IBOutlet weak var changeCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        let cityName=changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
}
