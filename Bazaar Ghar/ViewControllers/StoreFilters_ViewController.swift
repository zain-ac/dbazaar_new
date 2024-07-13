//
//  StoreFilters_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 13/07/2024.
//

import UIKit

class StoreFilters_ViewController: UIViewController {
    @IBOutlet weak var categoriestbl: UITableView!
    @IBOutlet weak var store_collect: UICollectionView!
    @IBOutlet weak var colors_tbl: UITableView!
    @IBOutlet weak var rating_collect: UICollectionView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriestbl.delegate = self
        categoriestbl.dataSource = self
        store_collect.delegate = self
        store_collect.dataSource = self 
        colors_tbl.delegate = self
        colors_tbl.dataSource = self
        rating_collect.delegate = self
        rating_collect.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}
extension StoreFilters_ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriestbl{
            return 3
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoriestbl{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFilterscategory_TableViewCell", for: indexPath) as! StoreFilterscategory_TableViewCell
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFiltersColors_TableViewCell", for: indexPath) as! StoreFiltersColors_TableViewCell
            return cell
        }
    }
    
    
}
extension StoreFilters_ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == store_collect{
            return 3
        }else{
            return 3
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == store_collect{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersStore_CollectionViewCell", for: indexPath) as! StoreFiltersStore_CollectionViewCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersrating_CollectionViewCell", for: indexPath) as! StoreFiltersrating_CollectionViewCell
            return cell

        }
        
    }
    
    
}
