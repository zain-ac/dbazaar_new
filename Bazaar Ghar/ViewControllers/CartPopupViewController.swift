//
//  CartPopupViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 25/06/2024.
//

import UIKit
import Cosmos


class CartPopupViewController: UIViewController {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var productNamel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productPriceline: UIView!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!

    var products: Product?
    

    override func viewDidLoad() {
 
        
        super.viewDidLoad()
        productNamel.text = products?.productName ?? ""
        discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.salePrice ?? 0)
        productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.regularPrice ?? 0)
        productImage.pLoadImage(url: products?.mainImage ?? "")
        crossBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    @objc func buttonTapped() {
        self.dismiss(animated: true)
    }
    @IBAction func addtoCartButton(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
