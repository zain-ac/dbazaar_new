//
//  CartStoreLableCell.swift
//  Bazaar Ghar
//
//  Created by Zany on 30/08/2023.
//

import UIKit

class CartStoreLableCell: UITableViewCell {
    @IBOutlet weak var cartStoreTableView: UITableView!
 
    var bannerapidata : [CartPackageItem]?{
        didSet{
            cartStoreTableView.reloadData()
        }
    }
    @IBOutlet weak var storeLabel: UILabel!
    
    var productCount = 1

    override func awakeFromNib() {
        super.awakeFromNib()
   
 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     func addToCartApi(product: String, quantity: Int){
        APIServices.additemtocart(product:product,quantity:quantity,completion: {[weak self] data in
            switch data{
            case .success(let res):
                
               //
                NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
            case .failure(let error):
                print(error)
                UIApplication.pTopViewController().view.makeToast(error)
               // self?.view.makeToast(error)
            }
        })
    }
    @objc func deleteBtnTapped(sender: UIButton){
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to delete this product?", heading: "Delete", note: "", miscid: "self.miscid", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Delete") { token, id in
            let item = self.bannerapidata?[sender.tag]
            self.deletePackageItem(product: item?.product?.id ?? "", _package: item?._package ?? "")
        }
        
//        appDelegate.showCustomerAlertControllerHeight(title: "Are you sure you want to delete.", heading: "Delete", btn1Title: "Cancel", btn1Callback: {
//             
//              }, btn2Title: "Delete") {
//                  let item = self.bannerapidata?[sender.tag]
//                  self.deletePackageItem(product: item?.product?.id ?? "", _package: item?.package ?? "")
//              }
    }
    
    @objc func increment(sender: UIButton){
        let item = bannerapidata?[sender.tag]

        if(productCount >= item?.product?.quantity ?? 0){
            UIApplication.pTopViewController().view.makeToast("You can buy only \(item?.product?.quantity ?? 0) Products")
        }else if(item?.product?.quantity ?? 0 == 0){
            UIApplication.pTopViewController().view.makeToast("Product is Out Of Stock")
        }else{
            let quantity = item?.quantity ?? 0
            let count = 1
            let total = quantity + count
            addToCartApi(product: item?.product?.id ?? "", quantity: total)
        }
        
        
//        if (item?.quantity ?? 0 > 0){
//            let quantity = item?.quantity ?? 0
//            let count = 1
//            let total = quantity + count
//            addToCartApi(product: item?.product?.id ?? "", quantity: total)
//            if(item?.quantity == item?.product?.quantity){
//
//                UIApplication.pTopViewController().view.makeToast("Desired Quantity Not Available")
//
//            }
//        }else{
//
//        }
    }
    @objc func decrement(sender: UIButton){
        let item = bannerapidata?[sender.tag]
        if (item?.quantity ?? 0 == 1){
           
        }else{
            let quantity = item?.quantity ?? 0
            let count = 1
            let total = quantity - count
            addToCartApi(product: item?.product?.id ?? "", quantity: total)
        }
    }
    private func deletePackageItem(product:String,_package:String){
        APIServices.deletePackage(product: product, _package: _package){[weak self] data in
            switch data{
            case .success(let res):
             
                NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
                
            
               
            
            case .failure(let error):
                print(error)
            }
        }
    }

}
extension CartStoreLableCell : UITableViewDataSource,UITableViewDelegate{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerapidata?.count ?? 0
          
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartStoreCell", for: indexPath) as! CartStoreCell
        let item = bannerapidata?[indexPath.row]
        cell.productImage.pLoadImage(url: item?.product?.mainImage ?? "")
        cell.productTitle.text = item?.product?.productName ?? ""
        cell.productdelete.tag = indexPath.row
        cell.productdelete.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        cell.productPlus.tag = indexPath.row
        cell.productPlus.addTarget(self, action: #selector(increment(sender:)), for: .touchUpInside)
        cell.productMinus.tag = indexPath.row
        cell.productMinus.addTarget(self, action: #selector(decrement(sender:)), for: .touchUpInside)
        Utility().applyBottomLeftCornerRadius(to: cell.productdelete, radius: 10)
        if item?.product?.selectedAttributes?.first?.name != nil {
            cell.varientName.isHidden = false
            cell.varientValue.isHidden = false
            cell.varientName.text = "\(item?.product?.selectedAttributes?.first?.name ?? ""):"
            cell.varientValue.text = item?.product?.selectedAttributes?.first?.value
        }else {
            cell.varientName.isHidden = true
            cell.varientValue.isHidden = true
        }
        productCount = item?.quantity ?? 0
//        cell.productQuantity.text =  "\(item?.product?.quantity ?? 0)"
        cell.productQuantity.text =  "\(item?.quantity ?? 0)"
        if cell.productQuantity.text == "1" {
            cell.productMinus.backgroundColor = .white
            cell.productMinus.setTitleColor(UIColor(hex: primaryColor), for: .normal)

        }else {
            cell.productMinus.backgroundColor = UIColor(hex: primaryColor)
            cell.productMinus.setTitleColor(UIColor.white, for: .normal)

        }
        if(item?.product?.onSale == true){
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(item?.product?.salePrice ?? 0))) //Utility().convertAmountInComma("\(item?.product?.salePrice ?? 0)")
        }else{
//            cell.productprice.text =
            cell.discountPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(Double(item?.product?.regularPrice ?? 0)))
        }
        
        // Utility().convertAmountInComma("\(item?.product?.regularPrice ?? 0)")
        

//        if data.onSale == true {
//            cell.discountPrice.isHidden = false
//            cell.discountPrice.text =  appDelegate.currencylabel + Utility().formatNumberWithCommas(Int(data.salePrice ?? 0))
//            cell.productPriceLine.isHidden = false
//            cell.productPrice.textColor = UIColor.systemGray3
//
//        }else {
//            cell.discountPrice.isHidden = true
//            cell.productPriceLine.isHidden = true
//            cell.productPrice.textColor = UIColor.black
//        }
//

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = bannerapidata?[indexPath.row]
        var c = (data?.product?.selectedAttributes?.count ?? 0) * 10
        return CGFloat(120 + c)
    }
    

      
}

