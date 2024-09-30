//
//  MyOrdersDetailsViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 20/09/2023.
//

import UIKit

class MyOrdersDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!

    @IBOutlet weak var orderlbl: UILabel!
    
    @IBOutlet weak var shippedtolbl: UILabel!
    @IBOutlet weak var expecteddeliverylbl: UILabel!
    
    @IBOutlet weak var pakagelbl: UILabel!
    @IBOutlet weak var confirmedlbl: UILabel!
    @IBOutlet weak var cashondeliverylbl: UILabel!
    @IBOutlet weak var deliverychargeslbl: UILabel!
    @IBOutlet weak var subtotallbl: UILabel!
    
    @IBOutlet weak var orderidlbl: UILabel!
    @IBOutlet weak var orderproductcell: UITableView!

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    var orderID = String()
    var price = Double()
    var orderResponse: [NewOrderItem]?
    var shipmentCharges : Double?
    var orderStatus : String?
    var singleOrderResponse: MyOrderResult?

    @IBOutlet weak var deliverycharges: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderproductcell.delegate = self
        orderproductcell.dataSource = self
       
        confirmedlbl.text = orderStatus ?? ""
        name.text = AppDefault.currentUser?.defaultAddress?.fullname
        phone.text = AppDefault.currentUser?.defaultAddress?.phone
        city.text = AppDefault.currentUser?.defaultAddress?.city
        address.text = AppDefault.currentUser?.defaultAddress?.address
        orderidlbl.text = "Order ID #\(orderID)"
        subtotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(price)
        deliverycharges.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(shipmentCharges ?? 0.0)
        total.text = "TOTAL " + appDelegate.currencylabel + Utility().formatNumberWithCommas(price + (shipmentCharges ?? 0.0))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
    }
    func LanguageRender(){
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        orderlbl.text = "orders".pLocalized(lang: LanguageManager.language)
        shippedtolbl.text = "shippedto".pLocalized(lang: LanguageManager.language)
        pakagelbl.text = "package".pLocalized(lang: LanguageManager.language)
        expecteddeliverylbl.text = "expectedcharges".pLocalized(lang: LanguageManager.language)
        subtotallbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        deliverychargeslbl.text = "deliverycharges".pLocalized(lang: LanguageManager.language)
        cashondeliverylbl.text = "cashondelivery".pLocalized(lang: LanguageManager.language)
        cashondeliverylbl.text = singleOrderResponse?.paymentMethod

 

           UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
    }

}


extension MyOrdersDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderResponse?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderproductcell2", for: indexPath) as! orderproductcell
        let data = orderResponse?[indexPath.row].product
        cell.productimg.pLoadImage(url: data?.mainImage ?? "")
        cell.productname.text = data?.productName
        cell.productprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.price ?? 0.0)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       let count = 120 * (orderResponse?.count ?? 0)
        return 120
       
    }
  
}

    
