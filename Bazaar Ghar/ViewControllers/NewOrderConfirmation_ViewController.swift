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
    @IBOutlet weak var ordersummarycollectheight: NSLayoutConstraint!
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
    var orderDetails: CartItemsResponse?
    var itemCount = 0
    var defaultAdress : DefaultAddress?
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentmethodtblview.delegate = self
        paymentmethodtblview.dataSource = self
        ordersummarycollectview.delegate = self
        ordersummarycollectview.dataSource = self
        Utility().setGradientBackground(view: headerview, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        Utility().setGradientBackground(view: placeorderbtn, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        orderinstructiontxt.addPlaceholder("Order Instructions".pLocalized(lang: LanguageManager.language))
        
        let attributedText1 =  Utility().attributedStringWithColoredLastWord("Delivery Address", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        deliveryaddresslbl.attributedText = attributedText1
        let attributedText2 =  Utility().attributedStringWithColoredLastWord("Payment Method", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        paymentmethodlbl.attributedText = attributedText2
        let attributedText3 =  Utility().attributedStringWithColoredLastWord("Coupon Code", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        coupouncodelbl.attributedText = attributedText3
        let attributedText4 =  Utility().attributedStringWithColoredLastWord("Order Summary", lastWordColor: UIColor(hexString: "#2E8BF8"), otherWordsColor: UIColor(hexString: "#101010"))
        
        ordersummarylbl.attributedText = attributedText4
        
        // Do any additional setup after loading the view.
    }
    @IBAction func editbtn(_ sender: Any) {
    }
    @IBAction func addnewadressbtntap(_ sender: Any) {
    }
    @IBAction func placeorderbtntap(_ sender: Any) {
    }
    

}
extension NewOrderConfirmation_ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderSummary_CollectionViewCell", for: indexPath) as! OrderSummary_CollectionViewCell
        return cell
    }
    
    
}
extension NewOrderConfirmation_ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Paymentmethod_TableViewCell", for: indexPath) as! Paymentmethod_TableViewCell
        return cell
    }
    
    
}
