//
//  Orders_VC.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import UIKit

class Orders_VC: UIViewController {

    @IBOutlet weak var ordertable: UITableView!
    
    @IBOutlet weak var orderlbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!


    var orderResponse: [MyOrderResult]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       

        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        ordertable.dataSource = self
        ordertable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myOrders()
        LanguageRender()
    }
    func LanguageRender(){
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
        }else{
            backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
        orderlbl.text = "order".pLocalized(lang: LanguageManager.language)
    }
    
     func myOrders(){
         
         APIServices.myorder(limit: 100,sortBy:"createdAt"){[weak self] data in
            switch data{
            case .success(let res):
              print(res)
                self?.orderResponse = res.results ?? []
                self?.ordertable.reloadData()
             
            
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func newBtnTapped(_ sender: Any) {
        let vc = MyOrdersDetailsViewController.getVC(.orderJourneyStoryBoard)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        appDelegate.isbutton = false
    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension Orders_VC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderResponse?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        let data = orderResponse?[indexPath.row]
        cell.orderItemsResponse = data
        
        cell.orderId.text = "Order ID #\(data?.orderID ?? "")"
        cell.orderTotalprice.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.retailTotal ?? 0) //Utility().convertAmountInComma("\(data?.retailTotal ?? 0)")
        cell.statusBtn.setTitle(data?.orderStatus?.name?.capitalized ?? "", for: .normal)
        if data?.orderStatus?.name == "new" {
            cell.statusBtnWidth.constant = 35
        }else {
            cell.statusBtnWidth.constant = 60
        }
        cell.deliverychargeslbl.text = "\(appDelegate.currencylabel + Utility().formatNumberWithCommas(data?.shippmentCharges ?? 0)) " + "deliverycharges".pLocalized(lang: LanguageManager.language)
             return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = orderResponse?[indexPath.row]
        if(item?.orderItems?.count ?? 0 == 1){
            return CGFloat(260 * (item?.orderItems?.count ?? 0))
        }else{
            
            let value = 160
            let height = 100 * (item?.orderItems?.count ?? 0)
            
            
            return CGFloat(value + height)
        }
     
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = orderResponse?[indexPath.row].orderItems
        let dataid = orderResponse?[indexPath.row]
        
        let vc = MyOrdersDetailsViewController.getVC(.orderJourneyStoryBoard)
        vc.price = dataid?.retailTotal ?? 0.0
        vc.orderID = dataid?.orderID ?? ""
        vc.orderResponse = data
        vc.shipmentCharges = dataid?.shippmentCharges
        vc.orderStatus = dataid?.orderStatus?.name?.capitalized
        self.navigationController?.pushViewController(vc, animated: false)
    }
  
    
}




