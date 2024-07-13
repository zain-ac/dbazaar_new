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
    @IBOutlet weak var HeaderbrandNameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollheight: NSLayoutConstraint!



    var counter =  0

    var bannerapidata: [Banner]? = [] {
        didSet{
            self.pagerView.reloadData()
        }
    }
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var latestProductModel: [PChat] = []
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var prductid:String?
    var brandName:String?
    var gallaryImages:[String]?
    var isFollow = false
    var storeId = String()
    var productCount:String?
    var getAllProductsByCategoriesData: [getAllProductsByCategoriesResponse] = []
    var categoryPage = 1
    var isLoadingNextPage = false
    var isEndReached = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        HeaderbrandNameLbl.text = brandName ?? ""
        brandNameLbl.text = brandName ?? ""
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0

        bannerApi(isbackground: false)
        getStreamingVideos(userId: prductid ?? "", limit: 10, page: 1, categories: [])
        randomproduct(cat: "65e82aa5067e0d3f4c5f774e", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
        followcheck(storeId: self.storeId)
        update(count: 1)


        // Do any additional setup after loading the view.
    }
  
    func update(count:Int) {
        getAllProductsByCategories(limit: 20, page: count, sortBy:"-price", category:prductid ?? "", active: false)
    }
    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.getAllProductsByCategoriesData.append(contentsOf: res.Categoriesdata ?? [])

                    // Increment the page numbe
                    self?.categoryPage += 1
                    
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    
                    let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 240
                    self?.scrollheight.constant = CGFloat( CGFloat(ll) + 900)
                    self?.categoryproduct_collectionview.reloadData()
                }else {

                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
//                    self?.productEmptyLbl.isHidden = true
                }else {
//                    self?.productEmptyLbl.isHidden = false

                }


                
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    if error == "Not found"{
                        
                    }else{
                        self?.view.makeToast(error)
                    }
                }
                self?.isLoadingNextPage = false

            }
        }
    }
    

    private func bannerApi(isbackground:Bool){
        APIServices.banner(isbackground: isbackground, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(data)
                
                if self?.gallaryImages?.count ?? 0 > 0 {

                }else {
                    if(res.count > 0){
                        let banners =  res
                        
                       
                        for item in res{
                            let objext = item.id
                            if objext?.bannerName == "Mob Banner Home" {
                                self?.bannerapidata = (objext?.banners)!
                            }
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
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    private func getStreamingVideos(userId:String,limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:userId,completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
                
                if res.results?.count ?? 0 > 0 {
                    self?.LiveStreamingResultsdata = res.results ?? []
           
                    self?.videoCollection.reloadData()
                } else {
                    self?.getStreamingVideos(limit: 30, page: 1, categories: [])
                }
        


            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
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

            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func unfollowStore(storeId:String){
        APIServices.unfollowstore(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
             
              print(res)
            case .failure(let error):
                print(error)
                
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
        }
    } 
    
    private func followStore(storeId:String,web:Bool){
        APIServices.followStore(storeId: storeId, web: web){[weak self] data in
            switch data{
            case .success(let res):
                self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
                self?.isFollow = true
              print(res)
            case .failure(let error):
                print(error)
                
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
                }            }
        }
    } 
    
    private func followcheck(storeId:String){
        APIServices.followcheck(storeId: storeId){[weak self] data in
            switch data{
            case .success(let res):
                if(res == "OK"){
                    self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = true
                }else{
                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
                    self?.isFollow = false
                }
            case .failure(let error):
                print(error)
                
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
        }
    }


    @IBAction func followBtnTapped(_ sender: Any) {
        if(isFollow){
            unfollowStore(storeId: self.storeId)
        }else{
            followStore(storeId: self.storeId, web: true)
        }
    }
    
    @IBAction func callIconBtnTapped(_ sender: Any) {
        
        AppDefault.brandname = brandName ?? ""
        
        let vc = AddtocartPopup.getVC(.sidemenu)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.centerTransitioningDelegate
        vc.img = "video-call"
        vc.titleText = "Video Call"
        vc.messageText = "This is a video call, would you like to continue?"
        vc.leftBtnText = "Cancel"
        vc.rightBtnText = "Yes, Continue"
        vc.iscomefor = "video"
        vc.prductid = self.prductid ?? ""
        self.present(vc, animated: true, completion: nil)
        
        }
    
    @IBAction func shareBtn(_ sender: Any) {
        showShareSheet(id:"")
    }
    
    func showShareSheet(id:String) {
        print(id)
        guard let url = URL(string: "https://stage.bazaarghar.com/product/\(id)") else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // On iPad, provide a sourceView and sourceRect to display the share sheet as a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = sender.frame
        }

        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
}
extension New_StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        }else {
            return self.getAllProductsByCategoriesData.count
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
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            cell.productname.text =  data.productName
            cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                let currencySymbol = appDelegate.currencylabel
                let salePrice = Utility().formatNumberWithCommas(data.salePrice ?? 0)

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
        }
    }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data =  self.getAllProductsByCategoriesData[sender.tag]

        let vc = CartPopupViewController.getVC(.main)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
//        vc.products = data
        self.present(vc, animated: true, completion: nil)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == videoCollection{
            
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.sidemenu)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            
            let vc = ProductDetail_VC.getVC(.main)
            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == videoCollection {
           return CGSize(width: collectionView.frame.size.width/2.1, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.width/2.12-2, height: 290)

        }
    }
}
        
extension New_StoreVC: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
    if pagerView == self.pagerView {
        if self.gallaryImages?.count ?? 0 > 0 {
            return gallaryImages?.count ?? 0
        }else {
            return  bannerapidata?.count ?? 0

        }

    } else {
        return  bannerapidata?.count ?? 0

    }
   }

   func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
       if pagerView == self.pagerView {
           let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
           if self.gallaryImages?.count ?? 0 > 0 {
               let data = gallaryImages?[index]
               cell.imageView?.pLoadImage(url: data ?? "")
               cell.imageView?.contentMode = .scaleAspectFill
           }else {
               let data = bannerapidata?[index]
               cell.imageView?.pLoadImage(url: data?.image ?? "")
               cell.imageView?.contentMode = .scaleAspectFill
           }
 
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
     
     
//     func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//         if pagerView == self.pagerView {
//             let data = self.bannerapidata?[index]
//             if data?.type == "" || data?.type == nil {
//                 
//             }else {
//                 switch data?.type {
//                     
//                   case "Market":
//                     let vc = StoreSearchVC.getVC(.main)
//                     vc.isMarket = true
//                     vc.marketID = data?.linkId
//                     vc.isNavBar = false
//                     self.navigationController?.pushViewController(vc, animated: false)
//
//                   case "Store":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = Category_ProductsVC.getVC(.main)
//                         vc.prductid = data?.linkId ?? ""
//                         vc.catNameTitle = data?.name ?? ""
//                         vc.storeFlag = true
//                     
//                         vc.storeId = data?.linkId ?? ""
//                         vc.video_section = true
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//
//                   case "Category":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = Category_ProductsVC.getVC(.main)
//                         vc.prductid = data?.linkId ?? ""
//                         vc.video_section = false
//                         vc.storeFlag = false
//                         vc.catNameTitle = data?.name ?? ""
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//                     
//                   case "Product":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = ProductDetail_VC.getVC(.main)
//                         vc.isGroupBuy = false
//                         vc.slugid = data?.linkId
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//                     
//                   case "Video":
//                     let vc = Live_VC.getVC(.main)
//                     self.navigationController?.pushViewController(vc, animated: false)
//                     
//                   case "Page":
//                     print("page")
//                       let vc = Page_Vc.getVC(.main)
//                     vc.collectionId = data?.linkId ?? ""
//                       self.navigationController?.pushViewController(vc, animated: false)
//
//                   default:
//                         print("Invalid data")
//                 }
//             }
//         }else {
//             let data = self.bannerapidata?[index]
//             if data?.type == "" || data?.type == nil {
//                 
//             }else {
//                 switch data?.type {
//                     
//                   case "Market":
//                     let vc = StoreSearchVC.getVC(.main)
//                     vc.isMarket = true
//                     vc.marketID = data?.linkId
//                     vc.isNavBar = false
//                     self.navigationController?.pushViewController(vc, animated: false)
//
//                   case "Store":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = Category_ProductsVC.getVC(.main)
//                         vc.prductid = data?.linkId ?? ""
//                         vc.catNameTitle = data?.name ?? ""
//                         vc.storeFlag = true
//                     
//                         vc.storeId = data?.linkId ?? ""
//                         vc.video_section = true
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//
//                   case "Category":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = Category_ProductsVC.getVC(.main)
//                         vc.prductid = data?.linkId ?? ""
//                         vc.video_section = false
//                         vc.storeFlag = false
//                         vc.catNameTitle = data?.name ?? ""
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//                     
//                   case "Product":
//                     if data?.linkId == "" || data?.linkId == nil {
//                         
//                     }else {
//                         let vc = ProductDetail_VC.getVC(.main)
//                         vc.isGroupBuy = false
//                         vc.slugid = data?.linkId
//                         self.navigationController?.pushViewController(vc, animated: false)
//                     }
//                     
//                   case "Video":
//                     let vc = Live_VC.getVC(.main)
//                     self.navigationController?.pushViewController(vc, animated: false)
//                     
//                   case "Page":
//                     print("page")
//                       let vc = Page_Vc.getVC(.main)
//                     vc.collectionId = data?.linkId ?? ""
//                       self.navigationController?.pushViewController(vc, animated: false)
//
//                   default:
//                         print("Invalid data")
//                 }
//             }
//         }
     

//     }
}
extension New_StoreVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            // If user scrolls to the bottom
            if offsetY > contentHeight - height {
                // Call your function to load more products
                loadMoreProducts()
            }
        
    }
    
    func loadMoreProducts() {
        guard !isLoadingNextPage && !isEndReached else {
            return // Return if already loading next page or end is reached
        }
        
        isLoadingNextPage = true
        
        // Call your API to fetch more products
        update(count: categoryPage)
    }
}
