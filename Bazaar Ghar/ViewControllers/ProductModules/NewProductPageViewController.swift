//
//  NewProductPageViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 08/07/2024.
//

import UIKit
import FSPagerView
import SocketIO
import SwiftyJSON

class NewProductPageViewController: UIViewController, UIScrollViewDelegate {
    
  
    var manager:SocketManager?
      var socket: SocketIOClient?
    @IBOutlet weak var producttitle: UILabel!
    @IBOutlet weak var deliveryTableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var storeimg: UIImageView!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var productcount: UILabel!
    @IBOutlet weak var Salesprice: UILabel!
//    @IBOutlet weak var OnSaleimage: UIImageView!
    @IBOutlet weak var Regularprice: UILabel!
    @IBOutlet weak var productPriceLine: UIView!
    @IBOutlet weak var plusbtn: UIButton!
    @IBOutlet weak var outOfStockLbl: UILabel!
    @IBOutlet weak var quantityView: UIView!

    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var Minusbtn: UIButton!
    @IBOutlet weak var moreFromLbl: UILabel!
    @IBOutlet weak var moreFrom: UICollectionView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var relatedProductView: UIView!
    @IBOutlet weak var relatedVideoView: UIView!

    @IBOutlet weak var relatedProductViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var relatedVideoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var DescriptionProduct: UILabel!
    @IBOutlet weak var moreFromViewHeight: NSLayoutConstraint!
    @IBOutlet weak var varientsTblV: UITableView!
    @IBOutlet weak var varientViewHeight: NSLayoutConstraint!

    @IBOutlet weak var minusview: UIView!
    @IBOutlet weak var cartBtnImg: UIButton!
    @IBOutlet weak var cartBtnLbl: UILabel!
    @IBOutlet weak var cartBtnView: UIView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var percentView: UIView!
    @IBOutlet weak var showMoreBtn: UIButton!
    @IBOutlet weak var pageControl: FSPageControl!

    var productCount = 1
    var incrementproductCount = 1
    var productcategoriesdetailsdata : ProductCategoriesDetailsResponse?
    var colorsimgs = [String]()
    var isnav = false
    var nav : UINavigationController? {
        didSet {
            isnav = true
        }
    }
    var messages: [PMsg]? = nil{
        didSet{
        }
      }
    var tabbar = false
    var iscome = Bool()
    var items: [Item] = [
            Item(image: UIImage(named: "truck")!, title: "Receive by 29 Jun - 6 Jul",subtitle: "Get the order in 3 - 5 days"),
            Item(image: UIImage(named: "d 1")!, title: "Cash On Delivery",subtitle: "Cash on Delivery available"),
            Item(image: UIImage(named: "d 2")!, title: "Seven Days Return",subtitle: "Return your order in seven days"),
            Item(image: UIImage(named: "d 3")!, title: "Warranty Available",subtitle: "Get warranty on our products"),
            // Add more items as needed
        ]

    var bannerapidata: [Banner]? = [] {
        didSet{
            self.pagerView.reloadData()

        }
    }
    var slugid: String? {
        didSet {
            productcategoriesdetails(slug: slugid ?? "")
        }
    }
    var gallaryImages: [String]?
    var mainImage: String?
    var orderDetails: CartItemsResponse?
    var varientSlug : String?
    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var moreFromResponse: moreFomDataClass?
    var category:String?
    var relatedProductResponse: [Product] = []
    var LiveStreamingResultsdata: [LiveStreamingResults] = []


    var isTextExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        showMoreBtn.setTitle("Show More", for: .normal)
        showMoreBtn.addTarget(self, action: #selector(toggleDescription), for: .touchUpInside)
        buyNowBtn.alpha = 1.0 // Set the alpha to 1.0 to avoid the grayed-out appearance
        buyNowBtn.setTitleColor(.white, for: .disabled)
        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
        if iscome{
              self.dismiss(animated: true)
            }
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        Utility().setGradientBackground(view: headerBackgroudView, colors: [primaryColor, primaryColor, headerSecondaryColor])
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        bannerApi(isbackground: false)
        colorsimgs = ["colosimg","colosimg","colosimg"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("variantSlug"), object: nil)
        setupCollectionView()
    
    }
    
    @objc func toggleDescription() {
         isTextExpanded.toggle()
         
         // Toggle number of lines and button title
         DescriptionProduct.numberOfLines = isTextExpanded ? 0 : 2
        showMoreBtn.setTitle(isTextExpanded ? "Show Less" : "Show More", for: .normal)
     }
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        moreFrom.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        moreFrom.delegate = self
        moreFrom.dataSource  = self
        relatedProductCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        relatedProductCollectionView.delegate = self
        relatedProductCollectionView.dataSource  = self

    }
    
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
    if let slug = notification.userInfo?["variantSlug"] as? String {
            productcategoriesdetails(slug: slug)
                varientSlug = slug
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishList()
        if(AppDefault.islogin){
            self.connectSocket()
        }
    }
    func wishList(){
        APIServices.wishlist(isbackground: false){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
              if let wishlistProducts = AppDefault.wishlistproduct {
                  if wishlistProducts.contains(where: { $0.id == self?.productcategoriesdetailsdata?.welcomeID }) {
                      self?.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      self?.heartBtn.tintColor = .red
                      } else {
                          self?.heartBtn.setImage(UIImage(named: "shareIcon"), for: .normal)
                          self?.heartBtn.tintColor = UIColor(hex: primaryColor)
                      }
                    }
              self?.relatedProductCollectionView.reloadData()
              self?.moreFrom.reloadData()
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
    //        self?.view.makeToast(error)
          }
        })
      }
    
    
    @IBAction func chatButton(_ sender: Any) {
        if(!AppDefault.islogin){
            let vc = PopupLoginVc.getVC(.popups)
          vc.modalPresentationStyle = .overFullScreen
          self.present(vc, animated: true, completion: nil)
        }else{
         
            if ((messages?.contains(where: {$0.idarray?.sellerId == productcategoriesdetailsdata?.sellerDetail?.seller})) != nil){
                
               
                var i:PMsg? = nil
                i = messages?.first(where: { $0.idarray?.sellerId == productcategoriesdetailsdata?.sellerDetail?.seller })
                
                
                self.socket?.emit("room-join", ["brandName": i?.idarray?.brandName ?? "",
                                                "customerId": AppDefault.currentUser?.id ?? "",
                                                "isSeller": false,
                                                "sellerId": i?.idarray?.sellerId ?? "",
                                                "storeId": i?.idarray?.storeId ?? "",
                                                "options": ["page": 1, "limit": 200]])
                
                self.socket?.on("room-join") { datas, ack in
                    if let rooms = datas[0] as? [String: Any] {
                        let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                        print(obj)
                        
                        let vc = ChatViewController.getVC(.chatBoard)
                        vc.socket = self.socket
                        vc.manager = self.manager
                        vc.messages = i
                        vc.latestMessages = obj.messages.chat
                        vc.PuserMainArray = obj
                        vc.newChat = false
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                }
            }else{
                self.socket?.emit("room-join", ["brandName": productcategoriesdetailsdata?.sellerDetail?.brandName ?? "",
                                                "customerId": AppDefault.currentUser?.id ?? "",
                                                "isSeller": false,
                                                "sellerId": productcategoriesdetailsdata?.sellerDetail?.seller ?? "",
                                                "storeId": productcategoriesdetailsdata?.sellerDetail?.id ?? "",
                                                "options": ["page": 1, "limit": 200]])
                
                self.socket?.on("room-join") { datas, ack in
                    if let rooms = datas[0] as? [String: Any] {
                        let obj = PuserMainModel(jsonData: JSON(rawValue: rooms)!)
                        print(obj)
                        
                        let vc = ChatViewController.getVC(.chatBoard)
                        vc.socket = self.socket
                        vc.manager = self.manager
                        vc.messages = nil
                        vc.latestMessages = obj.messages.chat
                        vc.PuserMainArray = obj
                        vc.newChat = false
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                   
                }
            }
  
        }

       
    }
    @IBAction func heartBtnTapped(_ sender: Any) {
        if(AppDefault.islogin){
            if productcategoriesdetailsdata?.id == nil {
                self.wishListApi(productId: (productcategoriesdetailsdata?.id ?? ""))
            }else {
                self.wishListApi(productId: (productcategoriesdetailsdata?.welcomeID ?? ""))
            }
            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }
    }
    @IBAction func chatBtnTapped(_ sender: Any) {
     
    }
    
    @IBAction func viewstorebtn(_ sender: Any) {
        let vc = New_StoreVC.getVC(.productStoryBoard)
        vc.prductid = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
        vc.brandName = productcategoriesdetailsdata?.sellerDetail?.brandName ?? ""
        vc.storeId = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
        vc.sellerID = productcategoriesdetailsdata?.sellerDetail?.seller
        vc.productcategoriesdetailsdata = productcategoriesdetailsdata
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func sharebtn(_ sender: Any) {
        showShareSheet(id:productcategoriesdetailsdata?.slug ?? "")
    }
    func showShareSheet(id:String) {
        print(id)
        guard let url = URL(string: "https://d.bazaarghar.com/product/\(id)") else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // On iPad, provide a sourceView and sourceRect to display the share sheet as a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = sender.frame
        }

        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
 
    
    @IBAction func cartBtn(_ sender: Any) {
//        let vc = CartViewController.getVC(.main)
//        if self.isnav == true{
//            self.dismiss(animated: false)
//            self.nav?.pushViewController(vc, animated: true)
//        }
//        self.navigationController?.pushViewController(vc, animated: false)
        self.addToCartApi(product:self.productcategoriesdetailsdata?.id ?? "",quantity:1,navigation: false)

        
        }
    @IBAction func whatsappShareText(_ sender: AnyObject) {
        let message = "First Whatsapp Share & https://www.google.co.in"
        var queryCharSet = NSCharacterSet.urlQueryAllowed
        
        queryCharSet.remove(charactersIn: "+&")
        
        if let escapedString = message.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let whatsappURL = URL(string: "whatsapp://send?phone=" + "923011166879" + "&text=") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [: ], completionHandler: nil)
                } else {
                    debugPrint("please install WhatsApp")
                    self.view.makeToast("whatsapp not available")
                }
            }
        }
        
    }
    @IBAction func buyNowBtnTapped(_ sender: Any) {
        
        addToCartApi(product:productcategoriesdetailsdata?.id ?? "",quantity:incrementproductCount,navigation: true)
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        appDelegate.isbutton = false
    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func relatedProductApi(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategories(limit:limit,page:page,sortBy:sortBy,category:category,active:active){[weak self] data in
            switch data{
            case .success(let res):
                self?.relatedProductResponse = res.Categoriesdata ?? []
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.relatedProductView.isHidden = false
                    self?.relatedProductViewHeight.constant = 325
                    self?.scrollHeight.constant = (self?.scrollHeight.constant ?? 0) + 325
//                    self?.relatedProductView.isHidden = false
//                    if self?.isGroupBuy == true {
//                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 320
//                    }else {
//                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 280
//                    }
                }else {
                    self?.relatedProductView.isHidden = true
                    self?.relatedProductViewHeight.constant = 0
                    self?.scrollHeight.constant = 2200 + (self?.varientViewHeight.constant ?? 0)

                }
                
//                self?.scrollHeight.constant = self?.scrollHeight.constant ?? 0 + (self?.relatedProductViewHeight.constant ?? 0)

                
                self?.relatedProductCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addToCartApi(product: String, quantity: Int,navigation:Bool){
        APIServices.additemtocart(product:product,quantity:quantity,completion: {[weak self] data in
            switch data{
            case .success(let res):
                if(navigation) {
                    let vc = CartViewController.getVC(.main)
                    vc.iccomeformProduct = true
                    self?.navigationController?.pushViewController(vc, animated: false)
//                    self?.getCartProducts()
                } else {
                    
                    let vc = AddtocartPopup.getVC(.popups)
                    vc.modalPresentationStyle = .custom
                    vc.transitioningDelegate = self?.centerTransitioningDelegate
                    vc.img = "addtocart"
                    vc.titleText = "Added to Cart!"
                    vc.messageText = "Successfully added null to your cart"
                    vc.leftBtnText = "Continue Shopping"
                    vc.rightBtnText = "Go to Cart"
                    vc.iscomefor = "cart"
                    vc.nav = self?.navigationController
                    vc.prductid = self?.productcategoriesdetailsdata?.id ?? ""
                    self?.present(vc, animated: true, completion: nil)
                }
                
                
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
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
                    if self?.varientSlug != nil {
                        print(error)
                        self?.view.makeToast(error)
                    }else {
                        self?.view.makeToast("Please Select Varient")
                    }
                }
                
            }
        })
    }
    
    private func moreFrom(category: String, user: String){
        APIServices.moreFrom(category: category, user: user,completion: {[weak self] data in
            switch data{
            case .success(let res):
            //
                self?.moreFromResponse = res
                if res.results?.count ?? 0 > 2 {
                    self?.moreFromViewHeight.constant = 620
                }else {
                    self?.moreFromViewHeight.constant = 350
                    self?.scrollHeight.constant = (self?.scrollHeight.constant ?? 0) - 250

                }
                self?.moreFrom.reloadData()
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
//                    appDelegate.GotoDashBoard(ischecklogin: true)
                }
                else{
                    if self?.varientSlug != nil {
                        print(error)
                        self?.view.makeToast(error)
                    }else {
                        self?.view.makeToast("Please Select Varient")
                    }
                }
                
            }
        })
    }
    
    private func getCartProducts(){
        APIServices.getCartItems(){[weak self] data in
            switch data{
            case .success(let res):
             
                AppDefault.cartId =  res.id
            
                AppDefault.currentUser?.defaultAddress = res.user?.defaultAddress
                self?.orderDetails = res
                
                
                let vc = NewOrderConfirmation_ViewController.getVC(.orderJourneyStoryBoard)
                vc.orderDetails =  self?.orderDetails
                if self?.isnav == true{
                    self?.dismiss(animated: false)
                    self?.nav?.pushViewController(vc, animated: true)
                }
                self?.navigationController?.pushViewController(vc, animated: true)
//                    self?.bannerapidata = res.packages ?? []
//                if(self?.bannerapidata.count ?? 0 > 0){
//                    self?.emptyCart.isHidden = true
//                }else{
//                    self?.emptyCart.isHidden = false
//
//                }

//                self?.subTotal.text = Utility().convertAmountInComma("\(res.subTotal ?? 0)")
//                self?.total.text = Utility().convertAmountInComma("\(res.total ?? 0)")
//
//                self?.cartTableViewCell.reloadData()
            
            
            case .failure(let error):
                print(error)
//                self?.emptyCart.isHidden = false
                if(error == "Please authenticate" && AppDefault.islogin){
                        appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                 }else{
                        self?.view.makeToast(error)
                 }
            }
        }
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
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
               //

                self?.LiveStreamingResultsdata = res.results ?? []
                if res.results?.count ?? 0 > 0 {
                    self?.relatedVideoView.isHidden = false
                    self?.relatedVideoViewHeight.constant = 325
                   self?.scrollHeight.constant = (self?.scrollHeight.constant ?? 0) + 325

//                    if self?.isGroupBuy == true {
//                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 290
//                    }else {
//                        self?.scrollheight.constant = (self?.scrollheight.constant ?? 0) + 250
//                    }

                }else {
                    self?.relatedVideoView.isHidden = true
                    self?.relatedVideoViewHeight.constant = 0
                }
                
//                self?.scrollHeight.constant = self?.scrollHeight.constant ?? 0 + (self?.relatedVideoViewHeight.constant ?? 0)


                self?.videoCollection.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    private func productcategoriesdetails(slug:String){
        APIServices.productcategoriesdetails(slug: slug){[weak self] data in
            switch data{
            case .success(let res):
             //

                self?.productcategoriesdetailsdata = res

                
                if res.attributes?.count == 0 {
                        self?.varientViewHeight.constant = 0
                    }else {
                        self?.varientViewHeight.constant = CGFloat((res.attributes?.count ?? 0) * 90)
                    }
                
                self?.scrollHeight.constant = 2200 +  (self?.varientViewHeight.constant ?? 0)
                
                self?.headerLbl.text = res.sellerDetail?.brandName
                if res.salePrice == nil || res.salePrice == 0 {
                    self?.percentView.isHidden = true
                }else {
                    self?.percentView.isHidden = false
                }
                self?.mainImage = res.mainImage
                if(res.gallery?.count == 0){
                    self!.gallaryImages?.append(res.mainImage ?? "")
                    
                }else{
                    self?.gallaryImages  = res.gallery
                    self?.pageControl.numberOfPages = res.gallery?.count ?? 0
                    self?.pageControl.currentPage = 0
                    
                }
                
                self?.pagerView.reloadData()
                if res.regularPrice == nil || res.salePrice == nil {
                
                }else {
                    let percentValue = (((res.regularPrice ?? 0) - (res.price ?? 0)) * 100) / (res.regularPrice ?? 0)
                    self?.percentLbl.text = String(format: "%.0f%% OFF", percentValue)
                }
                
                if LanguageManager.language == "ar"{
                    self?.producttitle.text = res.lang?.ar?.productName
                }else{
                    self?.producttitle.text = res.productName
                }
                self?.storename.text = res.sellerDetail?.brandName
                if res.sellerDetail?.logo == nil {
                    self?.storeimg.image = UIImage(named: "homebazarimg")
                } else {
                    self?.storeimg.pLoadImage(url: res.sellerDetail?.logo ?? "")
                }
             self?.Regularprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.regularPrice ?? 0)
                if res.onSale == true {
                    self?.Salesprice.isHidden = false
//                    self?.OnSaleimage.isHidden = false
                    self?.Regularprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.price ?? 0)
                    self?.Salesprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.regularPrice ?? 0)
                    self?.productPriceLine.isHidden = false
                    self?.Salesprice.textColor = UIColor.red
                    self?.Regularprice.textColor = UIColor(hexString: primaryColor)
                    self?.productPriceLine.backgroundColor = UIColor.red

                }else {
//                    self?.Regularprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.regularPrice ?? 0)
                    self?.Salesprice.isHidden = true
//                    self?.OnSaleimage.isHidden = true
                    self?.productPriceLine.isHidden = true
                    self?.Regularprice.textColor = UIColor(hexString: primaryColor)
                 }

                if res.quantity ?? 0 > 0 {
                    self?.cartBtnView.backgroundColor = .white
                    self?.cartBtnLbl.textColor = UIColor(hex: primaryColor)
                    self?.cartBtnView.borderWidth = 1
                    self?.quantityView.isHidden = false
                    self?.outOfStockLbl.isHidden = true
//                    self?.buyNowBtn.isEnabled = true
                    self?.addToCartBtn.isEnabled = true
                    self?.buyNowBtn.backgroundColor = UIColor(hex: primaryColor)
                    self?.buyNowBtn.isEnabled = true
                    self?.cartBtnImg.setBackgroundImage(UIImage(named: "cartBlue"), for: .normal)
                }else {
                    self?.cartBtnView.backgroundColor = .gray
                    self?.cartBtnLbl.textColor = .white
                    self?.cartBtnView.borderWidth = 0
                    self?.quantityView.isHidden = true
                    self?.outOfStockLbl.isHidden = false
                    self?.cartBtnImg.setBackgroundImage(UIImage(named: "carticon"), for: .normal)
                    self?.addToCartBtn.isEnabled = false
                    self?.buyNowBtn.backgroundColor = .gray
                    self?.buyNowBtn.isEnabled = false
//                    self?.buyNowBtn.isEnabled = false
                }
                
                if LanguageManager.language == "ar"{
                    if res.lang?.ar?.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.lang?.ar?.description
                              }
                }else{
                    if res.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.description
                              }
                    
                }

                
//                if res.description?.isStringOrHTML() == "HTML"{
//                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                          }else{
//                              self?.DescriptionProduct.text = res.description
//                          }
                
                self?.producttitle.sizeToFit()
                let label = UILabel(frame: CGRect.zero)
                
                
                if LanguageManager.language == "ar"{
                    label.text =  res.lang?.ar?.description ?? ""
                    if res.description?.isStringOrHTML() == "HTML"{
//                        self?.DescriptionProduct.text =  res.lang?.ar?.description     //res.lang?.ar?.description?.htmlToString().withoutHtml
                        let htmlString = res.lang?.ar?.description
                        let plainText = Utility().htmlToString(text: htmlString ?? "")
                        self?.DescriptionProduct.text = Utility().htmlToString(text: plainText)
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.lang?.ar?.description
                              }
                }else{
                    label.text =  res.description ?? ""
                    if res.description?.isStringOrHTML() == "HTML"{
                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
                              }else{
                                  self?.DescriptionProduct.text = res.description
                              }
                }
                
                
                
//                label.text =  res.description ?? ""
//                if res.description?.isStringOrHTML() == "HTML"{
//                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                          }else{
//                              self?.DescriptionProduct.text = res.description
//                          }
                guard let labelText = label.text else { return }
                let height = self?.estimatedHeightOfLabel(text: labelText)
               
                
                self?.moreFromLbl.text = "More From \(res.sellerDetail?.brandName ?? "")"
                self?.moreFrom(category: res.category ?? "", user: res.sellerDetail?.seller ?? "")
                self?.relatedProductApi(limit: 20, page: 1, sortBy:"ACS", category:res.category ?? "", active: false)
                self?.getStreamingVideos(limit:20,page:1,categories: [res.category ?? ""])
                
                self?.scrollHeight.constant =  (self?.scrollHeight.constant ?? 0) + (self?.DescriptionProduct.bounds.height ?? 0)
                self?.varientsTblV.reloadData()
                
                
//                if LanguageManager.language == "ar"{
//                    self?.producttitle.text = res.lang?.ar?.productName
//                }else{
//                    self?.producttitle.text = res.productName
//                }

//                self?.producttitle.text = res.productName
                
//                if res.onSale == true {
//                    self?.Salesprice.isHidden = false
//                    self?.Salesprice.isHidden = false
//                    self?.OnSaleimage.isHidden = false
//                    self?.Salesprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.salePrice ?? 0)
//                    self?.productPriceLine.isHidden = false
//                    self?.Regularprice.textColor = UIColor.red
//                    self?.Salesprice.textColor = UIColor(hexString: primaryColor)
//                    self?.productPriceLine.backgroundColor = UIColor.red
//
//                }else {
//                    self?.Salesprice.isHidden = true
//                    self?.OnSaleimage.isHidden = true
//                    self?.productPriceLine.isHidden = true
//                    self?.Regularprice.textColor = UIColor(hexString: primaryColor)
//                 }
//                self?.ratingView.rating =    Double(res.ratings?.total ?? 0)
//                
//                self?.Regularprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.regularPrice ?? 0)
//                
//                if res.regularPrice == nil || res.salePrice == nil {
//                    
//                }else {
//                    let percentValue = (((res.regularPrice ?? 0) - (res.salePrice ?? 0)) * 100) / (res.regularPrice ?? 0)
//                    self?.percentLbl.text = String(format: "%.0f%% OFF", percentValue)
//                }
//
//                if LanguageManager.language == "ar"{
//                    if res.lang?.ar?.description?.isStringOrHTML() == "HTML"{
//                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                              }else{
//                                  self?.DescriptionProduct.text = res.lang?.ar?.description
//                              }
//                }else{
//                    if res.description?.isStringOrHTML() == "HTML"{
//                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                              }else{
//                                  self?.DescriptionProduct.text = res.description
//                              }
//                    
//                }
//
//                
////                if res.description?.isStringOrHTML() == "HTML"{
////                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
////                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
////                          }else{
////                              self?.DescriptionProduct.text = res.description
////                          }
//                
//                self?.producttitle.sizeToFit()
//                let label = UILabel(frame: CGRect.zero)
//                
//                
//                if LanguageManager.language == "ar"{
//                    label.text =  res.lang?.ar?.description ?? ""
//                    if res.description?.isStringOrHTML() == "HTML"{
////                        self?.DescriptionProduct.text =  res.lang?.ar?.description     //res.lang?.ar?.description?.htmlToString().withoutHtml
//                        let htmlString = res.lang?.ar?.description
//                        let plainText = Utility().htmlToString(text: htmlString ?? "")
//                        self?.DescriptionProduct.text = Utility().htmlToString(text: plainText)
//                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                              }else{
//                                  self?.DescriptionProduct.text = res.lang?.ar?.description
//                              }
//                }else{
//                    label.text =  res.description ?? ""
//                    if res.description?.isStringOrHTML() == "HTML"{
//                        self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
//                    //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
//                              }else{
//                                  self?.DescriptionProduct.text = res.description
//                              }
//                }
//                
//                
//                
////                label.text =  res.description ?? ""
////                if res.description?.isStringOrHTML() == "HTML"{
////                    self?.DescriptionProduct.text = res.description?.htmlToString().withoutHtml
////                //            cell.subTitle.attributedText = product?.itemDescription?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Montserrat-Regular", size: cell.subTitle.font.pointSize), csscolor: "2C3D73", lineheight: 0, csstextalign: "left")
////                          }else{
////                              self?.DescriptionProduct.text = res.description
////                          }
//                guard let labelText = label.text else { return }
//                let height = self?.estimatedHeightOfLabel(text: labelText)
//               
//                self?.productcategoriesdetailsdata = res
//                
//                if res.mainAttributes != nil {
//                    if res.mainAttributes?.count ?? 0 > 0 {
//                        self?.attributeView.isHidden = false
//                        if res.mainAttributes?.count ?? 0 > 1 {
//                            self?.attributeViewHeight.constant = CGFloat(50 * (res.mainAttributes?.count ?? 0))
//                        }
//                    }else {
//                        self?.attributeView.isHidden = true
//
//                    }
//                        let cal = res.mainAttributes?.count ?? 0
//                        let val = (cal * 70) + 580
//                        
//                    self?.scrollheight.constant = CGFloat(val) + ( self?.DescriptionProduct.bounds.height ?? 0.0) + ( self?.producttitle.bounds.height ?? 0.0)
//                }else {
//                    if res.attributes?.count ?? 0 > 0 {
//                        self?.attributeView.isHidden = false
//                        if res.attributes?.count ?? 0 > 1 {
//                            self?.attributeViewHeight.constant = CGFloat(50 * (res.attributes?.count ?? 0))
//                        }
//                    }else {
//                        self?.attributeView.isHidden = true
//
//                    }
//                        let cal = res.attributes?.count ?? 0
//                        let val = (cal * 70) + 580
//                        
//                    self?.scrollheight.constant = CGFloat(val) + ( self?.DescriptionProduct.bounds.height ?? 0.0) + ( self?.producttitle.bounds.height ?? 0.0)
//                }
//                  
//
//                self?.getAllProductsByCategories(limit: 20, page: 1, sortBy:"ACS", category:res.category ?? "", active: false)
//                self?.getStreamingVideos(limit:20,page:1,categories: [res.category ?? ""])
//
//
//                self?.setupPageControl()
//           
//                self?.ProductImgCollectionview.reloadData()
//                self?.varientsTblV.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {

        let size = CGSize(width: view.frame.width - 16, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    @IBAction func moreFromArrowBtnTapped(_ sender: Any) {
        let vc = New_StoreVC.getVC(.productStoryBoard)
        vc.prductid = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
        vc.brandName = productcategoriesdetailsdata?.sellerDetail?.brandName ?? ""
        vc.storeId = productcategoriesdetailsdata?.sellerDetail?.seller ?? ""
        vc.sellerID = productcategoriesdetailsdata?.sellerDetail?.seller
        self.navigationController?.pushViewController(vc, animated: false)
        }
    @IBAction func cartBtnTapped(_ sender: Any) {
        let vc = CartViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
        }
    @IBAction func SubtractBtn(_ sender: Any) {
        if productCount > 1 {
            productCount -= 1
            productcount.text = "\(productCount)"
        }
        if productcount.text == "1" {
           minusview.backgroundColor = .white
            Minusbtn.setTitleColor(UIColor(hex: primaryColor), for: .normal)

        }else {
            minusview.backgroundColor = UIColor(hex: primaryColor)
            Minusbtn.setTitleColor(UIColor.white, for: .normal)

        }
    }
    @IBAction func Addbtn(_ sender: Any) {
        if( productCount >= productcategoriesdetailsdata?.quantity ?? 0){
            self.view.makeToast("You can buy only \(productcategoriesdetailsdata?.quantity ?? 0) Products")
        }else if(productcategoriesdetailsdata?.quantity == 0){
            self.view.makeToast("Product is Out Of Stock")
        }else{
            productCount += 1
            incrementproductCount = productCount
            print(incrementproductCount)
            productcount.text = "\(productCount)"
        }
        if productcount.text == "1" {
            minusview.backgroundColor = .white
            Minusbtn.setTitleColor(UIColor(hex: primaryColor), for: .normal)

        }else {
            minusview.backgroundColor = UIColor(hex: primaryColor)
            Minusbtn.setTitleColor(UIColor.white, for: .normal)

        }
}

}

extension NewProductPageViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if ((gallaryImages?.isEmpty) != nil){
            return  gallaryImages?.count ?? 0
        }else {
            return 1
        }
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if ((gallaryImages?.isEmpty) != nil){
            let data = gallaryImages?[index]
            cell.imageView?.pLoadImage(url: data ?? "")
            cell.imageView?.contentMode = .scaleAspectFill
        }else {
            cell.imageView?.pLoadImage(url:self.mainImage ?? "")
            cell.imageView?.contentMode = .scaleAspectFill
        }
 
        return cell
        
        
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentIndex = pagerView.currentIndex
        pageControl.currentPage = currentIndex
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let cell = pagerView.cellForItem(at: index) else {
                   return
               }
               
        if let image = cell.imageView?.image {
                   showImagePreview(image)
               }
    }
    
    func showImagePreview(_ image: UIImage) {
           let imagePreviewVC = UIViewController()
           
           let backgroundView = UIView(frame: imagePreviewVC.view.bounds)
           backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
           imagePreviewVC.view.addSubview(backgroundView)
           
           let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
           containerView.center = imagePreviewVC.view.center
           containerView.backgroundColor = .clear
           imagePreviewVC.view.addSubview(containerView)
           
           let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
           scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           scrollView.delegate = self
           scrollView.minimumZoomScale = 1.0
           scrollView.maximumZoomScale = 5.0
           containerView.addSubview(scrollView)
           
           let imageView = UIImageView(image: image)
           imageView.contentMode = .scaleAspectFit
           imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
           scrollView.addSubview(imageView)
           
           scrollView.contentSize = imageView.frame.size
           
           // Add double-tap gesture recognizer for zooming
           let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
           doubleTapGesture.numberOfTapsRequired = 2
           scrollView.addGestureRecognizer(doubleTapGesture)
           
           imageView.isUserInteractionEnabled = true
           
//           let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeImagePreview))
//           imagePreviewVC.navigationItem.rightBarButtonItem = closeButton
//           imagePreviewVC.navigationItem.rightBarButtonItem?.tintColor = .white
           
           let tap = UITapGestureRecognizer(target: self, action: #selector(closeImagePreview))
           backgroundView.addGestureRecognizer(tap)
           
           let navController = UINavigationController(rootViewController: imagePreviewVC)
           navController.modalPresentationStyle = .overFullScreen
           present(navController, animated: true, completion: nil)
       }
       
       @objc func handleDoubleTapGesture(_ sender: UITapGestureRecognizer) {
           guard let scrollView = sender.view?.superview as? UIScrollView else { return }
           
           if scrollView.zoomScale == scrollView.minimumZoomScale {
               let tapPoint = sender.location(in: sender.view)
               let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: tapPoint, in: scrollView)
               scrollView.zoom(to: zoomRect, animated: true)
           } else {
               scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
           }
       }
       
       func zoomRectForScale(scale: CGFloat, center: CGPoint, in scrollView: UIScrollView) -> CGRect {
           var zoomRect = CGRect()
           let size = CGSize(
               width: scrollView.frame.size.width / scale,
               height: scrollView.frame.size.height / scale
           )
           
           zoomRect.size = size
           zoomRect.origin = CGPoint(
               x: center.x - (size.width / 2.0),
               y: center.y - (size.height / 2.0)
           )
           
           return zoomRect
       }
       
       func viewForZooming(in scrollView: UIScrollView) -> UIView? {
           return scrollView.subviews.first(where: { $0 is UIImageView })
       }
       
       @objc func closeImagePreview() {
           dismiss(animated: true, completion: nil)
       }
    
}




extension NewProductPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == varientsTblV {
            if productcategoriesdetailsdata?.mainAttributes != nil {
                return  productcategoriesdetailsdata?.mainAttributes?.count ?? 0
            }else {
                return  productcategoriesdetailsdata?.attributes?.count ?? 0
            }
        }else {
            return items.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == varientsTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailVarientTableViewCell", for: indexPath) as! ProductDetailVarientTableViewCell
            if productcategoriesdetailsdata?.mainAttributes != nil {
                let data = productcategoriesdetailsdata?.mainAttributes
                let variantdata = productcategoriesdetailsdata?.variants
                cell.attributesLbl.text = (data?[indexPath.row].name ?? "") + " (\(data?[indexPath.row].values?.count ?? 0))"
                cell.index = indexPath.row
                cell.productcategoriesdetailsdata = data
                cell.productcategoriesdetailsvariantdata = variantdata
            }else {
                let data = productcategoriesdetailsdata?.attributes
                let variantdata = productcategoriesdetailsdata?.variants
                cell.attributesLbl.text = (data?[indexPath.row].name ?? "") + " (\(data?[indexPath.row].values?.count ?? 0))"
                cell.index = indexPath.row
                cell.productcategoriesdetailsdata = data
                cell.productcategoriesdetailsvariantdata = variantdata
            }

            return cell
        }else {
            let data  = items[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDellivevryTableViewCell", for: indexPath) as! ProductDetailsDellivevryTableViewCell
            cell.img.image = data.image
            cell.title.text = data.title
            cell.subtitle.text = data.subtitle
      
                return cell
        }
           
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == varientsTblV {
            return 70
        }else {
            return 67
        }
    }
}
struct Item {
    let image: UIImage
    let title: String
    let subtitle: String
}


extension NewProductPageViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == relatedProductCollectionView {
            return self.relatedProductResponse.count

        }else if collectionView == videoCollection {
            return self.LiveStreamingResultsdata.count
        }else {
            return moreFromResponse?.results?.count ?? 0

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == relatedProductCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.relatedProductResponse[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: [primaryColor, primaryColor, headerSecondaryColor])
            cell.product = data
            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.productname.text = data.lang?.ar?.productName
            }else{
                cell.productname.text =  data.productName
            }

            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0))
                cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(relatedProductcartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(relatedProductHeartButtonTap(_:)), for: .touchUpInside)

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

        }else if collectionView == videoCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0) views  "
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = moreFromResponse?.results?[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: [primaryColor, primaryColor, headerSecondaryColor])
            cell.product = data
            cell.productimage.pLoadImage(url: data?.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.productname.text = data?.lang?.ar?.productName
            }else{
                cell.productname.text =  data?.productName
            }

            if data?.onSale == true {
                cell.discountPrice.isHidden = false
                cell.productPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0))
                cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
            }else {
                cell.productPriceLine.isHidden = true
                cell.productPrice.isHidden = true
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(moreFromCartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(moreFromHeartButtonTap(_:)), for: .touchUpInside)

            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data?.id }) {
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
    
    @objc func  moreFromCartButtonTap(_ sender: UIButton) {
        let data = moreFromResponse?.results?[sender.tag]

        let vc = CartPopupViewController.getVC(.popups)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
        vc.products = data
        vc.nav = self.navigationController
        self.present(vc, animated: true, completion: nil)

    }
    @objc func relatedProductcartButtonTap(_ sender: UIButton) {
        let data = relatedProductResponse[sender.tag]
        let vc = CartPopupViewController.getVC(.popups)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
        vc.products = data
        vc.nav = self.navigationController
        self.present(vc, animated: true, completion: nil)

    }
    @objc func moreFromHeartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
            let index = sender.tag
            let item = moreFromResponse?.results?[index]
            if item?.id == nil {
                self.wishListApi(productId: (item?._id ?? ""))
            }else {
                self.wishListApi(productId: (item?.id ?? ""))
            }
        }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func relatedProductHeartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
            let index = sender.tag
            let item = self.relatedProductResponse[index]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == relatedProductCollectionView {
            let data =  self.relatedProductResponse[indexPath.row]
           
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == videoCollection {
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            let data =  self.moreFromResponse?.results?[indexPath.row]
           
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == relatedProductCollectionView {
            return CGSize(width: collectionView.frame.width/2.1, height: 280)
        }else if collectionView == moreFrom {
            if moreFromResponse?.results?.count ?? 0 > 2 {
                return CGSize(width: collectionView.frame.width/2-5, height: 280)
            }else {
                return CGSize(width: collectionView.frame.width/2-5, height: 280)
            }
        } else {
            return CGSize(width: videoCollection.frame.size.width/2, height: videoCollection.frame.size.height)
            
        }
    }
    
}
extension NewProductPageViewController{
    
    
    
    
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
                    
                    
                    //                    self.Inbox_tableview.reloadData()
                    
                    
                    
                    
                }
            }
            
            
            
            //         self.socket?.on("unread") { data, ack in
            //             if let rooms = data[0] as? [[String: Any]]{
            //                 print(rooms)
            //             }
            //         }
            //         self.socket?.on("newChatMessage") { data, ack in
            //             if let rooms = data[0] as? [[String: Any]]{
            //                 print(rooms)
            //             }
            //         }
            //         }
            //         self.socket?.on("messages") { data, ack in
            //             if let rooms = data[0] as? [[String: Any]]{
            //                 print(rooms)
            //             }
            //         }
            
            
            
            self.socket?.on(clientEvent: .disconnect) { data, ack in
                // Handle the disconnection event
                print("Socket disconnected")
            }
            
            
            
            
            
        }
        

        
        
    }
    
}
