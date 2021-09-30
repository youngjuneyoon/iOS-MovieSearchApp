//
//  ThirdViewController.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/19/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var loadingScreen: UIActivityIndicatorView!
    
    var images:[UIImage] = []
    var wholeData:[APIResults] = []
    var titles:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.startingLoadingView()
        
        DispatchQueue.global().async{
            self.searchTopMovie()
            self.cacheImage()

            DispatchQueue.main.async {
                self.collectionView2.reloadData()
                self.endingLoadingView()
            }
        }

        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        collectionView2.dataSource = self
        collectionView2.delegate = self
    }
    
    func searchTopMovie(){
        
            if wholeData.count != 0{
                wholeData.removeAll()
                titles.removeAll()
                images.removeAll()
            }
            let url1:String = "https://api.themoviedb.org/3/movie/popular?api_key=1d3a4a20cb66dad7305432bf4cb09f33&language=en-US&page=1"
            let url = URL(string: url1)
            
            let data = try! Data(contentsOf: url!)
            let json = try! JSONDecoder().decode(APIResults.self, from: data)
            wholeData.append(json)
            
            for movies in wholeData[0].results{
                titles.append(movies.title)
                print(movies.title)
            }
            
        
    }
    
    func cacheImage(){
        let url1 = "https://image.tmdb.org/t/p/w200/"
        for movies in wholeData[0].results{
            let noImage:String = "no_available_image"
            
            let gettingUrl:String = movies.poster_path ?? noImage
            if gettingUrl == noImage{
                let noImage: UIImage = UIImage(named: "no_image")!
                images.append(noImage)
            }else{
                let finalUrl:String = url1 + gettingUrl
                let url = URL(string: finalUrl)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                images.append(image!)
            }
        }
        print(images)

    }
    
    func startingLoadingView(){
        view.bringSubviewToFront(self.loadingScreen)
        loadingScreen.isHidden = false
        loadingScreen.startAnimating()
        
        loadingScreen.frame = self.view.frame
        loadingScreen.style =
            UIActivityIndicatorView.Style.whiteLarge
        loadingScreen.color = UIColor.black
        
        print("loading view started")
    }
    
    func endingLoadingView(){
        loadingScreen.isHidden = true
        loadingScreen.stopAnimating()
        print("loading view ended")
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CollectionViewCell2
        
        cell.movieCellImageView2.image = images[indexPath.row]
        
        cell.movieCellTextView2.text = titles[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let selectedVC = storyboard!.instantiateViewController(withIdentifier: "selectedView") as! SelectedViewController
        selectedVC.VCimage = images[indexPath.item]
        selectedVC.VCtitle = titles[indexPath.item]
        
        let movieData = wholeData[0].results[indexPath.item]
        
        selectedVC.VCreleased = movieData.release_date
        selectedVC.VCoverview = String(movieData.overview)
        selectedVC.VCrating = String(movieData.vote_average)
        
        let noImage:String = "no_available_image"
        selectedVC.VCimageUrl = String(movieData.poster_path ?? noImage)
        
        selectedVC.backDropUrl = String(movieData.backdrop_path ?? noImage)

        
        
        navigationController?.pushViewController(selectedVC, animated: true)
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
