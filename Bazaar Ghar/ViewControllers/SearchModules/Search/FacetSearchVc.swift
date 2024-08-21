//
//  FacetSearchVc.swift
//  Bazaar Ghar
//
//  Created by Zany on 16/08/2024.
//

import UIKit
import Typesense


class FacetSearchVc: UIViewController, UISearchResultsUpdating {
    @IBOutlet weak var productCounts: UILabel!
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
       @IBOutlet weak var noDataView: UIView!
    var hits: [SearchResultHit<Recipe>]
    var facetCounts: [FacetCounts]?
    var page : Int?
    var Cat0Model:  FacetCounts? = nil
    
    var Cat1Model:  FacetCounts? = nil
       var DisplayCat0Model:  FacetCounts? = nil
       var Cat2Model:  FacetCounts? = nil
       var StoreModel:  FacetCounts? = nil
       var ColorModel:  FacetCounts? = nil
       var priceModel:  FacetCounts? = nil
       var sizeModel:  FacetCounts? = nil
       var RatingmOdel:  FacetCounts? = nil
       var StyleModel:  FacetCounts? = nil
    
    // Your other properties
    let searchController = UISearchController(searchResultsController: nil)
    let client: Client
    
    required init?(coder aDecoder: NSCoder) {
        let config = Configuration(nodes: [Node(host: "search.bazaarghar.com", port: "443", nodeProtocol: "https")], apiKey: "LCbCEFm08YKiZ47ldPc4OuVcvnhOF9tV")
        self.client = Client(config: config)
        self.hits = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Recipes 🥘"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        lastRandomProductsCollectionView.delegate = self
                lastRandomProductsCollectionView.dataSource = self
                lastRandomProductsCollectionView.register(UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
              
        
        if(hits.count == 0){
                    noDataView.isHidden = true
                }else{
                    noDataView.isHidden = false
                }
//                if(AppDefault.islogin ){
//        
//                    if AppDefault.wishlistproduct != nil{
//                        wishList(isbackground: true)
//                    }else{
//                        wishList(isbackground: false)
//                    }
//        
//        
//                    }
    }
    @IBAction func filterButtonTap(_ sender: Any) {
           let vc = StoreFilters_ViewController.getVC(.searchStoryBoard)
        
           vc.delegate = self
           vc.Cat0Model = Cat0Model
           vc.Cat1Model = Cat1Model
           vc.Cat2Model = Cat2Model
           vc.StoreModel = StoreModel
           vc.ColorModel = ColorModel
           vc.priceModel = priceModel
           vc.sizeModel = sizeModel
           vc.RatingmOdel = RatingmOdel
           vc.StyleModel = StyleModel
   
           vc.DisplayCat0Model = self.DisplayCat0Model
   
   
           vc.modalPresentationStyle = .overFullScreen
           self.present(vc, animated: true, completion: nil)
   //        self.navigationController?.pushViewController(vc, animated: false)
   
   
       }
    
    func updateSearchResults(for searchController: UISearchController) {
           guard let text = searchController.searchBar.text else {
               return
           }
        performSearch(with: text,page:1, faceby: "")
       }
       
    func performSearch(with query: String,page:Int,faceby:String) {
        
        
        
        
        
           let searchParameters = SearchParameters(
               q: query,
               
               queryBy: "productName",
               filterBy:faceby, facetBy: "averageRating,brandName,color,lvl0,price,size,style",
               maxFacetValues: 250, page: page, perPage: 10
               
           )
           
           Task {
            do {
                let (searchResult, _) = try await client.collection(name: "db_live_products").documents().search(searchParameters, for: Recipe.self)
                self.facetCounts = searchResult?.facetCounts
            self.hits +=  searchResult?.hits ?? []
                
                
                
                
                for item in searchResult?.facetCounts ?? []{
                    if(item.fieldName == "lvl0"){
                        self.Cat0Model = item
                                    }
                    if(item.fieldName == "lvl1"){
                                        self.Cat1Model = item
                                    }
                                    if(item.fieldName == "lvl2"){
                                        self.Cat2Model = item
                                    }
                                    if(item.fieldName == "color"){
                                        self.ColorModel = item
                                    }
                                    if(item.fieldName == "brandName"){
                                        self.StoreModel = item
                                    }
                                    if(item.fieldName == "averageRating"){
                                        self.RatingmOdel = item
                                    }
                    if(item.fieldName == "price"){
                                        self.priceModel = item
                                    }
                                     if(item.fieldName == "size"){
                                        self.sizeModel = item
                                    }
                                    if(item.fieldName == "style"){
                                       self.StyleModel = item
                                   }
                                }
                
                
                if(self.Cat0Model?.counts?.count == 1 && self.Cat0Model?.counts?.count != 0 ){
                
                    self.DisplayCat0Model = self.Cat1Model
                
                
                
                
                                }else{
                                    self.DisplayCat0Model = self.Cat0Model
                                }
                
                if(self.Cat1Model?.counts?.count == 1 && self.Cat1Model?.counts?.count != 0 ){
                
                    self.DisplayCat0Model = self.Cat2Model
                
                
                                }else{
                                    if(self.Cat0Model?.counts?.count == 0){
                                        self.DisplayCat0Model = self.Cat1Model
                                    }
                
                                }
                
                
                                
   
    
               
                
                productCounts.text = String(searchResult?.found ?? 0)
                lastRandomProductsCollectionView.reloadData()
                // Handle the search result
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
extension FacetSearchVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hits.count ?? 0
        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = hits[indexPath.row].document
        Utility().setGradientBackground(view: cell.percentBGView, colors: [primaryColor, primaryColor, headerSecondaryColor])
        
        cell.productimage.pLoadImage(url: data?.mainImage ?? "")
        cell.productname.text = data?.productName
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
//        cell.heartBtn.tag = indexPath.row
//        cell.cartButton.tag = indexPath.row
//        cell.cartButton.addTarget(self, action: #selector(cartButtonTap(_:)), for: .touchUpInside)
//        cell.heartBtn.addTarget(self, action: #selector(homeLatestMobileheartButtonTap(_:)), for: .touchUpInside)
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
        
            return cell
        }

    
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
    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
  
   

       // This method is called when the user lifts their finger and scrolling might continue
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Check if the scroll view has reached the bottom
        if offsetY > contentHeight - frameHeight {
            // Call your API
            page = (page ?? 0) + 1
            performSearch(with: searchController.searchBar.text ?? "*", page: page ?? 1, faceby: "")
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: lastRandomProductsCollectionView.frame.width/2.2-5, height:300)

    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = foundData?[indexPath.row].document
//        let vc = NewProductPageViewController.getVC(.productStoryBoard)
////                vc.isGroupBuy = false
//                   vc.slugid = data?.slug
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
    }
}


extension FacetSearchVc: StoreFilters_ViewControllerDelegate{
    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController, facetby: String, filterby: String) {
      
        self.hits.removeAll()
        self.page = 1
        performSearch(with: searchController.searchBar.text ?? "*", page: page ?? 1, faceby: facetby)
    }
    
 

}

