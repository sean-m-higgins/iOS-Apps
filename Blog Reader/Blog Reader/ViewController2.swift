//
//  ViewController2.swift
//  Blog Reader
//
//  Created by Sean Higgins on 6/23/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let document_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if document_path.count > 0 {
            
            let document_directory = document_path[0]
            
            let restore_path = document_directory + "/bach.jpeg"
            
            image_view.image = UIImage(contentsOfFile: restore_path)
            
        }
        
        
        
        
        /*
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Johann_Sebastian_Bach.jpg/440px-Johann_Sebastian_Bach.jpg")!
        
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            
            if error != nil {
                print(error!)
            } else {
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.image_view.image = image
                        
                        // how to save user documents
                        let document_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        
                        if document_path.count > 0 {
                            
                            let document_directory = document_path[0]
                                
                            let save_path = document_directory + "/bach.jpeg"
                            
                            do {
                            try image.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: save_path))
                            } catch {
                                print("error")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
 */
        
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
