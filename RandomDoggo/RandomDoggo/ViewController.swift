//
//  ViewController.swift
//  RandomDoggo
//
//  Created by Andrew Tsukuda on 10/24/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    typealias JSON = [String: Any]
    typealias voidCallback = () -> ()
    
    @IBOutlet weak var dogImageView: UIImageView!

    private var image: UIImage? = nil
    private var imageURL: URL?
    private var getImageCallback: voidCallback?
    private var clickCallback: voidCallback?
    private var allowClick: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getImageCallback = downloadImage
        self.clickCallback = canClick
    }
    
    func canClick() {
        self.allowClick = true
    }
    
    func downloadImage() {
        let session = URLSession(configuration: .default)
        if let url = self.imageURL {
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    // Check for response
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            self.image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                if let image = self.image {
                                    self.dogImageView.image = image
                                }
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
        }
    }
    
    @IBAction func showDoggo(_ sender: Any) {
        if self.allowClick {
            self.allowClick = false
            let session = URLSession(configuration: .default)
            var myRequest = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random")!)
            
            myRequest.httpMethod = "GET"
            
            let getURLTask = session.dataTask(with: myRequest) {(data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let jsonNew = json as! JSON? else {return}
                    self.imageURL = URL(string: (jsonNew["message"] as! String))
                    self.getImageCallback?()
                }
            }
            
            getURLTask.resume()
            downloadImage()
            clickCallback?()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


