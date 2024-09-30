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
    
    var KSA : [KSAcat] = []
    var China : [KSAcat] = []
    var Pak : [KSAcat] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        shopbeyound_CollectionView.dataSource = self
        shopbeyound_CollectionView.delegate = self
        // Initialization code
        KSA = [
               
            KSAcat(name: "Soaps",id: "60d30fafadf1df13d41b56d5",img: "https://cdn.bazaarghar.com/1640677639491body-soaps-shower-gel.png"),
        KSAcat(name: "Fragrances",id: "604f48f648fcad02d8aaceeb",img: "https://cdn.bazaarghar.com/1640607482286mens-fragrances.png"),
        KSAcat(name: "Dates",id: "60c9dce26f0fe647a547713c",img:"https://cdn.bazaarghar.com/1640595049922dry-fruits.png"),
        KSAcat(name: "Rugs",id: "61c0665ec59a3763f321635a",img:"https://cdn.bazaarghar.com/1640698644416rugs-and-carpets.png")

        ]
        China = [
        KSAcat(name: "Games & Accessories",id: "65e82aa5067e0d3f4c5f774e",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714134544530game-and-accesories.png"),
            
        KSAcat(name: "Smart Electronics",id: "65e82aa5067e0d3f4c5f774c",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714109268854smart-electronics.png"),
        KSAcat(name: "Night Lights",id: "65e82aa5067e0d3f4c5f7746",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714110169088night-light.png"),
        KSAcat(name: "Home Decor",id: "65e82aa5067e0d3f4c5f76c8",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714110548828home-decor.png")
        ]
        
        Pak = [
            KSAcat(name: "Men Unstitched",id:"60532f0411747985fdce553a" ,img: "https://cdn.bazaarghar.com/1724830822838men-unstitched.png"),
            KSAcat(name: "Women Unstitched",id:"6049fd8d05ec9502c9f8d1f4" ,img:"https://cdn.bazaarghar.com/1724830629937women-unstitched.png"),
            KSAcat(name: "Boys T-Shirts ",id:"60d1e12badf1df13d41b555a" ,img:"https://cdn.bazaarghar.com/1724830959537boys-t-shirts.png"),
            KSAcat(name: "Bags",id:"6151a0a13d796e00329b5f4e" ,img:"https://cdn.bazaarghar.com/1640607310826ladies-handbags.png"),
         ]
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
                let data = Pak[indexPath.row]
                if LanguageManager.language == "ar"{
//                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }
                cell.shop_img.pLoadImage(url: data.img ?? "")
            
        }else if count == 2 {
                
                let data = China[indexPath.row]
                cell.shop_img.pLoadImage(url: data.img ?? "")
                if LanguageManager.language == "ar"{
//                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "
                }
        }else {
                
                let data = KSA[indexPath.row]
                cell.shop_img.pLoadImage(url: data.img ?? "")
                if LanguageManager.language == "ar"{
//                    cell.lbl.text = " \(data.lang?.ar?.name ?? "")  "
                }else{
                    cell.lbl.text = " \(data.name ?? "")  "

                }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if count == 1 {
            let data = Pak[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            vc.origin = "pak"
            self.nav?.pushViewController(vc, animated: false)
        }else if count == 2 {
            let data = China[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            vc.origin = "china"
            self.nav?.pushViewController(vc, animated: false)
        }else {
            let data = KSA[indexPath.row]

            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            vc.origin = "ksa"
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
