//
//  ViewController.swift
//  My First App
//
//  Created by Sean Higgins on 6/1/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var items: [String] = []
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var text_field: UITextField!
    @IBOutlet weak var label: UILabel!
    // initialize timer
    //    var timer = Timer()
    
    
    // used to create table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // delete item from list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            items.remove(at: indexPath.row)
            table.reloadData()
            UserDefaults.standard.set(items, forKey: "items")
        }
    }
    

    @IBAction func ButtonPress(_ sender: Any) {
        if let name = text_field.text {
            label.text = name
        }
    }
    
    // method for event that occurs every second timer ticks
//    @objc func processTimer() {
//        print("a second has passed")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // create timer on load and start timer
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
        
//        // store information locally on device
//        UserDefaults.standard.set("Sean", forKey: "name")
//        // retrieve name from local storage
//        let name = UserDefaults.standard.object(forKey: "name")
//        print(name)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let new_items = UserDefaults.standard.object(forKey: "items")
        
        if let temp_items = new_items as? [String] {
            items = temp_items
        }
        
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button_1(_ sender: Any) {
        //timer.invalidate()
    }
    
    @IBAction func button_2(_ sender: Any) {
    }
    
    @IBAction func button_3(_ sender: Any) {
    }
    
    @IBAction func button_4(_ sender: Any) {
    }
    
    // whenever user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // shut down keyboard
        self.view.endEditing(true)
    }
    
    // whenever return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // shut down keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
}

