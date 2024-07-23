//
//  Shopbeyound_TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit

class Shopbeyound_TableViewCell: UITableViewCell {
    @IBOutlet weak var shopbeyound_CollectionView: UICollectionView!
    @IBOutlet weak var shop_img: UIImageView!

    @IBOutlet weak var explore_btn: UIButton!
    @IBOutlet weak var shopname_lbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    var count = 0
    var nav : UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        shopbeyound_CollectionView.dataSource = self
        shopbeyound_CollectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
extension Shopbeyound_TableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shopbeyound_CollectionViewCell", for: indexPath) as! Shopbeyound_CollectionViewCell
        if count == 1 {
            if CategoriesResponsedata.count > 0 {
                let data = CategoriesResponsedata[indexPath.row]
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }
                cell.shop_img.pLoadImage(url: data.mainImage ?? "")
            }
            
        }else if count == 2 {
            if CategoriesResponsedata.count > 0 {
                
                let data = CategoriesResponsedata[indexPath.row + 12]
                cell.shop_img.pLoadImage(url: data.mainImage ?? "")
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }            }
        }else {
            if CategoriesResponsedata.count > 0 {
                
                let data = CategoriesResponsedata[indexPath.row + 22]
                cell.shop_img.pLoadImage(url: data.mainImage ?? "")
                if LanguageManager.language == "ar"{
                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if count == 1 {
            let data = CategoriesResponsedata[indexPath.row]

            let vc = Category_ProductsVC.getVC(.main)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            self.nav?.pushViewController(vc, animated: false)
        }else if count == 2 {
            let data = CategoriesResponsedata[indexPath.row + 12]

            let vc = Category_ProductsVC.getVC(.main)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            self.nav?.pushViewController(vc, animated: false)
        }else {
            let data = CategoriesResponsedata[indexPath.row + 22]

            let vc = Category_ProductsVC.getVC(.main)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            self.nav?.pushViewController(vc, animated: false)
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
      
        return CGSize(width: self.shopbeyound_CollectionView.frame.width/2.04, height: self.shopbeyound_CollectionView.frame.height/2.04)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.zero // No insets
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 5 // No spacing between lines
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1 // No spacing between items
     }
}
