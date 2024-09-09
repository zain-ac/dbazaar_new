//
//  Category_ProductsVC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 29/08/2023.
//

import UIKit
import AudioToolbox
import Presentr

class Category_ProductsVC: UIViewController {
    @IBOutlet weak var filterPullDownButtom: UIButton!
    @IBOutlet weak var categoryproduct_collectionview: UICollectionView!
    @IBOutlet weak var categoryNameTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
   
    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
        
    @IBOutlet weak var scrollheight: NSLayoutConstraint!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var productSortByLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeswitchbtn: UISwitch!
    @IBOutlet weak var productEmptyLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!


    var contentPages: [UIViewController] = []

    var prductid = String()
    var catNameTitle = String()
     var sort = "-createdAt"
    var sellerDescription = String()
    var storeId = String()
    
    var getAllProductsByCategoriesData: [Product] = []
    
    var storeFlag = Bool()
    var video_section = Bool()
    var isEndReached = false
    var isLoadingNextPage = false
    var categoryPage = 1
    var isFollow = false
    let centerTransitioningDelegate = CenterTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productEmptyLbl.isHidden = true

        scrollView.delegate = self
        Utility().setGradientBackground(view: headerBackgroudView, colors: [primaryColor, primaryColor, headerSecondaryColor])
//       getStreamingVideos(userId: prductid, limit: 10, page: 1, categories: [])
//        followcheck(storeId: self.storeId)
       

        setupCollectionView()
        

        
       
        
        
        
        if((self.tabBarController?.tabBar.isHidden) != nil){
         
            appDelegate.isbutton = true
        }else{
       
            appDelegate.isbutton = false
        }
     
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        let Default = {(action: UIAction) in
            self.sort = "-createdAt"
            self.getAllProductsByCategoriesData.removeAll()
            self.update(count: 1)
        }
        let ASC = {(action: UIAction) in
            self.sort = "price"
            self.getAllProductsByCategoriesData.removeAll()
            self.update(count: 1)
        }
        let DSC = {(action: UIAction) in
            self.sort = "-price"
            self.getAllProductsByCategoriesData.removeAll()
            self.update(count: 1)
        }
        if let downArrow = UIImage(systemName: "chevron.down") {
            let scaledImage = downArrow.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .medium))
            filterPullDownButtom.setImage(scaledImage, for: .normal)
            filterPullDownButtom.semanticContentAttribute = .forceRightToLeft
            filterPullDownButtom.configuration?.imagePadding = 8
        }

        filterPullDownButtom.menu = UIMenu(children: [
            UIAction(title: "Default".pLocalized(lang: LanguageManager.language),state: .on, handler: Default),
            UIAction(title: "pricelowtohigh".pLocalized(lang: LanguageManager.language), handler: ASC),
            UIAction(title: "pricehightolow".pLocalized(lang: LanguageManager.language), handler: DSC)
        ])
        
        filterPullDownButtom.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            filterPullDownButtom.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    
        categoryNameTitle.text = catNameTitle

        update(count: 1)
        
        if storeFlag == false {
            categoryNameTitle.isHidden = false
//            stackviewheight.constant = 50
//            videossection.isHidden = true


        } else {
            categoryNameTitle.isHidden = true

        }
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        categoryproduct_collectionview.delegate = self
        categoryproduct_collectionview.dataSource = self
    }
    
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               let vc = LIVE_videoNew.getVC(.videoStoryBoard)
               self.navigationController?.pushViewController(vc, animated: false)
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
        self.LanguageRender()
        homeswitchbtn.isOn = false
        if(AppDefault.islogin ){
            
            if AppDefault.wishlistproduct != nil{
                wishList(isbackground: true)
            }else{
                wishList(isbackground: false)
            }
        }
    }
    
    func LanguageRender(){
       

        productSortByLbl.text = "productsortby".pLocalized(lang: LanguageManager.language)
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
    }
    
//    private func getStreamingVideos(userId:String,limit:Int,page:Int,categories: [String]){
//        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:userId, city: "",completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//               //
//                self?.LiveStreamingResultsdata = res.results ?? []
//                
//                if(self?.LiveStreamingResultsdata.count ?? 0 > 0){
////                    self?.videoLabelView.isHidden = true
//                }else{
//                    if self?.storeFlag == false {
//                    }else {
//                    }
////                    self?.videoLabelView.isHidden = false
//
//                }
//             
//
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
    
//    func setupSwipeGesture() {
//        pagecontrol.pageIndicatorTintColor = UIColor.red
//        pagecontrol.currentPageIndicatorTintColor = UIColor.orange
//
//        pagecontrol.currentPage += 1
//
//        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        videosection_collectionview.addGestureRecognizer(swipeGesture)
//    }
//
//    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
//        let velocity = gesture.velocity(in: videosection_collectionview)
//       
//    }


    
    func update(count:Int) {
        if storeFlag == false {
            getAllProductsByCategories(limit: 20, page: count, sortBy:sort, category:prductid, active: false)
        }else{
            getAllProductsByCategoriesbyid(limit: 20, page: count, sortBy:sort, category:prductid, active: false)
        }
    }
    
    
    
    private func getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategories(limit:limit,page:page,sortBy:sortBy,category:category,active:active){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []
                    // Increment the page numbe
                    self?.categoryPage += 1
                    
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    
                 //
//                    if self?.getAllProductsByCategoriesData.count == 1 {
//                        let ll = (self?.getAllProductsByCategoriesData.count ?? 0)  * 240
//                        let hh = 60 + (self?.stackviewheight.constant ?? 0)
//                        self?.scrollheight.constant = CGFloat(hh + CGFloat(ll) + 20)
//                       
//                        self?.categoryproduct_collectionview.reloadData()
//                    }else {
                        let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 284
                    self?.scrollheight.constant = CGFloat(ll + 105)
                       
                        self?.categoryproduct_collectionview.reloadData()
//                    }
          
                }else {
                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
                    self?.productEmptyLbl.isHidden = true
                }else {
                    self?.productEmptyLbl.isHidden = false

                }


            case .failure(let error):
                print(error)
                self?.isLoadingNextPage = false
            }
        }
    }
    
    private func getAllProductsByCategoriesbyid(limit:Int,page:Int,sortBy:String,category:String,active:Bool){
        APIServices.getAllProductsByCategoriesbyid(limit:limit,page:page,sortBy:sortBy,category:category,active:active){[weak self] data in
            switch data{
            case .success(let res):
                if res.Categoriesdata?.count ?? 0 > 0 {
                    self?.getAllProductsByCategoriesData += res.Categoriesdata ?? []

                    // Increment the page numbe
                    self?.categoryPage += 1
                    
                    // Update flag after loading
                    self?.isLoadingNextPage = false
                    
                    let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 284
                self?.scrollheight.constant = CGFloat(ll + 105)
                    self?.categoryproduct_collectionview.reloadData()
                }else {

                }
                if self?.getAllProductsByCategoriesData.count ?? 0 > 0 {
                    self?.productEmptyLbl.isHidden = true
                }else {
                    self?.productEmptyLbl.isHidden = false

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
    
    
    private func chinesebell(sellerId:String,brandName:String,description:String){
        APIServices.chinesebell(sellerId: sellerId, brandName: brandName, description: description){[weak self] data in
            switch data{
            case .success(_): break
             //
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    self?.view.makeToast(error)
                }
            }
        }
    }
    
//    private func followStore(storeId:String,web:Bool){
//        APIServices.followStore(storeId: storeId, web: web){[weak self] data in
//            switch data{
//            case .success(let res):
//                self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
//                self?.isFollow = true
//             //
//            case .failure(let error):
//                print(error)
//                if(error == "Please authenticate" && AppDefault.islogin){
//                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
//                }else{
//                    self?.view.makeToast(error)
//                }
//            }
//        }
//    } 
//    private func unfollowStore(storeId:String){
//        APIServices.unfollowstore(storeId: storeId){[weak self] data in
//            switch data{
//            case .success(let res):
//                if(res == "OK"){
//                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
//                    self?.isFollow = false
//                }
//             
//             //
//            case .failure(let error):
//                print(error)
//                if(error == "Please authenticate" && AppDefault.islogin){
//                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
//                }else{
//                    self?.view.makeToast(error)
//                }
//            }
//        }
//    } 
//    
//    private func followcheck(storeId:String){
//        APIServices.followcheck(storeId: storeId){[weak self] data in
//            switch data{
//            case .success(let res):
//                if(res == "OK"){
//                    self?.followBtn.setTitle("followed".pLocalized(lang: LanguageManager.language), for: .normal)
//                    self?.isFollow = true
//                }else{
//                    self?.followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
//                    self?.isFollow = false
//                }
//            case .failure(let error):
//                print(error)
//                if(error == "Please authenticate" && AppDefault.islogin){
//                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
//                }else{
//                    if error == "Not found" {
//                        
//                    }else {
////                        self?.view.makeToast(error)
//                    }
//                }
//            }
//        }
//    }
    
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
    
    
    @IBAction func cartbtn(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.searchStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
            appDelegate.isbutton = false
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: false)
    }
//    @IBAction func bellIconBtnTapped(_ sender: Any) {
//        
//        AppDefault.brandname = catNameTitle
//        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Do you want to video call \(self.brandName.text ?? "")?", heading: "Request Call", note: "Note: Make sure to be available for next 30 mins", miscid: "", btn1Title: "Cancel", btn1Callback: {
//            
//        }, btn2Title: "Request Call") { token, id in
//            self.chinesebell(sellerId:self.prductid , brandName: self.catNameTitle, description: "sellerDescription")
//        }
////            appDelegate.ChineseShowCustomerAlertControllerHeight(title: "You want to send request \(self.brandName.text ?? "") to do video call?", miscid: "", btn1Title: "Cancel", btn1Callback: {
////                
////            }, btn2Title: "Send Request") { token, id in
////                print("click")
////              
////                
////            }
//        }
    
    
//    @IBAction func followBtnTapped(_ sender: Any) {
//        if(isFollow){
//            unfollowStore(storeId: self.storeId)
//        }else{
//            followStore(storeId: self.storeId, web: true)
//        }
//       
//    
//    }
    
    @IBAction func viewAllBtnTapped(_ sender: Any) {
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
        vc.indexValue = 0
        self.navigationController?.pushViewController(vc, animated: false)

    }
}

extension Category_ProductsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
            return self.getAllProductsByCategoriesData.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: [primaryColor, primaryColor, headerSecondaryColor])
        cell.product = data
            cell.productimage.pLoadImage(url: data.mainImage ?? "")
            cell.productname.text =  data.productName
            cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
            if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0))
//                cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
//                cell.discountPrice.textColor = UIColor(hexString: primaryColor)
                cell.productPriceLine.backgroundColor = UIColor.red
                cell.percentBGView.isHidden = false
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
//                cell.productPrice.textColor = UIColor(hexString: primaryColor)
                cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0))
                cell.percentBGView.isHidden = true
             }
            cell.heartBtn.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
            cell.heartBtn.addTarget(self, action: #selector(heartButtonTap(_:)), for: .touchUpInside)
                     
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
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollPos = scrollView.contentOffset.x / view.frame.width
//        pagecontrol.currentPage = Int(scrollPos)
//
//    }
    
    @objc func cartButtonTap(_ sender: UIButton) {
        let data = getAllProductsByCategoriesData[sender.tag]
        
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
    @objc func heartButtonTap(_ sender: UIButton) {
        if(AppDefault.islogin){
              let index = sender.tag
            let item = getAllProductsByCategoriesData[index]
            if item.id == nil {
                self.wishListApi(productId: (item._id ?? ""))
            }else {
                self.wishListApi(productId: (item.id ?? ""))
            }            }else{
                let vc = PopupLoginVc.getVC(.popups)
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
            }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryproduct_collectionview{
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            
            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else{
            let vc = New_SingleVideoview.getVC(.videoStoryBoard)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.categoryproduct_collectionview.frame.width/2.03, height: 280)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 4

    }
    
  
    

    
    }
    
    

extension Category_ProductsVC: UIScrollViewDelegate {
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
