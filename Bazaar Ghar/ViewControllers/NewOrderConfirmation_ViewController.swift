//
//  NewOrderConfirmation_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 15/07/2024.
//

import UIKit

class NewOrderConfirmation_ViewController: UIViewController {
    @IBOutlet weak var mapview: UIView!
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var entercoupontxt: UITextField!
    @IBOutlet weak var discounttxt: UILabel!
    @IBOutlet weak var paymentmethodtblview: UITableView!
    @IBOutlet weak var producttotaltxt: UILabel!
    @IBOutlet weak var addnewadressbtn: UIButton!
    @IBOutlet weak var placeorderbtn: UIButton!
    @IBOutlet weak var deliverytxt: UILabel!
    @IBOutlet weak var payabletxt: UILabel!
    @IBOutlet weak var applybtn: UIButton!
    @IBOutlet weak var totaltxt: UILabel!
    @IBOutlet weak var subtotaltxt: UILabel!
    @IBOutlet weak var coupouncodelbl: UILabel!
    @IBOutlet weak var orderinstructiontxt: UITextView!
    @IBOutlet weak var deliveryaddresslbl: UILabel!
    @IBOutlet weak var paymentmethodlbl: UILabel!
    @IBOutlet weak var ordersummarylbl: UILabel!
    @IBOutlet weak var ordersummarycollectview: UICollectionView!
    @IBOutlet weak var homelbl: UILabel!
    
    @IBOutlet weak var orderSummaryHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLbl: UILabel!

    var orderDetails: CartItemsResponse?
    var itemCount = 0
    var defaultAdress : DefaultAddress?
    var methodimgArray = ["cash-on-delivery","cash-on-delivery"]
    var methodNameArray = ["Alfalah Credit/Debit Card","Cash On Delivery"]
    var selectedIndex:Int?
    var bannerapidata: [Package] = []
    var cartItems : [CartPackageItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentmethodtblview.delegate = self
        paymentmethodtblview.dataSource = self
        ordersummarycollectview.delegate = self
        ordersummarycollectview.dataSource = self
        Utility().setGradientBackground(view: headerview, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
//        Utility().setGradientBackground(view: placeorderbtn, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        orderinstructiontxt.addPlaceholder("Order Instructions".pLocalized(lang: LanguageManager.language))
        
        let attributedText1 =  Utility().attributedStringWithColoredLastWord("Delivery Address", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        deliveryaddresslbl.attributedText = attributedText1
        let attributedText2 =  Utility().attributedStringWithColoredLastWord("Payment Method", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        paymentmethodlbl.attributedText = attributedText2
        let attributedText3 =  Utility().attributedStringWithColoredLastWord("Coupon Code", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        coupouncodelbl.attributedText = attributedText3
        let attributedText4 =  Utility().attributedStringWithColoredLastWord("Order Summary", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        ordersummarylbl.attributedText = attributedText4
        
        // Create the button
             let button = UIButton(type: .system)
             addnewadressbtn.setTitle("+ Add New Address", for: .normal)
        
             addnewadressbtn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
             
             // Add the dotted border
             addDottedBorder(to: button)
             
             // Add the button to the view
             view.addSubview(button)
         }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        defaultAdress = AppDefault.currentUser?.defaultAddress
        homelbl.text = defaultAdress?.addressType
        addressLbl.text = defaultAdress?.address
        for i in bannerapidata {
            cartItems += i.packageItems ?? []
        }
        orderSummaryHeight.constant = 320 + CGFloat(cartItems.count * 150)
        scrollHeight.constant = CGFloat(orderSummaryHeight.constant) + 630
        
        
        producttotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.retailTotal ?? 0)
        discounttxt.text = "(\(appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.discount ?? 0)))"
        subtotaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.subTotal ?? 0)
        deliverytxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.shippmentCharges ?? 0)
        totaltxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.total ?? 0)
        payabletxt.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(orderDetails?.payable ?? 0 + 150)
    }
    
    
    
         func addDottedBorder(to button: UIButton) {
             let dottedBorder = CAShapeLayer()
             dottedBorder.strokeColor = UIColor.black.cgColor
             dottedBorder.lineDashPattern = [4, 2] // Dash pattern (4 points on, 2 points off)
             dottedBorder.frame = button.bounds
             dottedBorder.fillColor = nil
             dottedBorder.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
             
             button.layer.addSublayer(dottedBorder)
         }
    @IBAction func editbtn(_ sender: Any) {
        let vc = AddressViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func addnewadressbtntap(_ sender: Any) {
        let vc = AddAddressViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func placeorderbtntap(_ sender: Any) {
        placeOrder(cartId: orderDetails?.id ?? "")
    }
    
    private func placeOrder(cartId:String){
    
        APIServices.palceOrder(cartId: cartId){[weak self] data in
            switch data{
            case .success(let res):
              print(res)
                let vc = PlaceOrder_VC.getVC(.main)
                vc.orderID = res.orderDetailID
                self?.navigationController?.pushViewController(vc, animated: false)

            case .failure(let error):
                print(error)
            }
        }
    }
    

}
extension NewOrderConfirmation_ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderSummary_CollectionViewCell", for: indexPath) as! OrderSummary_CollectionViewCell
        let data = cartItems[indexPath.row].product
        cell.img.pLoadImage(url: data?.mainImage ?? "")
        cell.productName.text = data?.productName ?? ""
        if data?.onSale == true {
            cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.salePrice ?? 0))
        }else {
            cell.productPrice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.regularPrice ?? 0))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 140)
    }
    
    
}
extension NewOrderConfirmation_ViewController:UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegateFlowLayout{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Paymentmethod_TableViewCell", for: indexPath) as! Paymentmethod_TableViewCell
        cell.namelbl.text = methodNameArray[indexPath.row]
        cell.methodImg.setBackgroundImage(UIImage(named: methodimgArray[indexPath.row]), for: .normal)
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(checkBtnTapped(_:)), for: .touchUpInside)
        if selectedIndex == nil {
            if indexPath.row == 1 {
                cell.checkBtn.setBackgroundImage(UIImage(named: "checked"), for: .normal)
            }
        }else {
            if selectedIndex == indexPath.row {
                cell.checkBtn.setBackgroundImage(UIImage(named: "checked"), for: .normal)
            }else {
                cell.checkBtn.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
            }
        }
       
        
        return cell
    }
    
    @objc func checkBtnTapped(_ sender: UIButton) {
        print("Button was clicked!")
        self.selectedIndex = sender.tag
        
        paymentmethodtblview.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
