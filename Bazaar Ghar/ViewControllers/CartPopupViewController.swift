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
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var products: Product?
    var nav:UINavigationController?

    override func viewDidLoad() {
 
        
        super.viewDidLoad()
        
        let attributedText11 =  Utility().attributedStringWithColoredStrings(appDelegate.currencylabel, firstTextColor: UIColor.black, Utility().formatNumberWithCommas(products?.regularPrice ?? 0), secondTextColor:  UIColor(hexString: "#06B7FD"))
        productNamel.text = products?.productName ?? ""
        discountPrice.text =    appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.salePrice ?? 0)
      
        productPrice.attributedText =   attributedText11
      
        productImage.pLoadImage(url: products?.mainImage ?? "")
        crossBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    private func addToCartApi(product: String, quantity: Int,navigation:Bool){
        APIServices.additemtocart(product:product,quantity:quantity,completion: {[weak self] data in
            guard let strongSelf = self else { return }

            switch data {
            case .success(let res):
////
//                let vc = AddtocartPopup.getVC(.sidemenu)
//                            vc.modalPresentationStyle = .custom
//                            vc.transitioningDelegate = self?.centerTransitioningDelegate
//                            vc.img = "addtocart"
//                            vc.titleText = "Added to Cart!"
//                            vc.messageText = "Successfully added \(product) in your cart"
//                            vc.leftBtnText = "Continue Shopping"
//                            vc.rightBtnText = "Go to Cart"
//                            vc.iscomefor = "cart"
//                            vc.nav = self?.nav
//
//                            self?.present(vc, animated: true) {
//                                // Dismiss the current view controller after presenting the popup
//                                if let currentVC = self?.presentingViewController {
//                                    currentVC.dismiss(animated: true, completion: nil)
//                                }
//                            }
                
                let storyboard = UIStoryboard(name: "sidemenu", bundle: nil)
                guard let addToCartPopupVC = storyboard.instantiateViewController(withIdentifier: "AddtocartPopup") as? AddtocartPopup else { return }

                addToCartPopupVC.modalPresentationStyle = .custom
                addToCartPopupVC.transitioningDelegate = strongSelf.centerTransitioningDelegate
                addToCartPopupVC.img = "addtocart"
                addToCartPopupVC.titleText = "Added to Cart!"
                addToCartPopupVC.messageText = "Successfully added null to your cart"
                addToCartPopupVC.leftBtnText = "Continue Shopping"
                addToCartPopupVC.rightBtnText = "Go to Cart"
                addToCartPopupVC.iscomefor = "cart"
                addToCartPopupVC.nav = strongSelf.nav

                // Store a reference to the presenting view controller
                if let presentingVC = strongSelf.presentingViewController {
                    // Dismiss the current view controller
                    strongSelf.dismiss(animated: true) {
                        // Present the AddtocartPopup view controller
                        presentingVC.present(addToCartPopupVC, animated: true, completion: nil)
                    }
                } else {
                    // Present directly if there is no presenting view controller
                    strongSelf.present(addToCartPopupVC, animated: true, completion: nil)
                }
                
//                let vc = AddtocartPopup.getVC(.sidemenu)
//                          vc.modalPresentationStyle = .custom
//                          vc.transitioningDelegate = self?.centerTransitioningDelegate
//                self?.present(vc, animated: true, completion: {
//                    // Dismiss the current view controller first
//
//                })
                
//                if(navigation){
//                    self?.getCartProducts()
//                  }
                self?.view.makeToast("Item Added to cart")
                
            case .failure(let error):
                
                if(error == "Please authenticate" && AppDefault.islogin){
                    DispatchQueue.main.async {
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                        let vc = PopupLoginVc.getVC(.main)
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
                    let vc = PopupLoginVc.getVC(.main)
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc, animated: true, completion: nil)
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
//                    if self?.varientSlug != nil {
//                        print(error)
//                        self?.view.makeToast(error)
//                    }else {
//                        self?.view.makeToast("Please Select Varient")
//                    }
                }
                
            }
        })
    }
    @objc func buttonTapped() {
        self.dismiss(animated: true)
    }
    @IBAction func addtoCartButton(_ sender: Any) {
       
    
                self.addToCartApi(product:self.products?.id ?? "",quantity:1,navigation: false)
            
        
    }
    @IBAction func likeaction(_ sender: Any) {
        addtowishlist(product: products?.id  ?? "")
    }
    private func addtowishlist(product: String){
        APIServices.addwishlist(proudct:product,completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
//                self?.Likebtn.isSelected = true
                self?.view.makeToast("Product added to wishlist successfully")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
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
