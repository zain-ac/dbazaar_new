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
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var bellIconBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var videossection: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var viewAll: UIButton!
   
    @IBOutlet weak var cartbtn: UIButton!
    @IBOutlet weak var videosection_collectionview: UICollectionView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
        
    @IBOutlet weak var stackviewheight: NSLayoutConstraint!
    @IBOutlet weak var scrollheight: NSLayoutConstraint!
    @IBOutlet weak var videoLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var videoLabelView: UIView!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var productSortByLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var videosLbl: UILabel!
    @IBOutlet weak var homeswitchbtn: UISwitch!
    @IBOutlet weak var productEmptyLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!



    @IBOutlet weak var viewHeight: NSLayoutConstraint!


    var contentPages: [UIViewController] = []

    var prductid = String()
    var catNameTitle = String()
     var sort = "-price"
    var sellerDescription = String()
    var storeId = String()
    
    var getAllProductsByCategoriesData: [Product] = []
    
    var storeFlag = Bool()
    var video_section = Bool()
    var isEndReached = false
    var isLoadingNextPage = false
    var categoryPage = 1
    var isFollow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
       getStreamingVideos(userId: prductid, limit: 10, page: 1, categories: [])
        followcheck(storeId: self.storeId)
       
        videosection_collectionview.delegate = self
        videosection_collectionview.dataSource = self

        
        self.tabBarController?.tabBar.isHidden = true
        setupCollectionView()
     
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
        
        filterPullDownButtom.menu = UIMenu(children: [
            UIAction(title: "pricelowtohigh".pLocalized(lang: LanguageManager.language), handler:
                        ASC),
            UIAction(title: "pricehightolow".pLocalized(lang: LanguageManager.language), state: .on, handler: DSC),
            
        ])
        
        filterPullDownButtom.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            filterPullDownButtom.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    
        categoryNameTitle.text = catNameTitle
        brandName.text = catNameTitle

        update(count: 1)
        
        if storeFlag == false {
            categoryNameTitle.isHidden = false
            storeView.isHidden = true
//            stackviewheight.constant = 50
//            videossection.isHidden = true


        } else {
            categoryNameTitle.isHidden = true
            storeView.isHidden = false

        }
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               let vc = Live_VC.getVC(.main)
               self.navigationController?.pushViewController(vc, animated: false)
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
        self.LanguageRender()
        homeswitchbtn.isOn = false
    }
    
    func LanguageRender(){
        followBtn.setTitle("follow".pLocalized(lang: LanguageManager.language), for: .normal)
        viewAll.setTitle("viewall".pLocalized(lang: LanguageManager.language), for: .normal)
        videosLbl.text = "videos".pLocalized(lang: LanguageManager.language)

        productSortByLbl.text = "productsortby".pLocalized(lang: LanguageManager.language)
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
    }
    
    private func getStreamingVideos(userId:String,limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:userId, city: "",completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
                self?.LiveStreamingResultsdata = res.results ?? []
                
                if(self?.LiveStreamingResultsdata.count ?? 0 > 0){
                    self?.stackviewheight.constant = 260
//                    self?.videoLabelView.isHidden = true
                    self?.videossection.isHidden = false
                }else{
                    if self?.storeFlag == false {
                        self?.stackviewheight.constant = 10
                    }else {
                        self?.stackviewheight.constant = 40
                    }
//                    self?.videoLabelView.isHidden = false
                    self?.videossection.isHidden = true

                }
                self?.videosection_collectionview.reloadData()
             

            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    func setupSwipeGesture() {
        pagecontrol.pageIndicatorTintColor = UIColor.red
        pagecontrol.currentPageIndicatorTintColor = UIColor.orange

        pagecontrol.currentPage += 1

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        videosection_collectionview.addGestureRecognizer(swipeGesture)
    }

    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: videosection_collectionview)
       
    }


    
    func update(count:Int) {
        if storeFlag == false {
            getAllProductsByCategories(limit: 20, page: count, sortBy:sort, category:prductid, active: false)
        }else{
            getAllProductsByCategoriesbyid(limit: 20, page: count, sortBy:sort, category:prductid, active: false)
        }
    }

    func setupCollectionView() {
                let nib = UINib(nibName: "PRoductCategory_cell", bundle: nil)
                categoryproduct_collectionview.register(nib, forCellWithReuseIdentifier: "PRoductCategory_cell")
                categoryproduct_collectionview.delegate = self
                categoryproduct_collectionview.dataSource = self

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
                    
                  print(res)
//                    if self?.getAllProductsByCategoriesData.count == 1 {
//                        let ll = (self?.getAllProductsByCategoriesData.count ?? 0)  * 240
//                        let hh = 60 + (self?.stackviewheight.constant ?? 0)
//                        self?.scrollheight.constant = CGFloat(hh + CGFloat(ll) + 20)
//                       
//                        self?.categoryproduct_collectionview.reloadData()
//                    }else {
                        let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 240
                        let hh = 60 + (self?.stackviewheight.constant ?? 0)
                        self?.scrollheight.constant = CGFloat(hh + CGFloat(ll) + 20)
                       
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
                    
                    let ll = ((self?.getAllProductsByCategoriesData.count ?? 0) / 2) * 240
                    let hh = 60 + (self?.stackviewheight.constant ?? 0)
                    self?.scrollheight.constant = CGFloat(hh + CGFloat(ll) + 20)
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
            case .success(let res):
              print(res)
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
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    self?.view.makeToast(error)
                }
            }
        }
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
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    self?.view.makeToast(error)
                }
            }
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
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    if error == "Not found" {
                        
                    }else {
//                        self?.view.makeToast(error)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func cartbtn(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func bellIconBtnTapped(_ sender: Any) {
        
        AppDefault.brandname = catNameTitle
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Do you want to video call \(self.brandName.text ?? "")?", heading: "Request Call", note: "Note: Make sure to be available for next 30 mins", miscid: "", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Request Call") { token, id in
            self.chinesebell(sellerId:self.prductid , brandName: self.catNameTitle, description: "sellerDescription")
        }
//            appDelegate.ChineseShowCustomerAlertControllerHeight(title: "You want to send request \(self.brandName.text ?? "") to do video call?", miscid: "", btn1Title: "Cancel", btn1Callback: {
//                
//            }, btn2Title: "Send Request") { token, id in
//                print("click")
//              
//                
//            }
        }
    
    
    @IBAction func followBtnTapped(_ sender: Any) {
        if(isFollow){
            unfollowStore(storeId: self.storeId)
        }else{
            followStore(storeId: self.storeId, web: true)
        }
       
    
    }
    
    @IBAction func viewAllBtnTapped(_ sender: Any) {
        let vc = New_SingleVideoview.getVC(.sidemenu)
        vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
        vc.indexValue = 0
        self.navigationController?.pushViewController(vc, animated: false)

    }
}

extension Category_ProductsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videosection_collectionview {
            return  self.LiveStreamingResultsdata.count
        }else {
            return self.getAllProductsByCategoriesData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videosection_collectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoSection_cell", for: indexPath) as! VideoSection_cell
            let data =  self.LiveStreamingResultsdata[indexPath.row]
            cell.backgroundImage.pLoadImage(url: data.thumbnail ?? "")
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PRoductCategory_cell", for: indexPath) as! PRoductCategory_cell
           let data =  self.getAllProductsByCategoriesData[indexPath.row]
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
        }
        
      
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollPos = scrollView.contentOffset.x / view.frame.width
//        pagecontrol.currentPage = Int(scrollPos)
//
//    }
//    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryproduct_collectionview{
            let data =  self.getAllProductsByCategoriesData[indexPath.row]
            
            let vc = NewProductPageViewController.getVC(.sidemenu)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
            self.navigationController?.pushViewController(vc, animated: false)
        } else{
            let vc = New_SingleVideoview.getVC(.sidemenu)
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
            vc.indexValue = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == videosection_collectionview
        {
            return CGSize(width: self.videosection_collectionview.frame.width/2.2, height: self.videosection_collectionview.frame.height/0.5)
        }
        else{
            return CGSize(width: self.categoryproduct_collectionview.frame.width/2.1-2, height: 230)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    }
    
    }
    
    

extension Category_ProductsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == videosection_collectionview {
            let scrollPos = scrollView.contentOffset.x / view.frame.width
            pagecontrol.currentPage = Int(scrollPos)
        } else {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            // If user scrolls to the bottom
            if offsetY > contentHeight - height {
                // Call your function to load more products
                loadMoreProducts()
            }
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
