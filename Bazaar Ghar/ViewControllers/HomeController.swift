//
//  HomeController.swift
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


class HomeController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var homeswitchbtn: UISwitch!
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
    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var topcategorieslbl: UILabel!
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var LiveGif: UIImageView!
    @IBOutlet weak var hotDealCollectionV: UICollectionView!

    @IBOutlet weak var hotDealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotDealView: UIView!
    @IBOutlet weak var chatBotGif: UIImageView!
    @IBOutlet weak var recommendationLbl: UILabel!

    @IBOutlet weak var shopByCatLbl: UILabel!

    @IBOutlet weak var searchFeild: UITextField!
    
    @IBOutlet weak var viewalllbl: UIButton!
    @IBOutlet weak var pagerView: FSPagerView!
     @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var headerBackgroudView: UIView!

    @IBOutlet weak var shopbeyoundview: UIView!
    @IBOutlet weak var shopbeyound_tblview: UITableView!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!


    
    
    var bannerapidata: [Banner]? = nil{
        didSet{
            self.setupPageControl()
           self.imageslidercollectionview.reloadData()
        }
    }
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    var ProductCategoriesResponsedata: [PChat] = []
    var randomproductapiModel: [PChat] = []
    var getrandomproductapiModel: [RandomnProductResponse] = []

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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesApi(isbackground: false)
             getrandomproduct()
        scrollView.delegate = self

        let attributedText11 =  Utility().attributedStringWithColoredStrings("Shop", firstTextColor: UIColor(hexString: "#101010"), "beyond boundaries", secondTextColor:  UIColor(hexString: "#2E8BF8"))
//            .attributedStringWithColoredLastWord(
//            "".lowercased().capitalized, lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        shoplabel.attributedText = attributedText11
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        pagerView.dataSource = self
               pagerView.delegate = self
               pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 2.0
        shopbeyound_tblview.dataSource = self
        shopbeyound_tblview.delegate = self
        

                
        let attributedText =  Utility().attributedStringWithColoredLastWord("Shop By Categories", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
                shopByCatLbl.attributedText = attributedText
        
        let attributedText1 =  Utility().attributedStringWithColoredLastWord("Latest Mobiles", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        recommendationLbl.attributedText = attributedText1
        
        
        shopchinaflag = ["flag_china","flag_pakistan","flag_saudi"]


        shopchinaimg = ["Image 120","Image 121","saudi_product_image"]
        nameshopchina = ["Shop China","Shop Pakistan","Shop Saudi"]
        self.becomeFirstResponder()
//        let jeremyGif = UIImage.gifImageWithName("live_icon_gif")
           LiveGif.image = UIImage.gifImageWithName("live_icon_gif")
        LiveGif.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
          LiveGif.addGestureRecognizer(tap)
        
//        chatBotGif.image = UIImage(named: "whatsapp 1")
        chatBotGif.isUserInteractionEnabled = true
     let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped2(_:)))
        chatBotGif.addGestureRecognizer(tap2)
  
        hotDealViewHeight.constant = 0
        hotDealView.isHidden = true
        homeTblView.delegate = self
        homeTblView.dataSource = self
        homeLastProductCollectionView.delegate = self
        homeLastProductCollectionView.dataSource  = self

        setupCollectionView()
        
        DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.autoSlideer), userInfo: nil, repeats: true)
           }
       
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videocallmethod(notification:)), name: Notification.Name("videocallid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Productid"), object: nil)
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the scroll view has reached the bottom
        if offsetY > contentHeight - frameHeight {
            // Call your API
            if load == true {
                getrandomproduct()
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
            let vc = LIVE_videoNew.getVC(.main)
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
            let vc = LIVE_videoNew.getVC(.main)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        let imageDataDict:[String: String] = ["img": "World_Button"]
        NotificationCenter.default.post(name: Notification.Name("globe"), object: nil,userInfo: imageDataDict)

        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true

        if(AppDefault.randonproduct?.count ?? 0 > 0){
            randomproduct(cat: "60ec3fdfdbae10002e984274", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: true)
            self.randomproductapiModel = AppDefault.randonproduct ?? []
        }else{
            randomproduct(cat: "60ec3fdfdbae10002e984274", cat2: "", cat3: "", cat4: "", cat5: "",  isbackground: false)
        }

        if(AppDefault.groupbydealdata?.count ?? 0 > 0){
            groupByDeals(limit: 20, page: 1, isbackground: true)
            self.groupbydealsdata = AppDefault.groupbydealdata ?? []
            self.hotDealViewHeight.constant = 300
            self.hotDealView.isHidden = false

            self.hotDealCollectionV.reloadData()

        }else{
            groupByDeals(limit: 20, page: 1, isbackground: false)
        }
        
        if(AppDefault.productcategoriesApi?.count ?? 0 > 0){
            productcategoriesApi(cat: "", cat2: "", cat3: "", cat4: "", cat5: "",isbackground: true)

            self.ProductCategoriesResponsedata = AppDefault.productcategoriesApi ?? []

            self.tableViewHeight.constant = CGFloat(800 * (self.ProductCategoriesResponsedata.count ))
            let hh = (300 * 3) + 1440 + ((getrandomproductapiModel.count) / 2) * 280

            self.scrollHeight.constant = CGFloat(hh) + (self.hotDealViewHeight.constant) + (self.tableViewHeight.constant)

            self.homeTblView.reloadData()


        }else{
            self.productcategoriesApi(cat: "", cat2: "", cat3: "", cat4: "", cat5: "",isbackground: false)
        }

        
        
        if(AppDefault.getAllCategoriesResponsedata?.count ?? 0 > 0){
            self.categoriesApi(isbackground: true)

            self.CategoriesResponsedata = AppDefault.getAllCategoriesResponsedata ?? []

            self.topcell_1.reloadData()
//            self.categoriesApi(isbackground: true)

        }
        else
        {
            self.categoriesApi(isbackground: false)
        }
                

        if(AppDefault.Bannerdata?.count ?? 0 > 0){
            let res = AppDefault.Bannerdata!
            if(res.count > 0){
                for item in res {
                    let objext = item.id
                    if objext?.bannerName == "Mob Banner Home" {
                        self.bannerapidata = (objext?.banners)!
                    }
                }
            }
           
            self.bannerApi(isbackground: true)
        }else{
            self.bannerApi(isbackground: false)
        }
        
        homeswitchbtn.isOn = false
        hotDealCollectionV.reloadData()
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
    

    func LanguageRender() {
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
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

               let vc = Live_VC.getVC(.main)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    
    @IBAction func searchTapped(_ sender: Any) {
        let vc = Search_ViewController.getVC(.main)
        if(searchFeild.text?.count == 0){
            self.navigationController?.pushViewController(vc, animated: false)
           
        }else{
        
            vc.searchText = searchFeild.text
            self.navigationController?.pushViewController(vc, animated: false)
        }
       
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
                    let banners =  res
                    
                   
                    for item in res{
                        let objext = item.id
                        if objext?.bannerName == "Mob Banner Home" {
                            self?.bannerapidata = (objext?.banners)!
                        }
                    }
                    
                    self?.pageControl.numberOfPages = self?.bannerapidata?.count ?? 0
                    self?.pageControl.currentPage = 0
                }
    
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
    }
    private func categoriesApi(isbackground:Bool) {
        APIServices.getAllCategories(isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                self?.CategoriesResponsedata = res
                AppDefault.getAllCategoriesResponsedata = res
                
                self?.topcell_1.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func productcategoriesApi(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,isbackground:Bool){
        APIServices.productcategories(cat: cat, cat2: cat2, cat3: cat3, cat4: cat4, cat5: cat5,isbackground:isbackground,completion: {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.productcategoriesApi = res
                if(res.count > 0){
                    self?.ProductCategoriesResponsedata = res
                    self?.tableViewHeight.constant = CGFloat(800 * (self?.ProductCategoriesResponsedata.count ?? 0))
                    
                    let hh = (300 * 3) + 1440
                    let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 280
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
                    AppDefault.randonproduct = res
                }
                print(res)
               
                self?.homeLastProductCollectionView.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    private func getrandomproduct(){
        load = false
        APIServices.getrandomproduct(completion: {[weak self] data in
            switch data{
            case .success(let res):
            
             
                if(res.count > 0){
                    self?.getrandomproductapiModel.append(contentsOf: res)
                }
                print(res)
                self?.tableViewHeight.constant = CGFloat(800 * (self?.ProductCategoriesResponsedata.count ?? 0))
                
                let hh = (300 * 3) + 1440
                let ll = ((self?.getrandomproductapiModel.count ?? 0) / 2) * 280
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
        let vc = HotDealProductsViewController.getVC(.main)
        vc.groupbydealsdata = self.groupbydealsdata
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
                let vc = ProductDetail_VC.getVC(.main)
                   vc.isGroupBuy = false
                  vc.slugid = appDelegate.slugid
                self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func videocallmethod(notification: Notification) {
            
        let vc = VideoViewController.getVC(.main)
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
            hederView.semanticContentAttribute = .forceLeftToRight
        }else {
            imageslidercollectionview.semanticContentAttribute = .forceLeftToRight
            hederView.semanticContentAttribute = .forceLeftToRight
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

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageslidercollectionview {
            return  bannerapidata?.count ?? 0
        }else if collectionView == homeLastProductCollectionView {
            return self.randomproductapiModel.first?.product?.count ?? 0
        }else if collectionView == hotDealCollectionV {
            return groupbydealsdata.count
        } else if collectionView == lastRandomProductsCollectionView {
            return self.getrandomproductapiModel.count

        } else {
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
            let data = randomproductapiModel.first?.product?[indexPath.row]
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
        } else if collectionView == hotDealCollectionV {
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
                cell.salePrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red
            }else {
                cell.salePrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.regularPrice.textColor = UIColor(hexString: "#069DDD")

             }
           
            return cell
        }else if collectionView == lastRandomProductsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data = getrandomproductapiModel[indexPath.row]
            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            cell.productname.text = data.productName
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.discountPrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red

            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor(hexString: "#069DDD")
            }
            cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
            

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
            let data = CategoriesResponsedata[indexPath.row]
            cell.imageView.pLoadImage(url: data.mainImage ?? "")
            
            
            if LanguageManager.language == "ar"{
                cell.topCatLbl.text = data.lang?.ar?.name
            }else{
                cell.topCatLbl.text = data.name
            }
            
            return cell
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
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == homeLastProductCollectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageslidercollectionview {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == homeLastProductCollectionView {
            return CGSize(width: homeLastProductCollectionView.frame.width/2-5, height: homeLastProductCollectionView.frame.height/2-5)
        } else if collectionView == hotDealCollectionV {
            return CGSize(width: self.hotDealCollectionV.frame.width/1.2, height: self.hotDealCollectionV.frame.height)

        } else if collectionView == lastRandomProductsCollectionView {
            return CGSize(width: self.lastRandomProductsCollectionView.frame.width/2.12-2, height: 290)

        } else {
            return CGSize(width: self.topcell_1.frame.width/3.6-10, height: self.topcell_1.frame.height/2.1-5)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == lastRandomProductsCollectionView {
           return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

            
        }else if collectionView == homeLastProductCollectionView {
            let data = randomproductapiModel.first?.product?[indexPath.row]
            let vc = NewProductPageViewController.getVC(.sidemenu)
//                vc.isGroupBuy = false
//            vc.slugid = data?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else if collectionView == hotDealCollectionV {
            let data = groupbydealsdata[indexPath.row]
            let vc = ProductDetail_VC.getVC(.main)
            vc.isGroupBuy = true
            vc.groupbydealsdata = data
            vc.slugid = data.productID?.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else if collectionView == lastRandomProductsCollectionView {
            let data = getrandomproductapiModel[indexPath.row]

            let vc = ProductDetail_VC.getVC(.main)
            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
              let data = CategoriesResponsedata[indexPath.row]

              let vc = Category_ProductsVC.getVC(.main)
              vc.prductid = data.id ?? ""
              vc.video_section = false
              vc.storeFlag = false
              vc.catNameTitle = data.name ?? ""
              self.navigationController?.pushViewController(vc, animated: false)
          }
        
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == shopbeyound_tblview{
            return 3
        }else{
            return ProductCategoriesResponsedata.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  tableView == shopbeyound_tblview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Shopbeyound_TableViewCell", for: indexPath) as! Shopbeyound_TableViewCell
            
            let attributedText1 =  Utility().attributedStringWithColoredLastWord(shopBeyonLblArray[indexPath.row], lastWordColor: UIColor(hexString: "#496E2E"), otherWordsColor: UIColor(hexString: "#313230"))
            cell.shop_img.image = shopBeyonimagesArray[indexPath.row]
            cell.shopname_lbl.attributedText = attributedText1
            cell.explore_btn.addTarget(self, action: #selector(exploreBtnTapped(_:)), for: .touchUpInside)
            cell.bgView.backgroundColor = shopBeyondBGColorArray[indexPath.row]
            
            cell.CategoriesResponsedata = self.CategoriesResponsedata
            self.count += 1
            cell.count = self.count
            cell.nav = navigationController
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell

            let data = ProductCategoriesResponsedata[indexPath.row]
            
            
            if LanguageManager.language == "ar"{
                cell.cateogorylbl.text = data.lang?.ar?.name?.lowercased().capitalized
                cell.img.pLoadImage(url: data.lang?.ar?.wideBannerImage ?? "")
            }else{
                let attributedText =  Utility().attributedStringWithColoredLastWord(data.name?.lowercased().capitalized ?? "", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
                cell.cateogorylbl.attributedText = attributedText
                cell.img.pLoadImage(url: data.wideBannerImage ?? "")
            }
            //        cell.cateogorylbl.text = data.name ?? ""
            cell.productapi = data.product ?? []
            
            cell.catBannerBtn.tag = indexPath.row
            
            cell.catBannerBtn.addTarget(self, action: #selector(catBannerBtnTapped(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    @objc func exploreBtnTapped(_ sender: UIButton) {
        
    }
    @objc func catBannerBtnTapped(_ sender: UIButton) {
        let data = ProductCategoriesResponsedata[sender.tag]
        
        let vc = Category_ProductsVC.getVC(.main)
        vc.prductid = data.id ?? ""
        vc.video_section = false
        vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = randomproductapiModel.first?.product?[sender.tag]
        
        let vc = CartPopupViewController.getVC(.main)
       
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = centerTransitioningDelegate
        vc.products = data
        self.present(vc, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == shopbeyound_tblview{
            return 343
            
        }else {
            return 800
        }
    }
}


extension HomeController {
    
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

extension HomeController: FSPagerViewDataSource, FSPagerViewDelegate {
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


class CenterPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect()
        }
        
        // Define the size of the presented view controller
        let width: CGFloat = containerView.frame.width - 30
        let height: CGFloat = 500
        
        // Calculate the center position
        let x = (containerView.bounds.width - width) / 2
        let y = (containerView.bounds.height - height) / 2
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        // Optionally add a dimming view or background effect
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        containerView.addSubview(dimmingView)
        
        // Add the presented view
        containerView.addSubview(presentedViewController.view)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // Optionally handle the dismissal transition
    }
}


class CenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CenterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
