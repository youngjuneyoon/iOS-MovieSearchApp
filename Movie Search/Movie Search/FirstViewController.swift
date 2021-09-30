//
//  FirstViewController.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/16/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//
// Swift Open Link in Safari : https://stackoverflow.com/questions/25945324/swift-open-link-in-safari
// Delete from table view: https://www.ioscreator.com/tutorials/delete-rows-table-view-ios-tutorial-ios12

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingScreen: UIActivityIndicatorView!
    @IBOutlet weak var startView: UIView!
    
    
    
    var searchedMovieName:String = ""
    var images:[UIImage] = []
    var wholeData:[APIResults] = []
    var titles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        searchBar.delegate = self
        
        loadingScreen.isHidden = true
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
    }
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func setupTableView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        searchedMovieName = searchText
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search!")
        
        startView.isHidden = true
        startingLoadingView()
        
        if searchedMovieName != "" {
            if wholeData.count != 0{
                wholeData.removeAll()
                titles.removeAll()
                images.removeAll()
            }
            
            let url1:String = "https://api.themoviedb.org/3/search/movie?api_key=1d3a4a20cb66dad7305432bf4cb09f33&query="
            let url2:String = searchedMovieName
            let url2Final:String = url2.replacingOccurrences(of: " ", with: "+")
            
            let url3Final:String = url2Final.replacingOccurrences(of: "[';:!.,?&%]", with: "")
            
            let urlFinal:String = url1 + url3Final
            
            let url = URL(string: urlFinal)
            
            
            let data = try! Data(contentsOf: url!)
            print("\(data)")
            
            let json = try! JSONDecoder().decode(APIResults.self, from: data)
            wholeData.append(json)
            
            for movies in wholeData[0].results{
                titles.append(movies.title)
            }
            //self.collectionView.reloadData()
            DispatchQueue.global().async{
                self.cacheImage()
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                    self.endingLoadingView()
                }
            }
//            cacheImage()
        } else{
            endingLoadingView()
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
                //print(images)
            }
        }
//        endingLoadingView()
    }
    
    func startingLoadingView(){
        view.bringSubviewToFront(self.loadingScreen)
        loadingScreen.isHidden = false
        loadingScreen.startAnimating()
        
        loadingScreen.frame = self.view.frame
        //loadingScreen.backgroundColor = UIColor.white
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.movieCellImageView.image = images[indexPath.row]
        cell.movieCellTextView.text = titles[indexPath.item]
                
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

}

