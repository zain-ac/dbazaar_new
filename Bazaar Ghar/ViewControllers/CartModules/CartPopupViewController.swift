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
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var outOfStockLbl: UILabel!
    @IBOutlet weak var heartBtn: UIButton!

    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var products: Product?
    var nav:UINavigationController?

    override func viewDidLoad() {
 
        
        super.viewDidLoad()
        
//        let attributedText11 =  Utility().attributedStringWithColoredStrings(appDelegate.currencylabel, firstTextColor: UIColor.black, Utility().formatNumberWithCommas(products?.regularPrice ?? 0), secondTextColor:  UIColor(hexString: primaryColor))
        productNamel.text = products?.productName ?? ""
//        discountPrice.text =    appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.salePrice ?? 0)
      
//        productPrice.attributedText =   attributedText11
      
        productImage.pLoadImage(url: products?.mainImage ?? "")
        crossBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        if products?.onSale == true {
            discountPrice.isHidden = false
            productPrice.isHidden = false
            discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.regularPrice ?? 0)
            productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.salePrice ?? 0))
            productPriceline.isHidden = false
            discountPrice.textColor = UIColor.red
            productPriceline.backgroundColor = UIColor.red
        }else {
            productPriceline.isHidden = true
            discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(products?.regularPrice ?? 0))
         }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishList()
        if products?.quantity ?? 0 > 0 {
            addToCartBtn.backgroundColor = UIColor(hex: primaryColor)
            addToCartBtn.isEnabled = true
            outOfStockLbl.isHidden = true
        }else {
            addToCartBtn.backgroundColor = .gray
            addToCartBtn.isEnabled = false
            outOfStockLbl.isHidden = false
        }
    }
    private func addToCartApi(product: String, quantity: Int,navigation:Bool){
        APIServices.additemtocart(product:product,quantity:quantity,completion: {[weak self] data in
          guard let strongSelf = self else { return }
          switch data {
          case .success(let res):
            let storyboard = UIStoryboard(name: "Popups", bundle: nil)
            guard let addToCartPopupVC = storyboard.instantiateViewController(withIdentifier: "AddtocartPopup") as? AddtocartPopup else { return }
            addToCartPopupVC.modalPresentationStyle = .custom
            addToCartPopupVC.transitioningDelegate = strongSelf.centerTransitioningDelegate
            addToCartPopupVC.img = "addtocart"
            addToCartPopupVC.titleText = "Added to Cart!"
            addToCartPopupVC.messageText = "The item has been added successfully"
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
    //        let vc = AddtocartPopup.getVC(.popups)
    //             vc.modalPresentationStyle = .custom
    //             vc.transitioningDelegate = self?.centerTransitioningDelegate
    //        self?.present(vc, animated: true, completion: {
    //          // Dismiss the current view controller first
    //
    //        })
    //        if(navigation){
    //          self?.getCartProducts() 
    //         }
            self?.view.makeToast("Item Added to cart")
          case .failure(let error):
            if(error == "Please authenticate" && AppDefault.islogin){
              DispatchQueue.main.async {
                appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                 let vc = PopupLoginVc.getVC(.popups)
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
              }
            }else if(error == "Please authenticate" && AppDefault.islogin == false){
               let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self?.present(vc, animated: true, completion: nil)
    //          appDelegate.GotoDashBoard(ischecklogin: true)
            }
            else if(error == "desired quantity not available"){
               let vc = NewProductPageViewController.getVC(.productStoryBoard)
              vc.slugid = self?.products?.slug
              vc.iscome = true
              self?.nav?.pushViewController(vc, animated: true)//          appDelegate.GotoDashBoard(ischecklogin: true)
            }
            else{
    //          if self?.varientSlug != nil {
    //            print(error)
    //            self?.view.makeToast(error)
    //          }else {
    //            self?.view.makeToast("Please Select Varient")
    //          }
            }
          }
        })
      }
    @objc func buttonTapped() {
        self.dismiss(animated: true)
    }
    @IBAction func addtoCartButton(_ sender: Any) {
                
//        if (products?.variants?.first?.id == nil) {
        if self.products?.id == nil {
            self.addToCartApi(product:self.products?._id ?? "",quantity:1,navigation: false)
        }else {
            self.addToCartApi(product:self.products?.id ?? "",quantity:1,navigation: false)

        }
//        }else {
//            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            nav?.pushViewController(vc, animated: false)
//        }
            
        
    }
    @IBAction func likeaction(_ sender: Any) {
        if(AppDefault.islogin){
            if products?.id == nil {
                self.wishListApi(productId: (products?._id ?? ""))
            }else {
                self.wishListApi(productId: (products?.id ?? ""))
            }
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    
    private func wishListApi(productId:String) {
        APIServices.newwishlist(product:productId,completion: {[weak self] data in
          switch data{
          case .success(let res):
           //
    //        if(res == "OK"){
    //          button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    //          button.tintColor = .red
    //
    //        }else{
    //          button.setImage(UIImage(systemName: "heart"), for: .normal)
    //          button.tintColor = .gray
    //
    //        }
              self?.wishList()
          case .failure(let error):
            print(error)
              if error == "Please authenticate" {
                  if AppDefault.islogin{
                      
                  }else{
//                       DispatchQueue.main.async {
//                          self.selectedIndex = 0
//                       }
                        let vc = PopupLoginVc.getVC(.popups)
                      vc.modalPresentationStyle = .overFullScreen
                      self?.present(vc, animated: true, completion: nil)
                  }
              }
          }
        })
      }

    func wishList(){
        APIServices.wishlist(isbackground: false){[weak self] data in
          switch data{
          case .success(let res):
          
            AppDefault.wishlistproduct = res.products
              if let wishlistProducts = AppDefault.wishlistproduct {
                if self?.products?.id == nil {
                    if wishlistProducts.contains(where: { $0.id == self?.products?._id }) {
                        self?.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        self?.heartBtn.tintColor = .red
                        } else {
                            self?.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                            self?.heartBtn.tintColor = .white
                        }
                  }else {
                      if wishlistProducts.contains(where: { $0.id == self?.products?.id }) {
                          self?.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                          self?.heartBtn.tintColor = .red
                          } else {
                              self?.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                              self?.heartBtn.tintColor = .white
                          }
                  }
                }

          case .failure(let error):
            print(error)
          }
        }
      }
    
}
