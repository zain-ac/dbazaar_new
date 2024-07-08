//
//  New_StoreVC.swift
//  Bazaar Ghar
//
//  Created by Zany on 02/07/2024.
//

import UIKit
import FSPagerView


class New_StoreVC: UIViewController {
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var shopByCategories: UICollectionView!
    @IBOutlet weak var latestProductCollectionView: UICollectionView!
    @IBOutlet weak var pagerView2: FSPagerView!
    @IBOutlet weak var newCollectionCollectionView: UICollectionView!



    var counter =  0

    var bannerapidata: [Banner]? = [] {
        didSet{
            self.pagerView.reloadData()
            self.pagerView2.reloadData()

        }
    }
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var latestProductModel: [PChat] = []
    let centerTransitioningDelegate = CenterTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        pagerView2.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView2.automaticSlidingInterval = 2.0

        bannerApi(isbackground: false)
        getStreamingVideos(limit: 20, page: 1, categories: [])
        randomproduct(cat: "65e82aa5067e0d3f4c5f774e", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)


        // Do any additional setup after loading the view.
    }
    
    
    private func bannerApi(isbackground:Bool){
        APIServices.banner(isbackground: isbackground, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(data)
                if(res.count > 0){
                    let banners =  res
                    
                   
                    for item in res{
                        let objext = item.id
                        if objext?.bannerName == "Mob Banner Home" {
                            self?.bannerapidata = (objext?.banners)!
                        }
                    }
                }
    
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"",completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
        
                self?.LiveStreamingResultsdata = res.results ?? []
       
                self?.videoCollection.reloadData()
                self?.shopByCategories.reloadData()

            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }

    private func randomproduct(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,isbackground : Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.count > 0){
                    self?.latestProductModel = res
//                    AppDefault.randonproduct = res
                }
                print(res)
               
                self?.latestProductCollectionView.reloadData()
                self?.newCollectionCollectionView.reloadData()

            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
        
    }

    
}
extension New_StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        } else if collectionView == latestProductCollectionView {
            return self.latestProductModel.first?.product?.count ?? 0
        }else if collectionView == newCollectionCollectionView  {
            return self.latestProductModel.first?.product?.count ?? 0
        }else {
            return self.LiveStreamingResultsdata.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)"
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        } else if collectionView == latestProductCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = self.latestProductModel.first?.product?[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

            cell.productimage.pLoadImage(url: data?.mainImage ?? "")
            cell.productname.text =  data?.productName
            cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0)
            if data?.onSale == true {
                cell.discountPrice.isHidden = false
                let currencySymbol = appDelegate.currencylabel
                let salePrice = Utility().formatNumberWithCommas(data?.salePrice ?? 0)

                // Create an attributed string for the currency symbol with the desired color
                let currencyAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black // Change to your desired color
                ]
                let attributedCurrencySymbol = NSAttributedString(string: currencySymbol, attributes: currencyAttributes)

                // Create an attributed string for the sale price with the desired color
                let priceAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor(hexString: "#069DDD") // Change to your desired color
                ]
                let attributedPrice = NSAttributedString(string: salePrice, attributes: priceAttributes)

                // Combine the attributed strings
                let combinedAttributedString = NSMutableAttributedString()
                combinedAttributedString.append(attributedCurrencySymbol)
                combinedAttributedString.append(attributedPrice)
                cell.discountPrice.attributedText = combinedAttributedString

//                cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
//                cell.discountPrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor(hexString: "#069DDD")

             }
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            
            
            
            return cell
        } else if collectionView == newCollectionCollectionView  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = self.latestProductModel.first?.product?[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

            cell.productimage.pLoadImage(url: data?.mainImage ?? "")
            cell.productname.text =  data?.productName
            cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0)
            if data?.onSale == true {
                cell.discountPrice.isHidden = false
                let currencySymbol = appDelegate.currencylabel
                let salePrice = Utility().formatNumberWithCommas(data?.salePrice ?? 0)

                // Create an attributed string for the currency symbol with the desired color
                let currencyAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black // Change to your desired color
                ]
                let attributedCurrencySymbol = NSAttributedString(string: currencySymbol, attributes: currencyAttributes)

                // Create an attributed string for the sale price with the desired color
                let priceAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor(hexString: "#069DDD") // Change to your desired color
                ]
                let attributedPrice = NSAttributedString(string: salePrice, attributes: priceAttributes)

                // Combine the attributed strings
                let combinedAttributedString = NSMutableAttributedString()
                combinedAttributedString.append(attributedCurrencySymbol)
                combinedAttributedString.append(attributedPrice)
                cell.discountPrice.attributedText = combinedAttributedString

//                cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
//                cell.discountPrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor(hexString: "#069DDD")

             }
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            
            
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)"
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
            return cell
        }
    }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = self.latestProductModel.first?.product?[sender.tag]
        
        let vc = CartPopupViewController.getVC(.main)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
        vc.products = data
        self.present(vc, animated: true, completion: nil)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == videoCollection{
            
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = SingleVideoView.getVC(.main)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == latestProductCollectionView {
            let data = latestProductModel.first?.product?[indexPath.row]
            let vc = ProductDetail_VC.getVC(.main)
                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == newCollectionCollectionView {
            let data = latestProductModel.first?.product?[indexPath.row]
            let vc = ProductDetail_VC.getVC(.main)
                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = SingleVideoView.getVC(.main)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == videoCollection {
           return CGSize(width: collectionView.frame.size.width/2.1, height: collectionView.frame.size.height)
        }else if collectionView == latestProductCollectionView {
            return CGSize(width: collectionView.frame.width/2-5, height: collectionView.frame.height/2-5)
        }else if collectionView == newCollectionCollectionView {
            return CGSize(width: collectionView.frame.width/2-5, height: collectionView.frame.height/2-5)
        }  else {
            return CGSize(width: collectionView.frame.size.width/3.3, height: collectionView.frame.size.height)

        }
    }
}
        
extension New_StoreVC: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
    if pagerView == self.pagerView {
        return  bannerapidata?.count ?? 0

    } else {
        return  bannerapidata?.count ?? 0

    }
   }

   func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
       if pagerView == self.pagerView {
           let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
           let data = bannerapidata?[index]
           cell.imageView?.pLoadImage(url: data?.image ?? "")
           cell.imageView?.contentMode = .scaleAspectFill
           return cell
       }else {
           let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
           let data = bannerapidata?[index]
           cell.imageView?.pLoadImage(url: data?.image ?? "")
           cell.imageView?.contentMode = .scaleAspectFill
           return cell
       }

   }

   // MARK: - FSPagerViewDelegate

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if pagerView == self.pagerView {
            let currentIndex = pagerView.currentIndex
            pageControl.currentPage = currentIndex
        }else {
            let currentIndex = pagerView.currentIndex
            pageControl.currentPage = currentIndex
        }

    }
     
     
     func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
         if pagerView == self.pagerView {
             let data = self.bannerapidata?[index]
             if data?.type == "" || data?.type == nil {
                 
             }else {
                 switch data?.type {
                     
                   case "Market":
                     let vc = StoreSearchVC.getVC(.main)
                     vc.isMarket = true
                     vc.marketID = data?.linkId
                     vc.isNavBar = false
                     self.navigationController?.pushViewController(vc, animated: false)

                   case "Store":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = Category_ProductsVC.getVC(.main)
                         vc.prductid = data?.linkId ?? ""
                         vc.catNameTitle = data?.name ?? ""
                         vc.storeFlag = true
                     
                         vc.storeId = data?.linkId ?? ""
                         vc.video_section = true
                         self.navigationController?.pushViewController(vc, animated: false)
                     }

                   case "Category":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = Category_ProductsVC.getVC(.main)
                         vc.prductid = data?.linkId ?? ""
                         vc.video_section = false
                         vc.storeFlag = false
                         vc.catNameTitle = data?.name ?? ""
                         self.navigationController?.pushViewController(vc, animated: false)
                     }
                     
                   case "Product":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = ProductDetail_VC.getVC(.main)
                         vc.isGroupBuy = false
                         vc.slugid = data?.linkId
                         self.navigationController?.pushViewController(vc, animated: false)
                     }
                     
                   case "Video":
                     let vc = Live_VC.getVC(.main)
                     self.navigationController?.pushViewController(vc, animated: false)
                     
                   case "Page":
                     print("page")
                       let vc = Page_Vc.getVC(.main)
                     vc.collectionId = data?.linkId ?? ""
                       self.navigationController?.pushViewController(vc, animated: false)

                   default:
                         print("Invalid data")
                 }
             }
         }else {
             let data = self.bannerapidata?[index]
             if data?.type == "" || data?.type == nil {
                 
             }else {
                 switch data?.type {
                     
                   case "Market":
                     let vc = StoreSearchVC.getVC(.main)
                     vc.isMarket = true
                     vc.marketID = data?.linkId
                     vc.isNavBar = false
                     self.navigationController?.pushViewController(vc, animated: false)

                   case "Store":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = Category_ProductsVC.getVC(.main)
                         vc.prductid = data?.linkId ?? ""
                         vc.catNameTitle = data?.name ?? ""
                         vc.storeFlag = true
                     
                         vc.storeId = data?.linkId ?? ""
                         vc.video_section = true
                         self.navigationController?.pushViewController(vc, animated: false)
                     }

                   case "Category":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = Category_ProductsVC.getVC(.main)
                         vc.prductid = data?.linkId ?? ""
                         vc.video_section = false
                         vc.storeFlag = false
                         vc.catNameTitle = data?.name ?? ""
                         self.navigationController?.pushViewController(vc, animated: false)
                     }
                     
                   case "Product":
                     if data?.linkId == "" || data?.linkId == nil {
                         
                     }else {
                         let vc = ProductDetail_VC.getVC(.main)
                         vc.isGroupBuy = false
                         vc.slugid = data?.linkId
                         self.navigationController?.pushViewController(vc, animated: false)
                     }
                     
                   case "Video":
                     let vc = Live_VC.getVC(.main)
                     self.navigationController?.pushViewController(vc, animated: false)
                     
                   case "Page":
                     print("page")
                       let vc = Page_Vc.getVC(.main)
                     vc.collectionId = data?.linkId ?? ""
                       self.navigationController?.pushViewController(vc, animated: false)

                   default:
                         print("Invalid data")
                 }
             }
         }
     

     }
}
