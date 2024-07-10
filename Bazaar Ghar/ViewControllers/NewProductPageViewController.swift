//
//  NewProductPageViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 08/07/2024.
//

import UIKit
import FSPagerView

class NewProductPageViewController: UIViewController {
    @IBOutlet weak var deliveryTableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!

    
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
    var slugid: String?
    var gallaryImages: [String]?
    var mainImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        bannerApi(isbackground: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productcategoriesdetails(slug: slugid ?? "")
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

    private func productcategoriesdetails(slug:String){
        APIServices.productcategoriesdetails(slug: slug){[weak self] data in
            switch data{
            case .success(let res):
              print(res)
                self?.headerLbl.text = res.productName
                self?.mainImage = res.mainImage
                self?.gallaryImages = res.gallery
                self?.pagerView.reloadData()
                if res.regularPrice == nil || res.salePrice == nil {
                
                }else {
                    let percentValue = (((res.regularPrice ?? 0) - (res.salePrice ?? 0)) * 100) / (res.regularPrice ?? 0)
                    self?.percentLbl.text = String(format: "%.0f%% OFF", percentValue)
                }
//                self?.wishlist()

//                if res.quantity ?? 0 > 0 {
//                    self?.quantityView.isHidden = false
//                    self?.outOfStockLbl.isHidden = true
//                    self?.buyNowBtn.isEnabled = true
//                }else {
//                    self?.quantityView.isHidden = true
//                    self?.outOfStockLbl.isHidden = false
//                    self?.buyNowBtn.isEnabled = false
//                }
//                
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
//                    self?.Salesprice.textColor = UIColor(hexString: "#069DDD")
//                    self?.productPriceLine.backgroundColor = UIColor.red
//
//                }else {
//                    self?.Salesprice.isHidden = true
//                    self?.OnSaleimage.isHidden = true
//                    self?.productPriceLine.isHidden = true
//                    self?.Regularprice.textColor = UIColor(hexString: "#069DDD")
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
    
    @IBAction func cartBtnTapped(_ sender: Any) {
        let vc = CartViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
        }


}

extension NewProductPageViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if ((gallaryImages?.isEmpty) != nil){
            return  gallaryImages?.count ?? 0
        }else {
            return 2
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
        //        if pagerView == self.pagerView {
        //            let currentIndex = pagerView.currentIndex
        //            pageControl.currentPage = currentIndex
        //        }else {
        //            let currentIndex = pagerView.currentIndex
        //            pageControl.currentPage = currentIndex
        //        }
        
    }
}
    
extension NewProductPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return items.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data  = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDellivevryTableViewCell", for: indexPath) as! ProductDetailsDellivevryTableViewCell
        cell.img.image = data.image
        cell.title.text = data.title
        cell.subtitle.text = data.subtitle
  
            return cell
           
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            return 67
        
    }
}
struct Item {
    let image: UIImage
    let title: String
    let subtitle: String
}
