//
//  CartViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 29/08/2023.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var Backgroundpopview: UIView!
    @IBOutlet weak var popview: UIView!
    @IBOutlet weak internal var cartTableViewCell: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var emptyCart: UIView!
    @IBOutlet weak var total: UILabel!

    
    // localizationOutlest
    // localizationOutlest
     @IBOutlet weak var cartlbl: UILabel!
     @IBOutlet weak var emptycartlbl: UILabel!
     @IBOutlet weak var cartchargesmessagelbl: UILabel!
     @IBOutlet weak var totallbl: UILabel!
     @IBOutlet weak var subtotallbl: UILabel!
     @IBOutlet weak var waitlbl: UILabel!
     @IBOutlet weak var confirdeletecartlbl: UILabel!
     @IBOutlet weak var nolbl: UIButton!
     @IBOutlet weak var yeslbl: UIButton!
     @IBOutlet weak var checkoutbutton: UIButton!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var headerBackgroudView: UIView!

    // localizationOutlest
    // localizationOutlest

    
    var bannerapidata: [Package] = []
    var orderDetails: CartItemsResponse?
    var defaultAdress : DefaultAddress?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        cartTableViewCell.dataSource = self
        cartTableViewCell.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromCartCell(notification:)), name: Notification.Name("reloadData"), object: nil)
        
        
        self.emptyCart.isHidden = true
        self.deleteBtn.isHidden = true
        self.popview.isHidden = true
        self.Backgroundpopview.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if(appDelegate.isback){
            appDelegate.isback = false
            self.tabBarController?.selectedIndex = 0
        }
        getCartProducts()
    }
    
    func LanguageRender(){
        cartlbl.text = "cart".pLocalized(lang: LanguageManager.language)
        emptycartlbl.text = "emptycart".pLocalized(lang: LanguageManager.language)
//        cartchargesmessagelbl.text = "cartchargesmessage".pLocalized(lang: LanguageManager.language)
        totallbl.text = "total".pLocalized(lang: LanguageManager.language)
        subtotallbl.text = "subtotal".pLocalized(lang: LanguageManager.language)
        waitlbl.text = "wait".pLocalized(lang: LanguageManager.language)
        confirdeletecartlbl.text = "confirdeletecart".pLocalized(lang: LanguageManager.language)
        nolbl.setTitle("no".pLocalized(lang: LanguageManager.language),for: .normal)
        yeslbl.setTitle("yes".pLocalized(lang: LanguageManager.language),for: .normal)
        checkoutbutton.setTitle("checkout".pLocalized(lang: LanguageManager.language),for: .normal)
        if LanguageManager.language == "ar"{
            backbtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backbtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        
    }
    
    @objc func methodOfReceivedNotificationFromCartCell(notification: Notification) {
        getCartProducts()
    }
    
    
    private func getCartProducts(){
    
        APIServices.getCartItems(){[weak self] data in
            switch data{
            case .success(let res):
             
                AppDefault.cartId =  res.id
            
                AppDefault.currentUser?.defaultAddress = res.user?.defaultAddress
                self?.orderDetails = res
                    self?.bannerapidata = res.packages ?? []
                if(self?.bannerapidata.count ?? 0 > 0){
                    self?.emptyCart.isHidden = true
                    self?.deleteBtn.isHidden = false

                }else{
                    self?.emptyCart.isHidden = false
                    self?.deleteBtn.isHidden = true
                }
                self?.cartchargesmessagelbl.text = "Shipping Charges in Saudia are \(appDelegate.currencylabel + Utility().formatNumberWithCommas(res.shippmentCharges ?? 0)) per package" //"cartchargesmessage".pLocalized(lang: LanguageManager.language)

                self?.subTotal.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.subTotal ?? 0) //Utility().convertAmountInComma("\(res.subTotal ?? 0)")
                self?.total.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(res.total ?? 0) //Utility().convertAmountInComma("\(res.total ?? 0)")
                
                self?.cartTableViewCell.reloadData()
            
            case .failure(let error):
                print(error)
                self?.emptyCart.isHidden = false
                if(error == "Please authenticate" && AppDefault.islogin){
                     appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                 }else{
                     self?.view.makeToast(error)
                 }
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteCartBtn(_ sender: Any) {
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to delete all products from cart?", heading: "Delete All", note: "", miscid: "self.miscid", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Delete") { token, id in
            self.deleteCartApi()
        }
        
//        popview.isHidden = false
//        self.Backgroundpopview.isHidden = false

    }
    
    @IBAction func checkout_btn(_ sender: Any) {
        
        let vc = NewOrderConfirmation_ViewController.getVC(.sidemenu)
        vc.orderDetails =  orderDetails
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
    @IBAction func yesBtn(_ sender: Any) {
        deleteCartApi()
        
    }
   
    private func deleteCartApi(){
        APIServices.deleteCart(){[weak self] data in
            switch data{
            case .success(let res):

              print(res)
                self?.popview.isHidden = true
                self?.Backgroundpopview.isHidden = true

                self?.getCartProducts()
              

            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func noBtn(_ sender: Any) {
        popview.isHidden = true
        self.Backgroundpopview.isHidden = true

    }
}



extension CartViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerapidata.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartStoreLableCell", for: indexPath) as! CartStoreLableCell
        let item = bannerapidata[indexPath.row]
        cell.storeLabel?.text = "Package \(indexPath.row + 1) by " + (item.seller?.sellerDetail?.brandName ?? "")// Replace "text" with the actual property name
        cell.bannerapidata = item.packageItems
             return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = bannerapidata[indexPath.row]
        if(item.packageItems?.count ?? 0 == 1){
            return CGFloat(160 * (item.packageItems?.count ?? 0))
        }else{
            return CGFloat(140 * (item.packageItems?.count ?? 0))
        }
     
      
    }
  
}


