//
//  RealTimeSearchViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 12/07/2024.
//

import UIKit
import Alamofire

class RealTimeSearchViewController: UIViewController {
    private var results: [String] = []
    @IBOutlet weak var lastRandomProductsCollectionView: UICollectionView!


    var typeSenseData : TypeSenseModel?
var hits: [TypeSenseDocument] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        lastRandomProductsCollectionView.delegate = self
        lastRandomProductsCollectionView.dataSource = self
        lastRandomProductsCollectionView.register(UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")

      

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        productcategoriesApi()
//        search { result in
//                   switch result {
//                   case .success(let typeSenseModel):
//                       for i in typeSenseModel.results {
//                           self.hits?.append(contentsOf: i.hits)
//                       }
//                       DispatchQueue.main.async {
//                           self.lastRandomProductsCollectionView.reloadData()
//                       }
//                   case .failure(let error):
//                       print("Error: \(error)")
//                   }
//               }
    }
     
    
//    func search(completion: @escaping (Result<TypeSenseModel>) -> Void) {
//        let parameters: [String: Any] = [
//            "searches": [
//                [
//                    "query_by": "productName",
//                    "highlight_full_fields": "productName",
//                    "collection": "bg_stage_products",
//                    "q": "samsung s24",
//                    "facet_by": "averageRating,brandName,color,lvl0,price,size,style",
////                    "filter_by": "brandName:=[`AL Fajar Crockery`]",
//                    "max_facet_values": 1,
//                    "page": 1,
//                    "per_page": 1
//                ]
//            ]
//        ]
//
//        let url = "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn"
//
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
//            .responseJSON { response in
//                switch response.result {
//                case .success(let data):
//                    
//                    
//                    print("data of typense:\(data)")
//                case .failure(let error):
//                    print(error)
//                }
//            }
//    }

    
    private func productcategoriesApi(){
        APIServices.typeSenseApi(completion: {[weak self] data in
            switch data{
            case .success(let res):
                for i in res {
                    for j in i.hits! {
                        self?.hits.append(j.document!)
                    }
                }
                DispatchQueue.main.async {
                    self?.lastRandomProductsCollectionView.reloadData()
                }
                print(res)
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func searchButton(_ sender: Any) {
       
    }
    
}

extension RealTimeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hits.count ?? 0
        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = hits[indexPath.row]
        cell.productimage.pLoadImage(url: data.mainImage ?? "")
        cell.productname.text = data.productName
        if data.onSale == true {
                cell.discountPrice.isHidden = false
            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(data.salePrice ?? 0))
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.discountPrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red
                
            } else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor(hexString: "#069DDD")
            }
//            
//                cell.wishlisticon.tag = indexPath.row
//                cell.wishlisticon.addTarget(self, action: #selector(wishlistTap(sender:)), for: .touchUpInside)
            
          
        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(data.regularPrice ?? 0))
//            for i in AppDefault.wishlistproduct ?? []{
//                if i.id == data._id {
//                    cell.wishlisticon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    cell.wishlisticon.tintColor = .red
//                }else {
////                    cell.wishlisticon.setImage(UIImage(systemName: "heart"), for: .normal)
////                    cell.wishlisticon.tintColor = .gray
//                }
//            }

            return cell
        }
    
//    @objc func increment(sender: UIButton){
//        if(AppDefault.islogin){
//            let index =  sender.tag
//            let item = randomproductapiModel.first?.product?[index]
//            self.wishListApi(productId: (item?.id ?? ""))
//        }else{
//            let vc = PopupLoginVc.getVC(.main)
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
//        
//        
//    }
    
//    @objc func wishlistTap(sender: UIButton){
//        if(AppDefault.islogin){
//            let index =  sender.tag
//            let item = getrandomproductapiModel[index]
//            self.wishListApi(productId: (item._id ?? ""))
//        }else{
//            let vc = PopupLoginVc.getVC(.main)
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
//       
//    }
//    private func wishListApi(productId:String) {
//        APIServices.newwishlist(product:productId,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//                print(res)
////                if(res == "OK"){
////                    button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
////                    button.tintColor = .red
////
////                }else{
////                    button.setImage(UIImage(systemName: "heart"), for: .normal)
////                    button.tintColor = .gray
////
////                }
//                self?.wishList()
//            
//            case .failure(let error):
//                print(error)
////                self?.view.makeToast(error)
//            }
//        })
//    }
    func applyGradientBackground(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
               return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == imageslidercollectionview {
//            let data = self.bannerapidata?[indexPath.row]
//            if data?.type == "" || data?.type == nil {
//                
//            }else {
//                switch data?.type {
//                    
//                  case "Market":
//                    let vc = StoreSearchVC.getVC(.main)
//                    vc.isMarket = true
//                    vc.marketID = data?.linkId
//                    vc.isNavBar = false
//                    self.navigationController?.pushViewController(vc, animated: false)
//
//                  case "Store":
//                    if data?.linkId == "" || data?.linkId == nil {
//                        
//                    }else {
//                        let vc = Category_ProductsVC.getVC(.main)
//                        vc.prductid = data?.linkId ?? ""
//                        vc.catNameTitle = data?.name ?? ""
//                        vc.storeFlag = true
//                    
//                        vc.storeId = data?.linkId ?? ""
//                        vc.video_section = true
//                        self.navigationController?.pushViewController(vc, animated: false)
//                    }
//
//                  case "Category":
//                    if data?.linkId == "" || data?.linkId == nil {
//                        
//                    }else {
//                        let vc = Category_ProductsVC.getVC(.main)
//                        vc.prductid = data?.linkId ?? ""
//                        vc.video_section = false
//                        vc.storeFlag = false
//                        vc.catNameTitle = data?.name ?? ""
//                        self.navigationController?.pushViewController(vc, animated: false)
//                    }
//                    
//                  case "Product":
//                    if data?.linkId == "" || data?.linkId == nil {
//                        
//                    }else {
//                        let vc = ProductDetail_VC.getVC(.main)
//                        vc.isGroupBuy = false
//                        vc.slugid = data?.linkId
//                        self.navigationController?.pushViewController(vc, animated: false)
//                    }
//                    
//                  case "Video":
//                    let vc = Live_VC.getVC(.main)
//                    self.navigationController?.pushViewController(vc, animated: false)
//                    
//                  case "Page":
//                    print("page")
//                      let vc = Page_Vc.getVC(.main)
//                    vc.collectionId = data?.linkId ?? ""
//                      self.navigationController?.pushViewController(vc, animated: false)
//
//                  default:
//                        print("Invalid data")
//                }
//            }
//
//            
//        }else if collectionView == homeLastProductCollectionView {
////            let data = randomproductapiModel.first?.product?[indexPath.row]
//            let vc = NewProductPageViewController.getVC(.sidemenu)
////                vc.isGroupBuy = false
////            vc.slugid = data?.slug
//            self.navigationController?.pushViewController(vc, animated: false)
//        }else if collectionView == hotDealCollectionV {
//            let data = groupbydealsdata[indexPath.row]
//            let vc = ProductDetail_VC.getVC(.main)
//            vc.isGroupBuy = true
//            vc.groupbydealsdata = data
//            vc.slugid = data.productID?.slug
//            self.navigationController?.pushViewController(vc, animated: false)
//        } else if collectionView == lastRandomProductsCollectionView {
//            let data = getrandomproductapiModel[indexPath.row]
//
//            let vc = ProductDetail_VC.getVC(.main)
//            vc.isGroupBuy = false
//            vc.slugid = data.slug
//            self.navigationController?.pushViewController(vc, animated: false)
//        }else {
//              let data = CategoriesResponsedata[indexPath.row]
//
//              let vc = Category_ProductsVC.getVC(.main)
//              vc.prductid = data.id ?? ""
//              vc.video_section = false
//              vc.storeFlag = false
//              vc.catNameTitle = data.name ?? ""
//              self.navigationController?.pushViewController(vc, animated: false)
//          }
//        
//    }
    
}

