//
//  HomeTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/08/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var Homecollectionview: UICollectionView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var cateogorylbl: UILabel!
    @IBOutlet weak var catBannerBtn: UIButton!

    
    var productvariantsapi: [Variants]? = nil{
        didSet{
            
            
        }
        
    }
    let centerTransitioningDelegate = CenterTransitioningDelegate()

    
    
     var productapi: [Product]? = nil{
         didSet{
             self.Homecollectionview.reloadData()
      
         }
     }
     
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Homecollectionview.delegate = self
        Homecollectionview.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//            return 1
//        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return productapi?.count ?? 0
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = productapi?[indexPath.row]
        Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        self.productvariantsapi = data?.variants!
        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
        if LanguageManager.language == "ar"{
            cell.productname.text = data?.lang?.ar?.productName
        }else{
            cell.productname.text =  data?.productName
        }
//        cell.productname.text =  data.productName
        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0.0)
        if data?.onSale == true {
            cell.discountPrice.isHidden = false
            cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0.0)
            cell.productPriceLine.isHidden = false
            cell.productPrice.textColor = UIColor.red
            cell.productPriceLine.backgroundColor = UIColor.red
            cell.discountPrice.textColor = UIColor(hexString: "#069DDD")

        }else {
            cell.discountPrice.isHidden = true
            cell.productPriceLine.isHidden = true
            cell.productPrice.textColor = UIColor(hexString: "#069DDD")

         }
        cell.cartButton.tag = indexPath.row
        cell.cartButton.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)

        
        
        return cell
    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = productapi?[sender.tag]
        
        let vc = CartPopupViewController.getVC(.main)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
        vc.products = data
        UIApplication.pTopViewController().present(vc, animated: true, completion: nil)

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = productapi?[indexPath.row]
        appDelegate.slugid = data?.slug ?? ""
        NotificationCenter.default.post(name: Notification.Name("Productid"), object: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Homecollectionview.frame.width/2-5, height: Homecollectionview.frame.height/2-5)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
   
}
