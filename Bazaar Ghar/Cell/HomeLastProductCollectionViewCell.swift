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
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var percentBGView: UIView!
    @IBOutlet weak var wishlisticon: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    @IBAction func wishlistButton(_ sender: Any) {
        
    }
   
}
