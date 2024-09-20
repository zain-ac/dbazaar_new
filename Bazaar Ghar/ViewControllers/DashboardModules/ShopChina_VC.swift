//
//  ShopChina_VC.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/08/2023.
//

import UIKit
import SocketIO
import SwiftyJSON
import AudioToolbox
import FSPagerView
import Presentr


class ShopChina_VC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var trendingproductlbl: UILabel!
    @IBOutlet weak var imageslidercollectionview: UICollectionView!
    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var topcell_1: UICollectionView!
    @IBOutlet weak var homeLastProductCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hotdealslbl: UILabel!
    @IBOutlet weak var shoplabel: UILabel!
    // outlets
    @IBOutlet weak var topcategorieslbl: UILabel!
    @IBOutlet weak var LiveGif: UIImageView!
    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    @IBOutlet weak var hotDealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var chatBotGif: UIImageView!
    @IBOutlet weak var recommendationLbl: UILabel!

    @IBOutlet weak var shopByCatLbl: UILabel!
    @IBOutlet weak var viewalllbl: UIButton!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var headerBackgroudView: UIView!

    @IBOutlet weak var shopbeyound_tblview: UITableView!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shopLbl: UILabel!

    @IBOutlet weak var topshoplbl: UILabel!
    @IBOutlet weak var shopLblBackgoundView: UIView!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var shopingReelsLbl: UILabel!
    @IBOutlet weak var shoesCollectionView: UICollectionView!
    @IBOutlet weak var catView: UIView!

    var KSA : [KSAcat] = []
    var China : [KSAcat] = []
    var Pak : [KSAcat] = []
    
    var bannerapidata: [Banner]? = nil{
        didSet{
            self.setupPageControl()
           self.imageslidercollectionview.reloadData()
        }
    }
    var CategoriesResponsedata: [CategoriesResponse] = []
    var ProductCategoriesResponsedata: [PChat] = []
    var randomproductapiModel: [PChat] = []
    var getrandomproductapiModel: [Product] = []

    var groupbydealsdata: [GroupByResult] = []

    var timer = Timer()
    var counter = 0
   var shopchinaflag = [String]()
    var shopchinaimg = [String]()
    var nameshopchina = [String]()
    var isLogin = UserDefaults.standard.bool(forKey: "isLogin")
    
    var manager:SocketManager?
    var socket: SocketIOClient?
    var messageItem:[notificationmodel] = []
var count = 0
    let idArray = ["6040b38c45cb316c8ab8afff",
                   "5fe1cbaac05d6b3eb844f6f0",
                   "6038dcbe7e4d2a1f859d8253",
                   "603e0dcc7e4d2a1f859d8a63",
                   "5fe1cbaac05d6b3eb844f6ed",
                   "6040bbd745cb316c8ab8b024",
                   "65e82aa5067e0d3f4c5f773c",
                   "6038dd317e4d2a1f859d8255",
                   "6048c62a05ec9502c9f8cde3",
                   "65e82aa5067e0d3f4c5f768f",
                   "60420891513d358144a14314"]

    
    let colors = [
           (top: UIColor(red: 223.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0), bottom: UIColor(red: 248.0/255.0, green: 70.0/255.0, blue: 86.0/255.0, alpha: 1.0)), // China gradient colors
           (top: UIColor(red: 17.0/255.0, green: 87.0/255.0, blue: 64.0/255.0, alpha: 1.0), bottom: UIColor(red: 1.0/255.0, green: 148.0/255.0, blue: 100.0/255.0, alpha: 1.0)), // Pakistan gradient colors
           (top: UIColor(red: 18.0/255.0, green: 190.0/255.0, blue: 102.0/255.0, alpha: 1.0), bottom: UIColor(red: 26.0/255.0, green: 193.0/255.0, blue: 110.0/255.0, alpha: 1.0)) // Saudi gradient colors
       ]
    
    var shopBeyondBGColorArray = [UIColor(hex: "#F7FFF2"),UIColor(hex: "#FFF4F6"),UIColor(hex: "#F0FFEF")]
    var shopBeyonimagesArray = [UIImage(named: "pakistan-image"),UIImage(named: "china"),UIImage(named: "saudi")]
    var shopBeyonLblArray = ["Shop Pakistan","Shop China","Shop Saudi"]

    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var load:Bool?
    
    var shop:String?
    var color:String?
    var shopImg: String?
    var shoptxtColor:String?
    var catBGColor : String?
    var LiveStreamingResultsdata: [LiveStreamingResults] = [] {
        didSet {
            videoCollection.reloadData()
        }
    }
    var kk = 0
    var subCatData: [DatumSubCategory] = [] {
        didSet {
         kk += 150
            if subCatData.count > 0 {
                self.tableViewHeight.constant = CGFloat(770 * (self.ProductCategoriesResponsedata.count)) + CGFloat(kk)
                let hh =  1100
                let ll = ((self.getrandomproductapiModel.count) / 2) * 285
                let final = hh + ll
                self.scrollHeight.constant = CGFloat(final) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)    
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KSA = [
               
            KSAcat(name: "Soaps",id: "60d30fafadf1df13d41b56d5",img: "https://cdn.bazaarghar.com/1640677639491body-soaps-shower-gel.png"),
        KSAcat(name: "Fragrances",id: "604f48f648fcad02d8aaceeb",img: "https://cdn.bazaarghar.com/1640607482286mens-fragrances.png"),
        KSAcat(name: "Dates",id: "60c9dce26f0fe647a547713c",img:"https://cdn.bazaarghar.com/1640595049922dry-fruits.png"),
        KSAcat(name: "Rugs",id: "61c0665ec59a3763f321635a",img:"https://cdn.bazaarghar.com/1640698644416rugs-and-carpets.png")

        ]  
        China = [
        KSAcat(name: "Games & Accessories",id: "65e82aa5067e0d3f4c5f774e",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714134544530game-and-accesories.png"),
            
        KSAcat(name: "Smart Electronics",id: "65e82aa5067e0d3f4c5f774c",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714109268854smart-electronics.png"),
        KSAcat(name: "Night Lights",id: "65e82aa5067e0d3f4c5f7746",img: "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714110169088night-light.png"),
        KSAcat(name: "Home Decor",id: "65e82aa5067e0d3f4c5f76c8",img:  "https://bazaarghar-stage.s3.me-south-1.amazonaws.com/1714110548828home-decor.png")
        ]
        
        Pak = [
            KSAcat(name: "Men Unstitched",id:"60532f0411747985fdce553a" ,img: "https://cdn.bazaarghar.com/1724830822838men-unstitched.png"),
            KSAcat(name: "Women Unstitched",id:"6049fd8d05ec9502c9f8d1f4" ,img:"https://cdn.bazaarghar.com/1724830629937women-unstitched.png"),
            KSAcat(name: "Boys T-Shirts ",id:"60d1e12badf1df13d41b555a" ,img:"https://cdn.bazaarghar.com/1724830959537boys-t-shirts.png"),
            KSAcat(name: "Bags",id:"6151a0a13d796e00329b5f4e" ,img:"https://cdn.bazaarghar.com/1640607310826ladies-handbags.png"),
            KSAcat(name: " Joggers & Sneakers",id:"6049d17c05ec9502c9f8cfb2" ,img:"https://cdn.bazaarghar.com/1724831211715joggers-sneakers.png"),
         ]
        

        scrollView.delegate = self
        topshoplbl.text = shop
         shopLbl.text = "Welcome to \(shop ?? "")"
        shopLblBackgoundView.backgroundColor = UIColor(hex: color ?? "")
        shopImage.image = UIImage(named: shopImg ?? "")

        
        Utility().setGradientBackground(view: headerBackgroudView, colors: [primaryColor, primaryColor, headerSecondaryColor])

        pagerView.dataSource = self
               pagerView.delegate = self
               pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        

                
        let attributedText =  Utility().attributedStringWithColoredLastWord("Shop By Categories", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
                shopByCatLbl.attributedText = attributedText
        let attributedText5 =  Utility().attributedStringWithColoredLastWord("Trending Products", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
        
        trendingproductlbl.attributedText = attributedText5
  
        
        let attributedText2 =  Utility().attributedStringWithColoredLastWord("Shopping Reels", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
        
        shopingReelsLbl.attributedText = attributedText2
        
        shopchinaflag = ["flag_china","flag_pakistan","flag_saudi"]


        shopchinaimg = ["Image 120","Image 121","saudi_product_image"]
        nameshopchina = ["Shop China","Shop Pakistan","Shop Saudi"]
        self.becomeFirstResponder()
 
        hotDealViewHeight.constant = 0
        hotDealView.isHidden = true
        homeTblView.delegate = self
        homeTblView.dataSource = self
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self

        setupCollectionView()
        setupproductsCollectionView()

     
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videocallmethod(notification:)), name: Notification.Name("videocallid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Productid"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationSubCatUpadate(notification:)), name: Notification.Name("subcatupdate"), object: nil)
//        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        if shop == "Shop China" {
            let attributedText1 =  Utility().attributedStringWithColoredLastWord("Gamers Sale", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
            recommendationLbl.attributedText = attributedText1
            let imageDataDict:[String: String] = ["img": "china"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in China {
                categoriesApi(isbackground: true, id: i.id ?? "")
            }
            self.productcategoriesApi(cat: "65e82aa5067e0d3f4c5f76c2", cat2: "65e82aa5067e0d3f4c5f773c", cat3: "5fe1cbaac05d6b3eb844f6ed", cat4: "", cat5: "", origin: "china",isbackground: true)
            randomproduct(cat: "65e82aa5067e0d3f4c5f774e", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: true)
            getStreamingVideos(origin: "china")
            getrandomproduct(origin: "china")

        }else if shop == "Shop Saudi" {
            let attributedText1 =  Utility().attributedStringWithColoredLastWord("Best Sellers", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
            recommendationLbl.attributedText = attributedText1
            let imageDataDict:[String: String] = ["img": "saudi"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in KSA {
                categoriesApi(isbackground: false, id: i.id ?? "")
            }
            self.productcategoriesApi(cat: "604f48f648fcad02d8aaceeb", cat2: "60c9dce26f0fe647a547713c", cat3: "61c0665ec59a3763f321635a", cat4: "", cat5: "", origin: "ksa",isbackground: false)
            randomproduct(cat: "60d30fafadf1df13d41b56d5", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
            getStreamingVideos(origin: "ksa")
            getrandomproduct(origin: "ksa")

        }else {
            let attributedText1 =  Utility().attributedStringWithColoredLastWord("Best Sellers", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
            recommendationLbl.attributedText = attributedText1
            let imageDataDict:[String: String] = ["img": "pakistan-image"]
            NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)
            CategoriesResponsedata.removeAll()
            for i in Pak {
                categoriesApi(isbackground: false, id: i.id ?? "")
            }
            self.productcategoriesApi(cat: "6038dd317e4d2a1f859d8255", cat2: "6051de7711747985fdce2faa", cat3: "6048c62a05ec9502c9f8cde3", cat4: "", cat5: "", origin: "pak",isbackground: false)

            randomproduct(cat: "6048bc3b05ec9502c9f8cd8b", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
            getStreamingVideos(origin: "pak")
            getrandomproduct(origin: "pak")
        }
        
    }
    
//    @objc func methodOfReceivedNotificationSubCatUpadate(notification: Notification) {
//         let id = notification.userInfo?["id"] as? String
//         let index = notification.userInfo?["index"] as? Int
//         var cinaId1 = "65e82aa5067e0d3f4c5f76c2"
//        var cinaId2 = "65e82aa5067e0d3f4c5f773c"
//        var cinaId3 = "5fe1cbaac05d6b3eb844f6ed"
//
//        var saudiId1 = "604f48f648fcad02d8aaceeb"
//        var saudiId2 = "60c9dce26f0fe647a547713c"
//        var saudiId3 = "61c0665ec59a3763f321635a"
//
//        var pakiId1 = "6038dd317e4d2a1f859d8255"
//        var pakiId2 = "6051de7711747985fdce2faa"
//        var pakiId3 = "6048c62a05ec9502c9f8cde3"
//    
//
//        
//        if shop == "Shop China" {
//            if index == 0 {
//                cinaId1 = id ?? ""
//            }else if index == 1{
//                cinaId2 = id ?? ""
//            }else {
//                cinaId3 = id ?? ""
//            }
//            self.productcategoriesApi(cat: cinaId1, cat2: cinaId2, cat3: cinaId3, cat4: "", cat5: "",isbackground: false)
//
//        }else if shop == "Shop Saudi" {
//            if index == 0 {
//                saudiId1 = id ?? ""
//            }else if index == 1{
//                saudiId2 = id ?? ""
//            }else {
//                saudiId3 = id ?? ""
//            }
//            self.productcategoriesApi(cat: saudiId1, cat2: saudiId2, cat3: saudiId3, cat4: "", cat5: "",isbackground: false)
//        }else {
//            if index == 0 {
//                pakiId1 = id ?? ""
//            }else if index == 1{
//                pakiId2 = id ?? ""
//            }else {
//                pakiId3 = id ?? ""
//            }
//            self.productcategoriesApi(cat: pakiId1, cat2: pakiId2, cat3: pakiId3, cat4: "", cat5: "",isbackground: false)
//        }
//    }
    
    private func categoriesApi(isbackground:Bool,id:String) {
        APIServices.categories2(isbackground:isbackground, id: id,completion: {[weak self] data in
            switch data {
            case .success(let res):
                self?.CategoriesResponsedata.append(res)
                self?.topcell_1.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    func setupproductsCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        homeLastProductCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self
        
    
        
        shoesCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource  = self
        
        lastRandomProductsCollectionView.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        lastRandomProductsCollectionView.delegate = self
        lastRandomProductsCollectionView.dataSource  = self
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the scroll view has reached the bottom
        if offsetY > contentHeight - frameHeight {
            // Call your API
            if load == true {
                
                if shop == "Shop China" {
                    getrandomproduct(origin: "china")
                }else if shop == "Shop Saudi" {
                    getrandomproduct(origin: "ksa")
                }else {
                    getrandomproduct(origin: "pak")
                }
            }
        }
    }
    
        func loadMoreData() {
            // Your API call
            print("Reached the end of the scroll view, loading more data...")
            // Example API call
            // APIClient.loadMoreData { (result) in
            //     // Handle the result
            // }
            
        }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    @objc func touchTapped2(_ sender: UITapGestureRecognizer) {
        let phoneNumber = "+923075265787"
//                  /" // Your phone number with country code
              let urlString = "https://wa.me/\(phoneNumber)"
              
              if let url = URL(string: urlString) {
                  if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                      // WhatsApp is not installed
                      let alert = UIAlertController(title: "Error", message: "WhatsApp is not installed on your device.", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                  }
              }
//        let vc = webView_ViewController.getVC(.main)
//        vc.modalPresentationStyle  = .fullScreen
//        self.present(vc, animated: false)
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let vc = LIVE_videoNew.getVC(.videoStoryBoard)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

        catView.backgroundColor = UIColor(hex: catBGColor ?? "")
        shopLbl.textColor =  UIColor(hex: shoptxtColor ?? "")
        
   
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true

//        if(AppDefault.randonproduct?.count ?? 0 > 0){
//            randomproduct(cat: "60ec3fdfdbae10002e984274", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: true)
//            self.randomproductapiModel = AppDefault.randonproduct ?? []
//        }else{
//        groupByDeals(limit: 20, page: 1, isbackground: false)
        self.bannerApi(isbackground: false)
//                self.categoriesApi(isbackground: false)
//        }
        

//        if(AppDefault.groupbydealdata?.count ?? 0 > 0){
//            groupByDeals(limit: 20, page: 1, isbackground: true)
//            self.groupbydealsdata = AppDefault.groupbydealdata ?? []
//            self.hotDealViewHeight.constant = 300
//            self.hotDealView.isHidden = false
//
//            self.hotDealCollectionV.reloadData()
//
//        }else{
           
//        }
        
//        if(AppDefault.productcategoriesApi?.count ?? 0 > 0){
//            productcategoriesApi(cat: "", cat2: "", cat3: "", cat4: "", cat5: "",isbackground: true)
//
//            self.ProductCategoriesResponsedata = AppDefault.productcategoriesApi ?? []
//
//            self.tableViewHeight.constant = CGFloat(800 * (self.ProductCategoriesResponsedata.count ))
//            let hh = (300 * 3) + 1440 + ((getrandomproductapiModel.count) / 2) * 280
//
//            self.scrollHeight.constant = CGFloat(hh) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)
//
//            self.homeTblView.reloadData()
//
//
//        }else{
           
//        }

        
        
//        if(AppDefault.getAllCategoriesResponsedata?.count ?? 0 > 0){
//            self.categoriesApi(isbackground: true)
//
//            self.CategoriesResponsedata = AppDefault.getAllCategoriesResponsedata ?? []
//
//            self.topcell_1.reloadData()
////            self.categoriesApi(isbackground: true)
//
//        }
//        else
//        {
           
//        }
                

//        if(AppDefault.Bannerdata?.count ?? 0 > 0){
//            let res = AppDefault.Bannerdata!
//            if(res.count > 0){
//                for item in res {
//                    let objext = item.id
//                    if objext?.bannerName == "Mob Banner Home" {
//                        self.bannerapidata = (objext?.banners)!
//                    }
//                }
//            }
//           
//            self.bannerApi(isbackground: true)
//        }else{
        
//        }
        
//        homeswitchbtn.isOn = false
        
        self.LanguageRender()
        SocketConeect()
        
        
//        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "you want to join ?", btn1Title: "Accept", btn1Callback: {
//            print("Accept")
//
//              }, btn2Title: "Reject") {
//                
//                   print("Reject")
//
//              }
        
    }
    func wishList(isbackground:Bool){
        APIServices.wishlist(isbackground: isbackground){[weak self] data in
          switch data{
          case .success(let res):
          //
            AppDefault.wishlistproduct = res.products
   
            self?.homeLastProductCollectionView.reloadData()
              self?.lastRandomProductsCollectionView.reloadData()
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
    private func getStreamingVideos(origin:String){
        APIServices.shopchinaStreamingVideo(isBackground: false, origin: origin,completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
        
                self?.LiveStreamingResultsdata = res.results ?? []
       
                self?.videoCollection.reloadData()
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }


    func LanguageRender() {
//        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        hotdealslbl.text = "hotdeals".pLocalized(lang: LanguageManager.language)
        viewalllbl.setTitle("viewall".pLocalized(lang: LanguageManager.language), for: .normal)
//        recommendationLbl.text = "recommendation".pLocalized(lang: LanguageManager.language)
   

        topcategorieslbl.text = "topcategories".pLocalized(lang: LanguageManager.language)
        
        //        if LanguageManager.language == "ar"{
        //            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        //           }else{
        //               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        //           }
                
                UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
           if sender.isOn {
               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shopByCatArrowBtnTapped(_ sender: Any) {
        let vc = CategoriesVC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gamerSaleArrowBtnTapped(_ sender: Any) {
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        if shop == "Shop China" {
            vc.prductid = "65e82aa5067e0d3f4c5f774e"
            vc.catNameTitle = "Gamer Sale"
        }else if shop == "Shop Saudi" {
            vc.prductid = "60d30fafadf1df13d41b56d5"
            vc.catNameTitle = "Best Saler"
        }else {
            vc.prductid = "6038dd317e4d2a1f859d8255"
            vc.catNameTitle = "Best Saler"
        }
           vc.video_section = false
           vc.storeFlag = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func shoppingReelsArrowBtnTapped(_ sender: Any) {
        let vc = LIVE_videoNew.getVC(.videoStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        
        
        appDelegate.showCustomerLanguageAlertControllerHeight(title: "Select Language", heading: "", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Apply") {
            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
//            UITabBar.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
   
    }
    @IBAction func cartbtnTapped(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gotoCategoriesBtnTapped(_ sender: Any) {
        let vc = CategoriesVC
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func bannerApi(isbackground:Bool){
        APIServices.banner(isbackground: isbackground, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(data)
                AppDefault.Bannerdata = res
                if(res.count > 0){

                    if self?.shop == "Shop China" {
                        let banners =  res
                        
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country China App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country China App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                    }
                        
                    }else if self?.shop == "Shop Saudi"  {
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country KSA App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country KSA App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                              }
                            }
                    } else {
                    let banners =  res
                    
                        if LanguageManager.language == "ar" {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country Pakistan App Arabic" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                            }
                        }else {
                            for item in res{
                                let objext = item.id
                                if objext?.bannerName == "Country Pakistan App" {
                                    self?.bannerapidata = (objext?.banners)!
                                }
                              }
                            }
                }
                    self?.pageControl.numberOfPages = self?.bannerapidata?.count ?? 0
                    self?.pageControl.currentPage = 0
            }

                self?.pagerView.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
    }
//    private func categoriesApi(isbackground:Bool) {
//        APIServices.getAllCategories(isbackground:isbackground,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                self?.CategoriesResponsedata = res
//                AppDefault.getAllCategoriesResponsedata = res
//                
//                self?.topcell_1.reloadData()
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
    
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,origin:String,isbackground:Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                self?.kk = 0
                AppDefault.productcategoriesApi = res
                if(res.count > 0){
                    self?.ProductCategoriesResponsedata = res
                   
                    self?.tableViewHeight.constant = CGFloat(920 * (self?.ProductCategoriesResponsedata.count ?? 0))
                    let hh =  1100
                    let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 285
                    let final = hh + ll
                    self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
                }
                self?.lastRandomProductsCollectionView.reloadData()
                self?.homeTblView.reloadData()
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
                    self?.randomproductapiModel = res
//                    AppDefault.randonproduct = res
                }
               //
               
                self?.homeLastProductCollectionView.reloadData()
                self?.shoesCollectionView.reloadData()

            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func getrandomproduct(origin:String){
        load = false
        APIServices.getrandomproduct(isbackground: true, origin: origin,completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.count > 0){
                    self?.getrandomproductapiModel.append(contentsOf: res)
                }
               
//                self?.tableViewHeight.constant = CGFloat(920 * (self?.ProductCategoriesResponsedata.count ?? 0))
               
                let hh = 1100
                let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 285
                let final = hh + ll

                self?.scrollHeight.constant = CGFloat(final) + (self?.hotDealViewHeight.constant ?? 0) + (self?.tableViewHeight.constant ?? 0)
               
                self?.lastRandomProductsCollectionView.reloadData()
                self?.load = true
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func groupByDeals(limit:Int,page:Int,isbackground : Bool){
        APIServices.groupByDeals(limit: limit, page: page, isbackground: isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.groupbydealdata = res.result
                if(res.result?.count ?? 0 > 0){
                    AppDefault.groupbydealdata = res.result
                    self?.groupbydealsdata = res.result ?? []
                    self?.hotDealViewHeight.constant = 300
                    self?.hotDealView.isHidden = false
                    self?.hotDealCollectionV.reloadData()
                }
               
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    @IBAction func hotDealViewAllBtnTapped(_ sender: Any) {
        let vc = HotDealProductsViewController.getVC(.oldStoryboard)
        vc.groupbydealsdata = self.groupbydealsdata
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
                let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                   vc.isGroupBuy = false
                  vc.slugid = appDelegate.slugid
                self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func videocallmethod(notification: Notification) {
            
        let vc = VideoViewController.getVC(.videoStoryBoard)
        vc.accessToken = appDelegate.videotoken
        vc.videoCallId = appDelegate.videoid
     
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        imageslidercollectionview.register(nib, forCellWithReuseIdentifier: "cell")
        imageslidercollectionview.delegate = self
        imageslidercollectionview.dataSource = self
    
    }
    
    
    func setupPageControl() {
        pageController.numberOfPages = bannerapidata?.count ?? 0
        pageController.pageIndicatorTintColor = UIColor.gray
        pageController.currentPageIndicatorTintColor = UIColor.red

        pageController.currentPage = 0
        
        if LanguageManager.language == "ar" {
            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
            headerBackgroudView.semanticContentAttribute = .forceLeftToRight
        }else {
            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
            headerBackgroudView.semanticContentAttribute = .forceLeftToRight
        }
        
    
    }
    
//    @objc func reloadcollection() {
//      
//        timer.invalidate()
//        
//        self.setupPageControl()
//    }
    
    @objc func autoSlideer() {
        if counter < bannerapidata?.count ?? 0 {
            let index = IndexPath.init(item: counter, section: 0)
            if bannerapidata?.count == 0 {
                
            }else {
                self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }
            pageController.currentPage = counter
            counter += 1
        } else {
            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            self.imageslidercollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pageController.currentPage = counter
        }
    }
    
    // MARK: - Button Action

}

extension ShopChina_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageslidercollectionview {
            return  bannerapidata?.count ?? 0
        }else if collectionView == homeLastProductCollectionView {
            return self.randomproductapiModel.first?.product?.count ?? 0
        }else if collectionView == shoesCollectionView {
            return self.randomproductapiModel.first?.product?.count ?? 0
        }else if collectionView == hotDealCollectionV {
            return groupbydealsdata.count
        } else if collectionView == lastRandomProductsCollectionView {
            return self.getrandomproductapiModel.count

        } else if collectionView == videoCollection{
            return self.LiveStreamingResultsdata.count
        }else {
            return self.CategoriesResponsedata.count
		}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageslidercollectionview {
            let data = bannerapidata?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.imageView.pLoadImage(url: data?.image ?? "")

            return cell
        } else if collectionView == homeLastProductCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
            cell.product = data
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
            cell.cartButton.addTarget(self, action: #selector(gamessalescartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(gamesalesHeartBtnTapped(_:)), for: .touchUpInside)

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
        } else if collectionView == shoesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
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
           
            
            
            
            return cell
        }else if collectionView == hotDealCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDealCollectionViewCell", for: indexPath) as! HotDealCollectionViewCell
            let data = groupbydealsdata[indexPath.row]
            
            cell.mainImage.pLoadImage(url: data.productID?.mainImage ?? "")
            cell.brandName.text =  data.productID?.productName
            cell.regularPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.regularPrice ?? 0)
            cell.days.text = "\(data.remainingTime?.days ?? 0)"
            cell.hours.text = "\(data.remainingTime?.hours ?? 0)"
            cell.minutes.text = "\(data.remainingTime?.minutes ?? 0)"
            cell.dayslbl.text = "days".pLocalized(lang: LanguageManager.language)
            cell.hrslbl.text = "hrs".pLocalized(lang: LanguageManager.language)
            cell.minslbl.text = "mins".pLocalized(lang: LanguageManager.language)
            if data.productID?.onSale == true {
                cell.salePrice.isHidden = false
                cell.salePrice.text =   appDelegate.currencylabel + Utility().formatNumberWithCommas(data.productID?.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.regularPrice.textColor = UIColor.red
                cell.salePrice.textColor = UIColor(hexString: primaryColor)
                cell.productPriceLine.backgroundColor = UIColor.red
            }else {
                cell.salePrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.regularPrice.textColor = UIColor(hexString: primaryColor)

             }
           
            return cell
        }else if collectionView == lastRandomProductsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = getrandomproductapiModel[indexPath.row]
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
            cell.cartButton.addTarget(self, action: #selector(randomcartBtnTapped(_:)), for: .touchUpInside)

            cell.heartBtn.addTarget(self, action: #selector(randomHeartBtnTapped(_:)), for: .touchUpInside)

            if let wishlistProducts = AppDefault.wishlistproduct {
                    if wishlistProducts.contains(where: { $0.id == data._id }) {
                      cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      cell.heartBtn.tintColor = .red
                    } else {
                      cell.backgroundColor = .white
                      cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                      cell.heartBtn.tintColor = .white
                    }
                  }

            return cell
        } else if collectionView == videoCollection{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videoscategorycell1", for: indexPath) as! Videoscategorycell
            let data = LiveStreamingResultsdata[indexPath.row]
            cell.productimage.pLoadImage(url: data.thumbnail ?? "")
            cell.viewslbl.text = "\(data.totalViews ?? 0)  "
            cell.Productname.text = data.brandName
            cell.likeslbl.text = "\(data.like ?? 0)"
                return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
//            let data = CategoriesResponsedata[indexPath.row]
          
            if shop == "Shop China" {
                let  data = China[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                  if LanguageManager.language == "ar"{
  //                    cell.topCatLbl.text = data.lang?.ar?.name
                  }else{
                      cell.topCatLbl.text = data.name
                  }
            }else if shop == "Shop Saudi" {
                let  data = KSA[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                  if LanguageManager.language == "ar"{
  //                    cell.topCatLbl.text = data.lang?.ar?.name
                  }else{
                      cell.topCatLbl.text = data.name
                  }
            }else {
                let  data = Pak[indexPath.row]
                  cell.imageView.pLoadImage(url: data.img ?? "")
                  if LanguageManager.language == "ar"{
  //                    cell.topCatLbl.text = data.lang?.ar?.name
                  }else{
                      cell.topCatLbl.text = data.name
                  }
            }
        
            
            return cell
        }
    }
    @objc func gamessalescartButtonTap(_ sender: UIButton) {
        let data = self.randomproductapiModel.first?.product?[sender.tag]
        
        if (data?.variants?.first?.id == nil) {
            let vc = CartPopupViewController.getVC(.popups)
           
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = centerTransitioningDelegate
            vc.products = data
            vc.nav = self.navigationController
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data?.slug
            navigationController?.pushViewController(vc, animated: false)
        }
    } 
    @objc func gamesalesHeartBtnTapped(_ sender: UIButton) {

        if(AppDefault.islogin){
              let index = sender.tag
              let item = self.randomproductapiModel.first?.product?[index]
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
    @objc func randomcartBtnTapped(_ sender: UIButton) {
        let data = getrandomproductapiModel[sender.tag]
        
        if (data.attributes?.first?.name == nil) {
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
    @objc func randomHeartBtnTapped(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
              let item = getrandomproductapiModel[index]
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
    
    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView {
            return 10
        } else if collectionView == shoesCollectionView {
            return 10
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView {
            return 5
        }else if collectionView == shoesCollectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageslidercollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == homeLastProductCollectionView {
            return CGSize(width: homeLastProductCollectionView.frame.width/2-5, height: 280)
        } else if collectionView == shoesCollectionView {
            return CGSize(width: shoesCollectionView.frame.width/2-5, height: 280)
        }else if collectionView == hotDealCollectionV {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)

        } else if collectionView == lastRandomProductsCollectionView {
            return CGSize(width: self.lastRandomProductsCollectionView.frame.width/2.12-2, height: 280)

        }else if collectionView == videoCollection {
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: self.topcell_1.frame.width/4-10, height: self.topcell_1.frame.height)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == lastRandomProductsCollectionView {
           return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        
//        if pageController.currentPage == (bannerapidata?.count ?? 0) - 1 {
////            self.reloadcollection()
//            let scrollPos = scrollView.contentOffset.x / view.frame.width
//            pageController.currentPage = Int(scrollPos)
//        }else {
//            let scrollPos = scrollView.contentOffset.x / view.frame.width
//            pageController.currentPage = Int(scrollPos)
//            counter = pageController.currentPage
//        }
//        
//        loadMoreData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageslidercollectionview {
            let data = self.bannerapidata?[indexPath.row]
            if data?.type == "" || data?.type == nil {
                
            }else {
                switch data?.type {
                    
                  case "Market":
                    let vc = StoreSearchVC.getVC(.searchStoryBoard)
                    vc.isMarket = true
                    vc.marketID = data?.linkId
                    vc.isNavBar = false
                    self.navigationController?.pushViewController(vc, animated: false)

                  case "Store":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        
                        let vc = New_StoreVC.getVC(.productStoryBoard)
                        vc.prductid = data?.linkId ?? ""
                        vc.brandName = data?.name
                        vc.storeId = data?.linkId ?? ""
                        vc.sellerID = data?.linkId ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                        
                    }

                  case "Category":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = Category_ProductsVC.getVC(.productStoryBoard)
                        vc.prductid = data?.linkId ?? ""
                        vc.video_section = false
                        vc.storeFlag = false
                        vc.catNameTitle = data?.name ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                  case "Product":
                    if data?.linkId == "" || data?.linkId == nil {
                        
                    }else {
                        let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                        vc.isGroupBuy = false
                        vc.slugid = data?.linkId
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                  case "Video":
                    let vc = LIVE_videoNew.getVC(.videoStoryBoard)
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

            
        }else if collectionView == homeLastProductCollectionView {
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == shoesCollectionView {
            let data = self.randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                vc.isGroupBuy = false
            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == hotDealCollectionV {
            let data = groupbydealsdata[indexPath.row]
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = true
//            vc.groupbydealsdata = data
            vc.slugid = data.productID?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == lastRandomProductsCollectionView {
            let data = getrandomproductapiModel[indexPath.row]

            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == videoCollection {
            let data = LiveStreamingResultsdata[indexPath.row]
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            vc.page = 2
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
             
            
            if shop == "Shop China" {
                let  data = China[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                self.navigationController?.pushViewController(vc, animated: false)
            }else if shop == "Shop Saudi" {
                let  data = KSA[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                self.navigationController?.pushViewController(vc, animated: false)
            }else {
                let  data = Pak[indexPath.row]
                let vc = Category_ProductsVC.getVC(.productStoryBoard)
                vc.prductid = data.id ?? ""
                vc.video_section = false
                vc.storeFlag = false
                vc.catNameTitle = data.name ?? ""
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
          }
        
    }
    
}

extension ShopChina_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ProductCategoriesResponsedata.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell

            let data = ProductCategoriesResponsedata[indexPath.row]
            
            
            if LanguageManager.language == "ar"{
                cell.cateogorylbl.text = data.lang?.ar?.name?.lowercased().capitalized
                cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? "")
            }else{
                let attributedText =  Utility().attributedStringWithColoredLastWord(data.name?.lowercased().capitalized ?? "", lastWordColor: UIColor(hexString: primaryColor), otherWordsColor: UIColor(hexString: blackColor))
                cell.cateogorylbl.attributedText = attributedText
                cell.img.pLoadImage(url: data.wideBannerImage ?? "")
            }
            //        cell.cateogorylbl.text = data.name ?? ""
            cell.productapi = data.product ?? []
        cell.index = indexPath.row
        for i in AppDefault.getAllCategoriesResponsedata ?? [] {
            if i.id == data.id {
                cell.subCatData = i.subCategories ?? []
                self.subCatData = i.subCategories ?? []
                break
            }else {
                for j in i.subCategories ?? [] {
                    if j.id == data.id {
                        cell.subCatData = j.subCategories ?? []
                        self.subCatData = j.subCategories ?? []
                        break
                    } else {
                        for h in j.subCategories ?? [] {
                            if h.id == data.id {
                                cell.subCatData = h.subCategories ?? []
                                self.subCatData = h.subCategories ?? []
                                break
                            }
                        }
                    }
                }
            }
        }
        
        
        
            cell.catBannerBtn.tag = indexPath.row
            cell.arrowBtn.tag = indexPath.row
            cell.catBannerBtn.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
        cell.nav = self.navigationController
        cell.arrowBtn.addTarget(self, action: #selector(arrowBtnTapped(_:)), for: .touchUpInside)

            return cell
    }
    @objc func exploreBtnTapped(_ sender: UIButton) {
        
    }
    @objc func arrowBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.productStoryBoard)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = self.randomproductapiModel.first?.product?[sender.tag]
        
        if (data?.variants?.first?.id == nil) {
            let vc = CartPopupViewController.getVC(.popups)
           
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = centerTransitioningDelegate
            vc.products = data
            vc.nav = self.navigationController
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
            vc.slugid = data?.slug
            navigationController?.pushViewController(vc, animated: false)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if subCatData.count > 0 {
            return 920
        }else {
            return 770
        }
    }
}


extension ShopChina_VC {
    
    func SocketConeect() {
       
        manager = SocketManager(socketURL: AppConstants.API.chinesBellUrl, config: [.log(true),
                                                                                  .compress,
                                                                                  .forceWebsockets(true),.connectParams( ["token":AppDefault.accessToken])])
        socket = manager?.socket(forNamespace: "/chat/v1/notification")

        socket?.on(clientEvent: .connect) { (data, ack) in
//            self.socket?.emit("allNotifications", ["userId":AppDefault.currentUser?.id ?? "","page":1,"limit":200])
//            self.socket?.emit("unreadNotifications", ["userId":AppDefault.currentUser?.id ?? ""])
         
           }
        self.socket?.on("notifyChineseBell") { data, ack in
            print("chinise bell",data)
        
        }
        
//        self.socket?.on("allNotifications") { data, ack in
//            
//            if let rooms = data[0] as? [String: Any]{
//                if let item = rooms["results"] as? [[String: Any]]{
//                    
//                    self.messageItem.removeAll()
//                    var messageItem:[notificationmodel] = []
//                    let Datamodel = JSON(item)
//                    let message = Datamodel.array
//                    
//                    for items in message ?? []{
//                        messageItem.append(notificationmodel(jsonData: items))
//                    }
//                    
//                    print(messageItem)
//                    
//                    
//                    self.messageItem = messageItem
//                
//                    
//                }
// 
//            }
//        }
        
 
    
//        self.socket?.on("unreadNotifications") { data, ack in
//            print("chinise bell",data)
// //
//        }
       
//        self.socket?.on("chineseBell") { data, ack in
//            print("chinise bell",data)
// //
//        }
        
        socket?.connect()
        
        socket?.on(clientEvent: .disconnect) { data, ack in
           // Handle the disconnection event
           print("Socket disconnected")
       }
      
    }

    
}

extension ShopChina_VC: FSPagerViewDataSource, FSPagerViewDelegate {
func numberOfItems(in pagerView: FSPagerView) -> Int {
       return  bannerapidata?.count ?? 0
   }

   func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
       let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
       let data = bannerapidata?[index]
       cell.imageView?.pLoadImage(url: data?.image ?? "")
       cell.imageView?.contentMode = .scaleAspectFill
       return cell
   }

   // MARK: - FSPagerViewDelegate

   func pagerViewDidScroll(_ pagerView: FSPagerView) {
       let currentIndex = pagerView.currentIndex
       pageControl.currentPage = currentIndex
   }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let data = self.bannerapidata?[index]
        if data?.type == "" || data?.type == nil {
            
        }else {
            switch data?.type {
                
              case "Market":
                let vc = StoreSearchVC.getVC(.searchStoryBoard)
                vc.isMarket = true
                vc.marketID = data?.linkId
                vc.isNavBar = false
                self.navigationController?.pushViewController(vc, animated: false)

              case "Store":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = New_StoreVC.getVC(.productStoryBoard)
                    vc.prductid = data?.linkId ?? ""
                    vc.brandName = data?.name
                    vc.storeId = data?.linkId ?? ""
                    vc.sellerID = data?.linkId ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                }

              case "Category":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = data?.linkId ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = data?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
              case "Product":
                if data?.linkId == "" || data?.linkId == nil {
                    
                }else {
                    let vc = NewProductPageViewController.getVC(.productStoryBoard)
//                    vc.isGroupBuy = false
                    vc.slugid = data?.linkId
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
              case "Video":
                let vc = LIVE_videoNew.getVC(.videoStoryBoard)
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


//class CenterPresentationController: UIPresentationController {
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        guard let containerView = containerView else {
//            return CGRect()
//        }
//        
//        // Define the size of the presented view controller
//        let width: CGFloat = containerView.frame.width - 30
//        let height: CGFloat = 500
//        
//        // Calculate the center position
//        let x = (containerView.bounds.width - width) / 2
//        let y = (containerView.bounds.height - height) / 2
//        
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
//    
//    override func presentationTransitionWillBegin() {
//        super.presentationTransitionWillBegin()
//        
//        // Optionally add a dimming view or background effect
//        guard let containerView = containerView else { return }
//        let dimmingView = UIView(frame: containerView.bounds)
//        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        containerView.addSubview(dimmingView)
//        
//        // Add the presented view
//        containerView.addSubview(presentedViewController.view)
//    }
//    
//    override func dismissalTransitionWillBegin() {
//        super.dismissalTransitionWillBegin()
//        // Optionally handle the dismissal transition
//    }
//}
//
//
//class CenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
//    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return CenterPresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
