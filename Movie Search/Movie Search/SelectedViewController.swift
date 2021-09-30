//
//  SelectedViewController.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/17/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//

import UIKit

class SelectedViewController: UIViewController {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var TMDBIcon: UIImageView!
    
    @IBOutlet weak var backdropPath: UIImageView!
    
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var addFavoritesButton: UIButton!
    
    var VCtitle: String!
    var VCimage: UIImage!
    var VCreleased: String!
    var VCoverview: String!
    var VCrating: String!
    var VCimageUrl: String!
    var backDropUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHigherResolution()
        getBackDrop()
        movieTitle.text = VCtitle
        released.text = VCreleased
        overview.text = VCoverview
        rating.text = VCrating
        print(arrayHasAdded)
        TMDBIcon.image = UIImage(named:"TMDb_icon")
        
        trailerButton.layer.cornerRadius = 15
        addFavoritesButton.layer.cornerRadius = 15
        
//        print(backDropUrl)
        
        
        // Do any additional setup after loading the view.
    }
    
    func getHigherResolution(){
        let url1 = "https://image.tmdb.org/t/p/w500/"
        if VCimageUrl == "no_available_image"{
            let noImage: UIImage = UIImage(named: "no_image")!
            poster.image = noImage
        }else{
            let finalUrl:String = url1 + VCimageUrl
            let url = URL(string: finalUrl)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            poster.image = image
        }
    }
    
    func getBackDrop(){
        let url1 = "https://image.tmdb.org/t/p/w500/"
        if backDropUrl != "no_available_image"{
            let finalUrl:String = url1 + backDropUrl
            let url = URL(string: finalUrl)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            backdropPath.image = image
        }
    }
    
    //여기 보고있었음
    var arrayHasAdded: Bool {
        get {
            return UserDefaults.standard.object(forKey: "favoritesArray") != nil
        }
    }
    
    //Creative Portion: watch trailer on youtube
    @IBAction func watchTrailer(_ sender: Any) {
        let url1: String = "https://www.youtube.com/results?search_query="
        let url2: String = VCtitle
        let url2space:String = url2.replacingOccurrences(of: " ", with: "+")
        let url2Final:String = url2space.replacingOccurrences(of: "[';:!.,?&%]", with: "")
        let urlTrailer:String = "+trailer"
        let urlFinal:String = url1 + url2Final + urlTrailer
        
        guard let actualURL = URL(string: urlFinal) else { return }
        UIApplication.shared.open(actualURL)
    }
    
    
    @IBAction func addToFavorite(_ sender: Any) {
        if arrayHasAdded == false{
            let array1:[String] = []
            UserDefaults.standard.set(array1, forKey: "favoritesArray")
            
            var nums = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
            nums.append(VCtitle)
            UserDefaults.standard.set(nums, forKey:"favoritesArray")
            
            let notification = UIAlertController(title: "Saved!", message: "The movie is saved to your favorites", preferredStyle: .alert)
            let confirmButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            notification.addAction(confirmButton)
            self.present(notification, animated: true, completion: nil)
            
        }else{
            var nums = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
            if nums.contains(VCtitle) != true{
                nums.append(VCtitle)
                UserDefaults.standard.set(nums, forKey:"favoritesArray")
                
                let notification = UIAlertController(title: "Saved!", message: "The movie is saved to your favorites", preferredStyle: .alert)
                let confirmButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                notification.addAction(confirmButton)
                self.present(notification, animated: true, completion: nil)
            }else{
                let notification = UIAlertController(title: "Already Exists", message: "The movie already exists in your favorites", preferredStyle: .alert)
                let confirmButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                notification.addAction(confirmButton)
                self.present(notification, animated: true, completion: nil)
            }
        }
        
        
        
        
        
        
        
        
//        print(UserDefaults.standard.object(forKey: "favoritesArray") ?? "print did not work")
        
        
        
//        let updateFavorites: SecondViewController = SecondViewController()
//        updateFavorites.setupTableView()
        
        
//        print(UserDefaults.standard.dictionaryRepresentation())
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
