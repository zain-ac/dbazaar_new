//
//  HomeLastProductCollectionViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 24/08/2023.
//

import UIKit

class HomeLastProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var Offbanner: UILabel!
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var percentBGView: UIView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    
    
    var product: Product? {
        didSet {
            if product?.regularPrice == nil || product?.salePrice == nil {
            
            }else {
//                let percentValue = (((product?.regularPrice ?? 0) - (product.salePrice ?? 0)) * 100) / (product.regularPrice ?? 0)
//                self.Offbanner.text = String(format: "%.0f%% OFF", percentValue)
                
                let discountPercentage = Utility().calculateDiscountPercentage(regularPrice: product?.regularPrice ?? 0, salePrice: product?.salePrice ?? 0)
                self.Offbanner.text = "\(discountPercentage)% OFF"
            }
        }
    }
    var idarray : [Product]?{
        didSet{
            if((idarray?.first?.id ?? "") == (product?.id ?? "")){
                heartBtn.isSelected = true
            }else{
                heartBtn.isSelected = false
            }
        
    }
               }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}

