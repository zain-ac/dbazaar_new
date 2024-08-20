////
////  RealTimeSearchViewController.swift
////  Bazaar Ghar
////
////  Created by Zany on 12/07/2024.
////
//
//import UIKit
//import Alamofire
// 
//class RealTimeSearchViewController: UIViewController {
//   
//    @IBOutlet weak var productCounts: UILabel!
//    private var results: [String] = []
//    var  facetCounts: [TypeSenseFacetCount] = []
//    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
//    var searchText: String? {
//        didSet {
//            productcategoriesApi(val: "", str: searchText ?? "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//            
//        }
//    }
//    @IBOutlet weak var filterButton: UIButton!
//    @IBOutlet weak var noDataView: UIView!
//    var DisplayCat0Model:  TypeSenseFacetCount? = nil
//    var Cat0Model:  TypeSenseFacetCount? = nil
//    var Cat1Model:  TypeSenseFacetCount? = nil
//    var Cat2Model:  TypeSenseFacetCount? = nil
//    var StoreModel:  TypeSenseFacetCount? = nil
//    var ColorModel:  TypeSenseFacetCount? = nil
//    var priceModel:  TypeSenseFacetCount? = nil
//    var sizeModel:  TypeSenseFacetCount? = nil
//    var RatingmOdel:  TypeSenseFacetCount? = nil
//    var StyleModel:  TypeSenseFacetCount? = nil
////    var typeSenseData : TypeSenseModel?
//    let centerTransitioningDelegate = CenterTransitioningDelegate()
//
//    var hits: [TPHit]? = []
//    @IBOutlet weak var searchFeild: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        lastRandomProductsCollectionView.delegate = self
//        lastRandomProductsCollectionView.dataSource = self
//        lastRandomProductsCollectionView.register(UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
//        productcategoriesApi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//        hitsapi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//        if(hits?.count == 0){
//            noDataView.isHidden = true
//        }else{
//            noDataView.isHidden = false
//        }
//        if(AppDefault.islogin ){
//            
//            if AppDefault.wishlistproduct != nil{
//                wishList(isbackground: true)
//            }else{
//                wishList(isbackground: false)
//            }
//            
//            
//            }
//
//        // Do any additional setup after loading the view.
//    }
//    func wishList(isbackground:Bool){
//        APIServices.wishlist(isbackground: isbackground){[weak self] data in
//          switch data{
//          case .success(let res):
//           print(res)
//            AppDefault.wishlistproduct = res.products
//   
////            self?.homeLastProductCollectionView.reloadData()
//              self?.lastRandomProductsCollectionView.reloadData()
//          case .failure(let error):
//            print(error)
//          }
//        }
//      }
//    @IBAction func filterButtonTap(_ sender: Any) {
//        let vc = StoreFilters_ViewController.getVC(.searchStoryBoard)
//
//        vc.delegate = self
//        vc.Cat0Model = Cat0Model
//        vc.Cat1Model = Cat1Model
//        vc.Cat2Model = Cat2Model
//        vc.StoreModel = StoreModel
//        vc.ColorModel = ColorModel
//        vc.priceModel = priceModel
//        vc.sizeModel = sizeModel
//        vc.RatingmOdel = RatingmOdel
//        vc.StyleModel = StyleModel
//        
//        vc.DisplayCat0Model = self.DisplayCat0Model
//        
//   
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true, completion: nil)
////        self.navigationController?.pushViewController(vc, animated: false)
//
//      
//    }
//    override func dismissViewController(_ sender: UIButton) {
//        AppDefault.facetFilterArray = []
//    }
//    override func popViewController(_ sender: UIButton) {
//        AppDefault.facetFilterArray = []
//    }
//    override func viewWillAppear(_ animated: Bool) {
//      
//
//    }
//     
// 
//    
//    private func productcategoriesApi(val:String, str: String,facet_by:String){
//       
//        APIServices.typeSenseApi(val:val, txt: str ,facet_by:facet_by,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                self?.hits =  []
//                AppDefault.facetFilters = res
//                
//                for item in res.first?.facetCounts ?? []{
//                    if(item?.fieldName == "lvl0"){
//                        self?.Cat0Model = item
//                    }
//                    if(item?.fieldName == "lvl1"){
//                        self?.Cat1Model = item
//                    }
//                    if(item?.fieldName == "lvl2"){
//                        self?.Cat2Model = item
//                    }
//                    if(item?.fieldName == "color"){
//                        self?.ColorModel = item
//                    }
//                    if(item?.fieldName == "brandName"){
//                        self?.StoreModel = item
//                    }
//                    if(item?.fieldName == "averageRating"){
//                        self?.RatingmOdel = item
//                    }
//                    if(item?.fieldName == "price"){
//                        self?.priceModel = item
//                    }
//                     if(item?.fieldName == "size"){
//                        self?.sizeModel = item
//                    }
//                    if(item?.fieldName == "style"){
//                       self?.StyleModel = item
//                   }
//                }
//                
//                
//                if(self?.Cat0Model?.counts?.count == 1 && self?.Cat0Model?.counts?.count != 0 ){
//                
//                    self?.DisplayCat0Model = self?.Cat1Model
//                    
//                    
//                    
//                    
//                }else{
//                    self?.DisplayCat0Model = self?.Cat0Model
//                }
//                
//                if(self?.Cat1Model?.counts?.count == 1 && self?.Cat1Model?.counts?.count != 0 ){
//                
//                    self?.DisplayCat0Model = self?.Cat2Model
//                    
//                    
//                }else{
//                    if(self?.Cat0Model?.counts?.count == 0){
//                        self?.DisplayCat0Model = self?.Cat1Model
//                    }
//                    
//                }
//                
//                
//                
//                
//                
//                
//                
//                
//                for i in res {
//                                 
//                    for j in i.hits ?? []{
//                                     self?.hits?.append(j)
//                                 }
//                             }
//                
//                
//                
//                self?.productCounts.text = "\(self?.hits?.count ?? 0) items Found"
//                
//
////                for r in res {
////                    for z in r.facetCounts ?? [] {
////                        self?.facetCounts.append(z!)
////                    }
////                }
//                
//                DispatchQueue.main.async {
//                    self?.lastRandomProductsCollectionView.reloadData()
//                }
////                DispatchQueue.main.async {
////                    self?.lastRandomProductsCollectionView.reloadData()
////                }
//                print(res)
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
//    private func hitsapi(val:String, str: String,facet_by:String){
//        APIServices.TPHitsApi(val:val, txt: str ,facet_by:facet_by,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                
//                
////                for i in res {
////                    for j in i.hits ?? []{
////                        self?.hits?.append(j)
////                    }
////                }
//                
////                for i in res {
////                    for j in i.results ?? [] {
////                        self?.hits.append(contentsOf: j.hits!)
////                    }
////                }
////                for r in res {
////                    for z in r.facetCounts ?? [] {
////                        self?.facetCounts.append(z!)
////                    }
////                }
//                
//                
//                DispatchQueue.main.async {
//                    self?.lastRandomProductsCollectionView.reloadData()
//                }
//                print(res)
//            case .failure(let error):
//                print(error)
//                self?.view.makeToast(error)
//            }
//        })
//    }
//    private func wishListApi(productId:String) {
//        APIServices.newwishlist(product:productId,completion: {[weak self] data in
//          switch data{
//          case .success(let res):
//            print(res)
//    //        if(res == "OK"){
//    //          button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//    //          button.tintColor = .red
//    //
//    //        }else{
//    //          button.setImage(UIImage(systemName: "heart"), for: .normal)
//    //          button.tintColor = .gray
//    //
//    //        }
//              self?.wishList(isbackground: false)
//          case .failure(let error):
//            print(error)
//              if error == "Please authenticate" {
//                  if AppDefault.islogin{
//                      
//                  }else{
////                       DispatchQueue.main.async {
////                          self.selectedIndex = 0
////                       }
//                        let vc = PopupLoginVc.getVC(.popups)
//                      vc.modalPresentationStyle = .overFullScreen
//                      self?.present(vc, animated: true, completion: nil)
//                  }
//              }
//          }
//        })
//      }
//   
//    @IBAction func searchButton(_ sender: Any) {
//        if(searchFeild.text?.count == 0){
//            self.view.makeToast("Please Enter Text")
//        }else{
//            productcategoriesApi(val: "", str: searchFeild.text ?? "",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
//        }
//    }
//    
//}
//extension RealTimeSearchViewController: StoreFilters_ViewControllerDelegate{
//    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController, withData data: [TypeSenseResult]) {
//        print("Received data from child: \(data)")
//        self.hits?.removeAll()
//        self.hits = data.first?.hits ?? []
//        if(data.first?.hits?.count == 0){
//            noDataView.isHidden = false
//        }else{
//            noDataView.isHidden = true
//        }
//
//        self.lastRandomProductsCollectionView.reloadData()
//    }
//    
//    
//}
//
//extension RealTimeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return hits?.count ?? 0
//        
//        }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
//        let data = hits?[indexPath.row].document
//        Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
//        cell.product = data
//        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
////            cell.productname.text = data.productName
//        if LanguageManager.language == "ar"{
//            cell.productname.text = data?.lang?.ar?.productName
//        }else{
//            cell.productname.text =  data?.productName
//        }
//        
//        if data?.onSale == true {
//            cell.discountPrice.isHidden = false
//            cell.productPrice.isHidden = false
//            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0))
//            cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0)
//            cell.productPriceLine.isHidden = false
//            cell.productPrice.textColor = UIColor.red
//            cell.productPriceLine.backgroundColor = UIColor.red
//            cell.percentBGView.isHidden = false
//        }else {
//            cell.productPriceLine.isHidden = true
//            cell.productPrice.isHidden = true
//            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0))
//            cell.percentBGView.isHidden = true
//         }
//        if(data?.variants?.count != 0 && data?.quantity != 0){
//            cell.cartButton.tag = indexPath.row
//            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
//        }else if(data?.variants?.count != 0 && data?.quantity == 0){
//            let vc  = NewProductPageViewController.getVC(.productStoryBoard)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else if(data?.variants?.count == 0 && data?.quantity != 0){
//            cell.cartButton.tag = indexPath.row
//            cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
//        }else{
//            let vc  = NewProductPageViewController.getVC(.productStoryBoard)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
////        cell.heartBtn.tag = indexPath.row
//        cell.cartButton.tag = indexPath.row
//        cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
////        cell.heartBtn.addTarget(self, action: #selector(homeLatestMobileheartButtonTap(_:)), for: .touchUpInside)
//        
//        if let wishlistProducts = AppDefault.wishlistproduct {
//            if wishlistProducts.contains(where: { $0.id == data?._id }) {
//                  cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                  cell.heartBtn.tintColor = .red
//                } else {
//                  cell.backgroundColor = .white
//                  cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//                  cell.heartBtn.tintColor = .white
//                }
//              }
//        
//            return cell
//        }
//    
//    @objc func cartButtonTap(_ sender: UIButton) {
//        let data = hits?[sender.tag].document
//        
//        
//        
//        if (data?.variants?.first?.id == nil) {
//            let vc = CartPopupViewController.getVC(.popups)
//           
//            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = centerTransitioningDelegate
//            vc.products = data
//            vc.nav = self.navigationController
//            self.present(vc, animated: true, completion: nil)
//        }else {
//            let vc = NewProductPageViewController.getVC(.productStoryBoard)
//            vc.slugid = data?.slug
//            navigationController?.pushViewController(vc, animated: false)
//        }
//
//    }
//    @objc func homeLatestMobileheartButtonTap(_ sender: UIButton) {
//        if(AppDefault.islogin){
//              let index = sender.tag
//            let item = hits?[index].document
//            if item?.id == nil {
//                self.wishListApi(productId: (item?._id ?? ""))
//            }else {
//                self.wishListApi(productId: (item?.id ?? ""))
//            }            }else{
//                let vc = PopupLoginVc.getVC(.popups)
//              vc.modalPresentationStyle = .overFullScreen
//              self.present(vc, animated: true, completion: nil)
//            }
//    }
//    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//       
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//       
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: lastRandomProductsCollectionView.frame.width/2.2-5, height:300)
//
//    
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = hits?[indexPath.row].document
//        let vc = NewProductPageViewController.getVC(.productStoryBoard)
////                vc.isGroupBuy = false
//                   vc.slugid = data?.slug
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        
//    }
//}
//
