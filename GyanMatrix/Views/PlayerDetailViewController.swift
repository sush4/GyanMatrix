//
//  PlayerDetailViewController.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    public var player : Player!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Player Detail"
        
        name.text = player.name
        countryLabel.text = player.country
        runLabel.text = "\(self.forTailingZero(temp: player.totalScore)) runs"
        matchLabel.text = "\(self.forTailingZero(temp: player.matchesPlayed)) matches"
        descLabel.text = player.descriptions
        
        if player.favorite {
            favLabel.text = "My favourite"
            self.favoriteImage.image = UIImage(named:"fillStar")
        } else {
            favLabel.text = "Not favourite"
            self.favoriteImage.image = UIImage(named:"star")
        }
        
        backButton.titleLabel?.text = "Back"
        backButton.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        backButton.layer.cornerRadius = 5.0
        backButton.layer.borderWidth = 2
        
        playerImage.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        playerImage.layer.cornerRadius = 5.0
        playerImage.layer.borderWidth = 2
        
        if let checkedUrl = URL(string: player.image) {
            playerImage.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func forTailingZero(temp: Double) -> String{
        let tempVar = String(format: "%g", temp)
        return tempVar
    }

    func downloadImage(url: URL) {
//        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.playerImage.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
