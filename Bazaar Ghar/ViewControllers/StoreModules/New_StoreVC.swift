//
//  New_StoreVC.swift
//  Bazaar Ghar
//
//  Created by Zany on 02/07/2024.
//

import UIKit
import FSPagerView
import SocketIO
import SwiftyJSON

class New_StoreVC: UIViewController {
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var HeaderbrandNameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var brandNameLbl: UILabel!
    var productcategoriesdetailsdata : getSellerDetailDataModel?
    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollheight: NSLayoutConstraint!

    @IBOutlet weak var storeproductquantity: UILabel!
    @IBOutlet weak var shopbycategorieslbl: UILabel!
    @IBOutlet weak var shopbycat_collectionview: UICollectionView!

    @IBOutlet weak var latestproductlbl: UILabel!
    
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shopByCatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var shopByCatView: UIView!
    var messages: [PMsg]? = nil{
        didSet{
           
     
        }
    }
    var counter =  0

    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var latestProductModel: [PChat] = []
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var prductid:String?
    var brandName:String?
    var gallaryImages:[String]?
    var isFollow = false
    var storeId = String()
    var productCount:String?
    var getAllProductsByCategoriesData: [Product] = []
    var categoryPage = 1
    var isLoadingNextPage = false
    var isEndReached = false
    var manager:SocketManager?
    var socket: SocketIOClient?
    var sellerID:String? {
        didSet {
            getSellerDetail(id: sellerID ?? "")
        }
    }
    var CategoriesResponsedata: [CategoriesResponse] = []
    var catId:String? {
        didSet {
           categoriesApi(isbackground: false, id: catId ?? "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        setupCollectionView()
        Utility().setGradientBackground(view: headerBackgroudView, colors: [primaryColor, primaryColor, headerSecondaryColor])
        HeaderbrandNameLbl.text = brandName ?? ""
        brandNameLbl.text = brandName ?? ""
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        getStreamingVideos(userId: prductid ?? "", limit: 10, page: 1, categories: [])
        randomproduct(cat: "65e82aa5067e0d3f4c5f774e", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
        followcheck(storeId: self.storeId)
        update(count: 1)
        let attributedText =  Utility().attributedStringWithColoredLastWord("Shop By Categories", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
                shopbycategorieslbl.attributedText = attributedText
        
        let attributedText1 =  Utility().attributedStringWithColoredLastWord("Latest Products", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
        latestproductlbl.attributedText = attributedText1
        shopbycat_collectionview.dataSource = self
        shopbycat_collectionview.delegate = self
        
        CategoriesResponsedata.removeAll()
        self.shopByCatViewHeight.constant = 0
        shopByCatView.isHidden = true
        // Do any additional setup after loading the view.
    }
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        categoryproduct_collectionview.delegate = self
        categoryproduct_collectionview.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if(AppDefault.islogin){
            self.connectSocket()
            if AppDefault.wishlistproduct != nil{
                wishList(isbackground: true)
            }else{
                wishList(isbackground: false)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
     
    }
    func update(count:Int) {
        getAllProductsByCategories(limit: 20, page: count, sortBy:"-price", category:prductid ?? "", active: false)
    }
    
    private func getSellerDetail(id:String){
        APIServices.getSellerDetail(id:id,completion: {[weak self] data in
            switch data{
            case .success(let res):
           //
                self?.productcategoriesdetailsdata = res
                self?.gallaryImages = res.images
               
                self?.pageControl.numberOfPages = self?.gallaryImages?.count ?? 0
                self?.pageControl.currentPage = 0
                
                self?.pagerView.reloadData()
                
                for i in res.categories ?? [] {
                    self?.catId = i
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories2(isbackground:isbackground, id: id,completion: {[weak self] data in
            switch data {
            case .success(let res):
                    self?.shopByCatViewHeight.constant = 220
                self?.shopByCatView.isHidden = false
                self?.CategoriesResponsedata.append(res)
                self?.shopbycat_collectionview.reloadData()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    

    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                     
                    self?.storeproductquantity.text = "\(res.totalResults ?? 0) Products"
                    // Increment the page numbe
                    self?.categoryPage += 1
                    
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    
                    let ll = (Utility().makeOddNumberEven(self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 290
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
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                
                if res.results?.count ?? 0 > 0 {
                    self?.videoViewHeight.constant = 300
                    self?.videoView.isHidden = false
                }else {
                    self?.videoViewHeight.constant = 0
                    self?.videoView.isHidden = true
                }
        
                self?.LiveStreamingResultsdata = res.results ?? []
       
                self?.videoCollection.reloadData()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    private func getStreamingVideos(userId:String,limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:userId, city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                if res.results?.count ?? 0 > 0 {
                    self?.videoViewHeight.constant = 300
                    self?.LiveStreamingResultsdata = res.results ?? []
           
                    self?.videoCollection.reloadData()
                } else {
                    self?.videoViewHeight.constant = 0
//                    self?.getStreamingVideos(limit: 30, page: 1, categories: [])
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
               //

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
             
             //
            case .failure(let error):
                print(error)
                
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
             //
            case .failure(let error):
                print(error)
                
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
//                          let vc = PopupLoginVc.getVC(.popups)
//                        vc.modalPresentationStyle = .overFullScreen
//                        self?.present(vc, animated: true, completion: nil)
                    }
                }else if(error == "Please authenticate" && AppDefault.islogin == false){
//                      let vc = PopupLoginVc.getVC(.popups)
//                    vc.modalPresentationStyle = .overFullScreen
//                    self?.present(vc, animated: true, completion: nil)
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
    
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
   
            self?.categoryproduct_collectionview.reloadData()
          case .failure(let error):
            print(error)
          }
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
              self?.wishList(isbackground: false)
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


    @IBAction func followBtnTapped(_ sender: Any) {
        if(isFollow){
            unfollowStore(storeId: self.storeId)
        }else{
            followStore(storeId: self.storeId, web: true)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        appDelegate.isbutton = false
    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func callIconBtnTapped(_ sender: Any) {
        
        AppDefault.brandname = brandName ?? ""
        if AppDefault.islogin == true {
            let vc = AddtocartPopup.getVC(.popups)
             vc.modalPresentationStyle = .custom
             vc.transitioningDelegate = self.centerTransitioningDelegate
             vc.img = "video-call"
             vc.titleText = "Video Call"
             vc.messageText = "This is a video call, would you like to continue?"
             vc.leftBtnText = "Cancel"
             vc.rightBtnText = "Yes, Continue"
             vc.iscomefor = "video"
             vc.prductid = self.sellerID ?? ""
             self.present(vc, animated: true, completion: nil)
        }else {
            let vc = PopupLoginVc.getVC(.popups)
          vc.modalPresentationStyle = .overFullScreen
          self.present(vc, animated: true, completion: nil)
        }
  
        
        }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        showShareSheet(id:"")
    }
    @IBAction func chatButtonTapped(_ sender: Any) {
                if !AppDefault.islogin {
                        let vc = PopupLoginVc.getVC(.popups)
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        guard let sellerId = productcategoriesdetailsdata?.seller else {
                            print("Seller ID not found")
                            return
                        }

                        // Check if there's an existing chat with this seller
                        if let existingMessage = messages?.first(where: { $0.idarray?.sellerId == sellerId }) {
                            // Existing chat found, join the room
                            self.socket?.emit("room-join", [
                                "brandName": existingMessage.idarray?.brandName ?? "",
                                "customerId": AppDefault.currentUser?.id ?? "",
                                "isSeller": false,
                                "sellerId": sellerId,
                                "storeId": existingMessage.idarray?.storeId ?? "",
                                "options": ["page": 1, "limit": 200]
                            ])

                            self.socket?.on("room-join") { datas, ack in
                                if let rooms = datas[0] as? [String: Any] {
                                    let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                                    print(obj)

                                    let vc = ChatViewController.getVC(.chatBoard)
                                    vc.socket = self.socket
                                    vc.manager = self.manager
                                    vc.messages = existingMessage
                                    vc.latestMessages = obj.messages.chat
                                    vc.PuserMainArray = obj
                                    vc.newChat = false
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            // No existing chat, create a new chat
                            self.socket?.emit("room-join", [
                                "brandName": productcategoriesdetailsdata?.brandName ?? "",
                                "customerId": AppDefault.currentUser?.id ?? "",
                                "isSeller": false,
                                "sellerId": sellerId,
                                "storeId": productcategoriesdetailsdata?.id ?? ""
                            ])

                            self.socket?.on("room-join") { datas, ack in
                                if let rooms = datas[0] as? [String: Any] {
                                    let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                                    print(obj)

                                    let vc = ChatViewController.getVC(.chatBoard)
                                    vc.socket = self.socket
                                    vc.manager = self.manager
                                    vc.messages = nil
                                    vc.latestMessages = nil
                                    vc.PuserMainArray = obj
                                    vc.newChat = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
    }
    
    @IBAction func cartbtnTapped(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
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
    
    @IBAction func videoArrowBtnTapped(_ sender: Any) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
//        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
//        vc.indexValue = 0
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
extension New_StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        }else if collectionView == shopbycat_collectionview{
            return CategoriesResponsedata.count
        } else {
            return self.getAllProductsByCategoriesData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)  "
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        }else if collectionView == shopbycat_collectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopbycat_CollectionViewCell", for: indexPath) as! shopbycat_CollectionViewCell
            let data = CategoriesResponsedata[indexPath.row]
            cell.shop_img.pLoadImage(url: data.mainImage ?? "")
            cell.lbl.text = data.name
            Utility().setGradientBackground(view: cell.BGView, colors: [primaryColor, primaryColor, headerSecondaryColor])
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: [primaryColor, primaryColor, headerSecondaryColor])

            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.productname.text = data.lang?.ar?.productName
            }else{
                cell.productname.text =  data.productName
            }
            cell.product = data
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0))
//                cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
                Utility().applyStrikethrough(to: cell.productPrice, priceString:Utility().formatNumberWithCommas(data.regularPrice ?? 0), currencyLabel: appDelegate.currencylabel)
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0))
                cell.percentBGView.isHidden = true
             }
            
            cell.cartButton.tag = indexPath.row
            cell.heartBtn.tag = indexPath.row

            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(HeartBtnTapped(_:)), for: .touchUpInside)
            
            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data.id }) {
                      cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      cell.heartBtn.tintColor = .red
                    } else {
                      cell.backgroundColor = .white
                      cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                      cell.heartBtn.tintColor = .white
                    }
                  }
            
            
            return cell
        }
    }
    
    @objc func HeartBtnTapped(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = self.getAllProductsByCategoriesData[index]
            if item.id == nil {
                self.wishListApi(productId: (item._id ?? ""))
            }else {
                self.wishListApi(productId: (item.id ?? ""))
            }
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data =  self.getAllProductsByCategoriesData[sender.tag]
                if (data.variants?.first?.id == nil) {
                    let vc = CartPopupViewController.getVC(.popups)
                   
                    vc.modalPresentationStyle = .custom
                    vc.transitioningDelegate = centerTransitioningDelegate
                    vc.products = data
                    vc.nav = self.navigationController
                    self.present(vc, animated: true, completion: nil)
                }else {
                    let vc = NewProductPageViewController.getVC(.productStoryBoard)
                    vc.slugid = data.slug
                    navigationController?.pushViewController(vc, animated: false)
                }
          }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == videoCollection{
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == shopbycat_collectionview{
            let data = CategoriesResponsedata[indexPath.row]
            let vc = Category_ProductsVC.getVC(.productStoryBoard)
            vc.prductid = data.id ?? ""
        
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data.name ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == videoCollection {
           return CGSize(width: collectionView.frame.size.width/2.2, height: collectionView.frame.size.height)
       }else if collectionView == shopbycat_collectionview{
           return CGSize(width: collectionView.frame.width/2.7, height: 160
           )
       }else {
           return CGSize(width: collectionView.frame.width/2.05, height: 280)
        }
    }
}
        
extension New_StoreVC: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
            return gallaryImages?.count ?? 0
   }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let data = gallaryImages?[index]
        cell.imageView?.pLoadImage(url: data ?? "")
        cell.imageView?.contentMode = .scaleAspectFill
        
        return cell
    
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
//                         let vc = Category_ProductsVC.getVC(.productStoryBoard)
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
//                         let vc = Category_ProductsVC.getVC(.productStoryBoard)
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
//                         let vc = Category_ProductsVC.getVC(.productStoryBoard)
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
//                         let vc = Category_ProductsVC.getVC(.productStoryBoard)
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
extension New_StoreVC {
       func connectSocket() {
        manager = SocketManager(socketURL: AppConstants.API.baseURLChat, config: [.log(true),
                                                                                  .compress,
                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
        socket = manager?.socket(forNamespace: "/chat/v1/message")
           socket?.connect()
        
              socket?.on(clientEvent: .connect) { (data, ack) in
            
        self.socket?.emit("allUnread", ["userId":AppDefault.currentUser?.id ?? ""])
       
            print("socketid " + (self.socket?.sid ?? ""))
            print("Socket Connected")
            
            
            
        }
        
        self.socket?.on("allUnread") { data, ack in
            if let rooms = data[0] as? [[String: Any]]{
                if let rooms = data[0] as? [[String: Any]]{
                    print(rooms)
                    
                     var messageItem:[PMsg] = []
                    let Datamodel = JSON(rooms)
                    let message = Datamodel.array
                    
                    for item in message ?? []{
                        
                        messageItem.append(PMsg(jsonData: item))
                    }
                    
                    print(messageItem)
                    
                    self.messages = messageItem
                    
                    
                }
            }
              self.socket?.on(clientEvent: .disconnect) { data, ack in
                // Handle the disconnection event
                print("Socket disconnected")
            }
            }
        
    }
    
}
