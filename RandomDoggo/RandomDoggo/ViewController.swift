//
//  ViewController.swift
//  RandomDoggo
//
//  Created by Andrew Tsukuda on 10/24/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dogImageView: UIImageView!
    private var image: UIImage? = nil
    private var imageURL: URL?
    typealias JSON = [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session = URLSession(configuration: .default)
        var myRequest = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random")!)
        
        myRequest.httpMethod = "GET"
        
        let getURLTask = session.dataTask(with: myRequest) {(data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                guard let jsonNew = json as! JSON? else {return}
                self.imageURL = URL(string: (jsonNew["message"] as! String))
            }
        }
        getURLTask.resume()
        
        
    }
    @IBAction func showDoggo(_ sender: Any) {
        let session = URLSession(configuration: .default)
        if let url = self.imageURL {
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            self.image = UIImage(data: imageData)
                            // Do something with your image.
                            print(self.image.debugDescription)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
            if let image = self.image {
                self.dogImageView.image = image
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

