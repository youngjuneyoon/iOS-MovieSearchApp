//
//  SecondViewController.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/16/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var favoritesArray:[String] = ["hello", "this", "is", "test"]
//    var nums = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
//    var favoritesArray:[String] = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
    @IBOutlet weak var tableView: UITableView!
    var favoritesArray:[String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDefaults()
        setupTableView()
        print("reloading table view")

//        print(UserDefaults.standard.dictionaryRepresentation().keys)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("again..and..again..and...")
        getDataFromDefaults()
        setupTableView()
        tableView.reloadData()

    }
    
    var arrayHasAdded: Bool {
        get {
            return UserDefaults.standard.object(forKey: "favoritesArray") != nil
        }
    }
    
    func getDataFromDefaults(){
        if arrayHasAdded == true{
            let temp1 = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
            favoritesArray = temp1
        }
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //reuseIdentifier check!!!
        let myCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        myCell.textLabel!.text = favoritesArray[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            favoritesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            var nums = UserDefaults.standard.array(forKey: "favoritesArray") as! [String]
                nums.remove(at: indexPath.row)
                UserDefaults.standard.set(nums, forKey:"favoritesArray")
            
            print(favoritesArray)
        }
    }
    
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let deleteFavorite = NSLocalizedString("Delete", comment:"Delete action")
//
//        let deleteAction = UITableViewRowAction(style : .destructive, title: deleteFavorite){
//            (action,indexPath) in
//            favoritesArray.remove(at:indexPath.row)
//        }
//    }

    

}

