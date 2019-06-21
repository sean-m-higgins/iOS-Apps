//
//  ViewController.swift
//  My Weather App
//
//  Created by Sean Higgins on 6/19/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var city_text_field: UITextField!
    
    @IBOutlet weak var output_forecast: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + city_text_field.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if let error = error {
                    print(error)
                } else {
                    if let unwrapped_data = data {
                        let data_string = NSString(data: unwrapped_data, encoding: String.Encoding.utf8.rawValue)
                        
                        var string_seperator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        
                        if let content_array = data_string?.components(separatedBy: string_seperator) {
                            
                            if content_array.count > 1 {
                                string_seperator = "</span>"
                                
                                let new_content_array = content_array[1].components(separatedBy: string_seperator)
                                
                                if new_content_array.count > 0 {
                                    message = new_content_array[0].replacingOccurrences(of: "&deg;", with: "°")
                                }
                            }
                        }
                    }
                }
                if message == "" {
                    message = "The weather could not be found for the city entered. Please try a new city."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.output_forecast.text = message
                })
            }
            task.resume()
        } else {
            output_forecast.text = "The city entered does not match any listed."
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

