//
//  ViewController.swift
//  Blog Reader
//
//  Created by Sean Higgins on 6/21/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var username_textbox: UITextField!
    @IBOutlet weak var password_textbox: UITextField!
    @IBOutlet weak var confirm_password_textbox: UITextField!
    @IBOutlet weak var welcome_label: UILabel!
    @IBOutlet weak var continue_label: UIButton!
    @IBOutlet weak var login_label: UIButton!
    @IBOutlet weak var change_username_label: UIButton!
    
    var current_username = ""
    var login_status = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        login_label.alpha = 0
        change_username_label.alpha = 0
        
        let app_delegate = UIApplication.shared.delegate as! AppDelegate
        let context = app_delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let username = result.value(forKey: "username") as? String {
                        
                        current_username = username
                        confirm_password_textbox.alpha = 0
                        continue_label.alpha = 0
                        login_label.alpha = 1
                        change_username_label.alpha = 1
                        login_status = true
                        welcome_label.text = "Welcome Back \(username)!"
                    }
                }
            }
        } catch {
            print("couldn't fetch results")
        }
    }

    @IBAction func continue_button(_ sender: Any) {
        if username_textbox.text != "" && password_textbox.text != "" && confirm_password_textbox.text != "" {
            
            if password_textbox.text == confirm_password_textbox.text {

                let app_delegate = UIApplication.shared.delegate as! AppDelegate
                let context = app_delegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                request.predicate = NSPredicate(format: "username = %@", username_textbox.text!)
                request.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(request)
                    // check if username already exists
                    for result in results as! [NSManagedObject] {
                        if let username = result.value(forKey: "username") as? String {
                            username_textbox.text = "\(username) already taken"
                            break
                        }
                    }
                    let new_user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                    
                    new_user.setValue(username_textbox.text, forKey: "username")
                    new_user.setValue(password_textbox.text, forKey: "password")
                    
                    confirm_password_textbox.alpha = 0
                    continue_label.alpha = 0
                    login_label.alpha = 1
                    change_username_label.alpha = 1
                    login_status = true
                    welcome_label.text = "Welcome \(username_textbox.text!)! Please Login"
                    username_textbox.text = ""
                    password_textbox.text = ""
                    
                    do {
                        try context.save()
                    } catch {
                        print("There as an error")
                    }
                } catch {
                    print("error")
                }
            } else {
                password_textbox.text = "Passwords do not match"
                confirm_password_textbox.text = ""
            }
        }
    }
    
    @IBAction func login_button(_ sender: Any) {
        if username_textbox.text != nil && password_textbox.text != nil {
            // check if password equals username listed
            let app_delegate = UIApplication.shared.delegate as! AppDelegate
            let context = app_delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

            request.predicate = NSPredicate(format: "username = %@", username_textbox.text!)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                if results.count == 1 {
                    for result in results as! [NSManagedObject] {
                        if let password = result.value(forKey: "password") as? String {
                            if password == password_textbox.text {
                                self.welcome_label.text = "Great! You successfully Logged in"
                                
                                self.performSegue(withIdentifier: "segue_to_image", sender: self)
                            } else {
                                self.welcome_label.text = "Sorry, incorrect password."
                            }
                        }
                    }
                } else {
                    self.welcome_label.text = "Sorry, incorrect username."
                }
            } catch {
                print("error")
            }
        }
    }
    
    @IBAction func change_username_button(_ sender: Any) {
        if username_textbox.text != ""  && login_status == true {
            // check if valid username
            let app_delegate = UIApplication.shared.delegate as! AppDelegate
            let context = app_delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            request.predicate = NSPredicate(format: "username = %@", username_textbox.text!)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                // check if username already exists
                for result in results as! [NSManagedObject] {
                    if let username = result.value(forKey: "username") as? String {
                        username_textbox.text = "\(username) already taken"
                        break
                    }
                }
                
                let new_request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                
                do {
                    let new_results = try context.fetch(new_request)
                    for result in new_results as! [NSManagedObject] {
                        result.setValue(username_textbox.text, forKey: "username")
                        current_username = username_textbox.text!
                        welcome_label.text = "Ah nice change, \(current_username)!"
                    }
                } catch {
                    print("error")
                }
                
                do {
                    try context.save()
                } catch {
                    print("There as an error")
                }
            } catch {
                print("error")
            }
        }
    }
    
}

