//
//  InVoice_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 01/08/2024.
//

import UIKit

class InVoice_ViewController: UIViewController {
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var invoicelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var totalamountlbl: UILabel!
    @IBOutlet weak var invoiceview: UIView!
    @IBOutlet weak var invoice_tbl: UITableView!
    var orderID : String?
    var orderitems:CartItemsResponse?
    var mainpackageItems: [CartPackageItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        invoice_tbl.dataSource = self
        invoice_tbl.delegate = self
        Utility().setGradientBackground(view: headerview, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        Utility().setGradientBackground(view: invoiceview, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        invoicelbl.text = orderitems?.id ?? ""
        totalamountlbl.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(orderitems?.subTotal ?? 0))
        setCurrentDate()
        self.navigationController?.navigationBar.isHidden = true
               tabBarController?.tabBar.isHidden = true
      
//        placeOrder(cartId: orderitems)
        // Do any additional setup after loading the view.
    }
    func setCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Custom date format
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        datelbl.text = formattedDate
    }
    @IBAction func myorderbtntap(_ sender: Any) {
        let vc = Orders_VC.getVC(.orderJourneyStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
//    private func placeOrder(cartId:String){
//
//        APIServices.palceOrder(cartId: cartId){[weak self] data in
//            switch data{
//            case .success(let res):
//              print(res)
////                self?.orderitems = res
//                let vc = InVoice_ViewController.getVC(.main)
//                self?.navigationController?.pushViewController(vc, animated: false)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }

    @IBAction func homebtntap(_ sender: Any) {
        appDelegate.GotoDashBoard(ischecklogin: false)
    }
    
}
extension InVoice_ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainpackageItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InVoice_TableViewCell", for: indexPath) as! InVoice_TableViewCell
        let data = mainpackageItems?[indexPath.row]
        cell.img.pLoadImage(url: data?.product?.mainImage ?? "")
        cell.produtname.text = data?.product?.productName
        cell.Price.attributedText    = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.product?.price ?? 0))
        cell.qtylbl.text = "Qty \(data?.quantity ?? 0)"
        
        
//        cell.img.pLoadImage(url: orderitems?.orders?.first?.orderItems?[indexPath.row].product?.mainImage ?? ""
//)
//        cell.produtname.text =  orderitems?.orders?.first?.orderItems?[indexPath.row].product?.productName ?? ""
//        cell.qtylbl.text  = "\(orderitems?.orders?.first?.orderItems?[indexPath.row].product?.quantity ?? 0)"
//        cell.Price.attributedText    = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(orderitems?.orders?.first?.orderItems?[indexPath.row].product?.price ?? 0))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
}
