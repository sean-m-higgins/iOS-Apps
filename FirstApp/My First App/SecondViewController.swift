//
//  SecondViewController.swift
//  My First App
//
//  Created by Sean Higgins on 6/3/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://seanmh.com")!
        webview.load(URLRequest(url: url))
        // if website is in app
        //webview.loadHTMLString(<#T##string: String##String#>, baseURL: <#T##URL?#>)
        
        // download website and data
        let second_url = URL(string: "https://seanmh.com")
        let request = NSMutableURLRequest(url: second_url!)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let error = error {
                print(error)
            } else {
                if let unwrapped_data = data {
                    let data_str = NSString(data: unwrapped_data, encoding: String.Encoding.utf8.rawValue)
                    print(data_str!)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func new_button(_ sender: Any) {
        
    }
    
    @IBOutlet weak var text_field: UITextField!

    @IBOutlet weak var webview: WKWebView!
    
    @IBAction func add(_ sender: Any) {
        let new_item = UserDefaults.standard.object(forKey: "items")
        
        var items: [String]
        
        if let temp_items = new_item as? [String] {
            items = temp_items
            items.append(text_field.text!)
        } else {
            items = [text_field.text!]
        }
        
        UserDefaults.standard.set(items, forKey: "items")
        
        text_field.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
