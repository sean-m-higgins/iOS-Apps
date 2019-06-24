//
//  ViewController.swift
//  My Weather App
//
//  Created by Sean Higgins on 6/19/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var zip_text_field: UITextField!
    
    @IBOutlet weak var output_forecast: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        /*
         *
         * Get weather from website below by scraping web page.
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
        
        */
        
        if zip_text_field.text != "" {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zip_text_field.text!),us&appid=6bac475cbd83e8a335974e8f5d60fa40")!
 
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                    if let url_content = data {
                        
                        do {
                            let json_result = try  JSONSerialization.jsonObject(with: url_content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            print(json_result)
                        
                            if let name = json_result["name"] as? String {
                                let description = ((json_result["weather"] as? NSArray)?[0] as? NSDictionary)?["description"]
                                
                                let humidity = ((json_result["main"] as? NSDictionary)?["humidity"])
                                
                                let max_temp = ((json_result["main"] as? NSDictionary)?["temp_max"])
                                var max_temp_f = max_temp as! Double
                                max_temp_f = ((max_temp_f - 273.15) * 9/5 + 32)
                                max_temp_f = max_temp_f.rounded()
                                
                                let min_temp = ((json_result["main"] as? NSDictionary)?["temp_min"])
                                var min_temp_f = min_temp as! Double
                                min_temp_f = ((min_temp_f - 273.15) * 9/5 + 32)
                                min_temp_f = min_temp_f.rounded()
                                
                                DispatchQueue.main.sync {
                                    self.output_forecast.text = "\(String(describing: name))'s weather today is \(String(describing: description!)), with a humidity of \(String(describing: humidity!)) and temperature between \(String(describing: min_temp_f)) and \(String(describing: max_temp_f))."
                                    
                                    self.output_forecast.alpha = 0.7
                                }
                            } else {
                                DispatchQueue.main.sync {
                                    self.output_forecast.text = "Couldn't find weather for that location, please try another zipcode (US only)."
                                }
                            }
                        } catch {
                            print("json error")
                        }
                    }
                }
            }
            task.resume()
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

