//
//  ProductSearch_VC.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 06/09/2023.
//

import UIKit

class ProductSearch_VC: UIViewController {
    @IBOutlet weak var productsearchcollection: UICollectionView!

    @IBOutlet weak var notFound: UILabel!

    var searchproductdata: [SearchProductResult] = []

    var searchText: String? {
        didSet{
            searchproduct(name: "productName" , limit: 40, page: 1, value: searchText ?? "")

        }
    }
    var isEndReached = false
    var isLoadingNextPage = false
    var categoryPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }
    override func viewWillAppear(_ animated: Bool) {
        notFound.isHidden = true
        self.searchproductdata = []
        searchproduct(name: "productName" , limit: 40, page: 1, value: searchText ?? "")
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HomeLastProductCollectionViewCell", bundle: nil)
        productsearchcollection.register(nib, forCellWithReuseIdentifier: "HomeLastProductCollectionViewCell")
        productsearchcollection.delegate = self
        productsearchcollection.dataSource = self
    }

    
    
    private func searchproduct(name:String,limit:Int,page:Int,value:String){
        APIServices.searchproduct(name:name,limit:limit,page:page,value:value){[weak self] data in
            switch data{
            case .success(let res):

                if res.count > 0 {
                    self?.notFound.isHidden = true
                }else {
                    self?.notFound.isHidden = false
                }
                self?.searchproductdata.append(contentsOf: res)
                self?.categoryPage += 1
                self?.isLoadingNextPage = false
              print(res)
                self?.productsearchcollection.reloadData()
            case .failure(let error):
                print(error)
                self?.isLoadingNextPage = false

            }
        }
    }
    
    

}
extension ProductSearch_VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchproductdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
        let data = searchproductdata[indexPath.row]
            Utility().setGradientBackground(view: cell.percentBGView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        cell.productimage.pLoadImage(url: data.mainImage ?? "")
        cell.productname.text =  data.productName
        cell.productPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
        if data.onSale == true {
                cell.discountPrice.isHidden = false
                cell.discountPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0)
                cell.productPriceLine.isHidden = false
                cell.productPrice.textColor = UIColor.red
                cell.discountPrice.textColor = UIColor(hexString: "#069DDD")
                cell.productPriceLine.backgroundColor = UIColor.red
                
            }else {
                cell.discountPrice.isHidden = true
                cell.productPriceLine.isHidden = true
                cell.productPrice.textColor = UIColor(hexString: "#069DDD")

             }
            
            
            
            
            return cell
        }
    
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLastProductCollectionViewCell", for: indexPath) as! HomeLastProductCollectionViewCell
//        let data = searchproductdata[indexPath.row]
//        
//        cell.productimage.pLoadImage(url: data.mainImage ?? "")
//        cell.productname.text = data.productName
//        if data.onSale == true {
//            cell.discountPrice.isHidden = false
//            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0)
//            cell.productPriceLine.isHidden = false
//            cell.productPrice.textColor = UIColor.systemGray3
//
//        }else {
//            cell.discountPrice.isHidden = true
//            cell.productPriceLine.isHidden = true
//            cell.productPrice.textColor = UIColor.black
//        }
//        cell.productPrice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
//
//        return cell
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchproductdata[indexPath.row]
        let vc = NewProductPageViewController.getVC(.sidemenu)
//            vc.isGroupBuy = false
            vc.slugid = data.slug
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productsearchcollection.frame.width/2-5, height: productsearchcollection.frame.height/2-5)
//        return CGSize(width: self.productsearchcollection.frame.width/2.1, height: self.productsearchcollection.frame.height/2.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
            return 5
      
    }
}
extension ProductSearch_VC: UIScrollViewDelegate {
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
        searchproduct(name: "productName" , limit: 40, page: categoryPage , value: searchText ?? "")
    }
}
