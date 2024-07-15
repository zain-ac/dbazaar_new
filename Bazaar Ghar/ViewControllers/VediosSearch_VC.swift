//
//  VediosSearch_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 06/09/2023.
//

import UIKit

class VediosSearch_VC: UIViewController {
    @IBOutlet weak var dropdownbtn: UIButton!
    @IBOutlet weak var vediocategoryCollection:UICollectionView!
    @IBOutlet weak var vediosearchCollection:UICollectionView!
    
    @IBOutlet weak var notFound: UILabel!


    var searchVideodata: [LiveStreamingResults] = []
    var searchText: String? {
        didSet {
            searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array)
        }
    }
    
    var array = [String]()
    var limit: Int?
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        vediocategoryCollection.dataSource = self
        vediocategoryCollection.delegate = self
        vediosearchCollection.dataSource = self
        vediosearchCollection.delegate = self
        self.viewheight.constant = 0
        // Do any additional setup after loading the view.
    }
    @IBAction func DropDownTapped(_ sender: Any) {
        self.dropdownbtn.isSelected = !self.dropdownbtn.isSelected
        
        
        if(self.dropdownbtn.isSelected){
          
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.viewheight.constant = 90
               self.view.layoutIfNeeded()
           })
        }else{
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.viewheight.constant = 0
               self.view.layoutIfNeeded()
           })

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        notFound.isHidden = true

        searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array)
    }
    
    private func searchVideo(name:String,value:String,limit:Int,catId:[String]){
        APIServices.searchVideo(name:name,value:value,limit:limit,catId: catId){[weak self] data in
            switch data{
            case .success(let res):
                if res.results.count > 0 {
                    self?.notFound.isHidden = true
                }else {
                    self?.notFound.isHidden = false
                }
                self?.searchVideodata = res.results
              print(res)
                self?.vediosearchCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
extension VediosSearch_VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vediocategoryCollection
        {
            return AppDefault.CategoriesResponsedata?.count ?? 0
            
        }else {
            return searchVideodata.count
        }
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if (collectionView == vediocategoryCollection){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vediocategory_Cell", for: indexPath) as! vediocategory_Cell
                let data = AppDefault.CategoriesResponsedata?[indexPath.row]
                cell.imageView.pLoadImage(url: data?.mainImage ?? "")
                cell.vedioCatLbl.text = data?.name ?? ""
                return cell
            }else{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vediosearchcollection_Cell", for: indexPath) as! vediosearchcollection_Cell
                let data = searchVideodata[indexPath.row]
                cell.mainimageView.pLoadImage(url: data.thumbnail ?? "")
                cell.productimageView.pLoadImage(url: data.thumbnail ?? "")
                cell.productname.text = data.title
                cell.storename.text = data.brandName
                cell.viewslbl.text = "\(data.totalViews ?? 0)"
                return cell
            }
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == vediocategoryCollection {
                return CGSize(width: collectionView.frame.size.width/5-10, height: collectionView.frame.size.height)
            }else {
                let data = searchVideodata[indexPath.row]
                if data.title?.count ?? 0 > 47 {
                    return CGSize(width: collectionView.frame.size.width, height: 338)
                }else {
                    return CGSize(width: collectionView.frame.size.width, height: 325)

                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == vediocategoryCollection
        {
            let data = AppDefault.CategoriesResponsedata?[indexPath.row]
            self.array.removeAll()
            self.array.append(data?.id ?? "")
            self.searchVideo(name: "title", value: searchText ?? "", limit: limit ?? 20, catId: self.array)
         
            
        }else {
            let vc = New_SingleVideoview.getVC(.sidemenu)
            vc.LiveStreamingResultsdata = self.searchVideodata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
        
}

