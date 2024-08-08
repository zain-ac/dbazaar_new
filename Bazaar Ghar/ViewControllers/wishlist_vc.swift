//
//  wishlist_vc.swift
//  Bazaar Ghar
//
//  Created by Zany on 21/09/2023.
//

import UIKit

class wishlist_vc: UIViewController {
    
    var wishListItems: [WishlistProduct] = []
    @IBOutlet weak var wishlistcollection: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var wishlistLbl: UILabel!
    @IBOutlet weak var emptyview: UIView!
    @IBOutlet weak var emptylbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        self.emptyview.isHidden = true

        wishlistcollection.delegate = self
        wishlistcollection.dataSource  = self
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        wishList()
        LanguageRender()
    }
    
    func LanguageRender() {
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        wishlistLbl.text = "wishlist".pLocalized(lang: LanguageManager.language)

        
    }
    
     func wishList(){
         APIServices.wishlist(isbackground: false){[weak self] data in
            switch data{
            case .success(let res):
              print(res)
                self?.wishListItems = res.products ?? []
                self?.wishlistcollection.reloadData()
                if(self?.wishListItems.count ?? 0 > 0){
                    self?.emptyview.isHidden = true
                    self?.emptylbl.isHidden = false

                }else{
                    self?.emptyview.isHidden = false
                    self?.emptylbl.isHidden = true
                }
            case .failure(let error):
                self?.emptyview.isHidden = false
                print(error)
            }
        }
    }
    
        
    
    func setupCollectionView() {
                let nib = UINib(nibName: "PRoductCategory_cell", bundle: nil)
                wishlistcollection.register(nib, forCellWithReuseIdentifier: "PRoductCategory_cell")
        wishlistcollection.delegate = self
        wishlistcollection.dataSource = self

            }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        appDelegate.isbutton = false
    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
   

}
extension wishlist_vc:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PRoductCategory_cell", for: indexPath) as! PRoductCategory_cell
       let data =  self.wishListItems[indexPath.row]
        cell.productimage.pLoadImage(url: data.mainImage ?? "")
        cell.productname.text = data.productName
        
        if LanguageManager.language == "ar"{
            cell.productname.text  = data.category?.lang?.ar?.name
        }else{
            cell.productname.text = data.productName
        }
        if data.onSale == true {
            cell.discountPrice.isHidden = false
            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0)
            cell.productPriceLine.isHidden = false
            cell.productPrice.textColor = UIColor.systemGray3

        }else {
            cell.discountPrice.isHidden = true
            cell.productPriceLine.isHidden = true
            cell.productPrice.textColor = UIColor.black
        }
        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data =  self.wishListItems[indexPath.row]
        let vc = NewProductPageViewController.getVC(.sidemenu)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.wishlistcollection.frame.width/2.1-2,
                      height: self.wishlistcollection.frame.height/2.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    }
    
    }



//
//extension wishlist_vc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return wishListItems.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let data = wishListItems[indexPath.row]
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
//            cell.imageView.pLoadImage(url: data.mainImage ?? "")
//
//            return cell
//
//    }
//}
