//
//  ProfileViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 05/09/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var logoutlbl: UILabel!
    @IBOutlet weak var walletlbl: UILabel!
    @IBOutlet weak var myorderslbl: UILabel!
    @IBOutlet weak var addreessbooklbl: UILabel!
    @IBOutlet weak var wishlistlbl: UILabel!
    @IBOutlet weak var invitefriendslbl: UILabel!
    @IBOutlet weak var termandconditionslbl: UILabel!
    @IBOutlet weak var faqslbl: UILabel!
    @IBOutlet weak var privacypolicylbl: UILabel!
    @IBOutlet weak var contactuslbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!

    
    
    
    
    @IBOutlet weak var wishList: UILabel!
    @IBOutlet weak var adressBook: UILabel!
    @IBOutlet weak var orders: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var filterPullDownButtom: UIButton!


    
    var orderResponse: [MyOrderResult]?
    var uid = AppDefault.uid
    var displayName = AppDefault.displayName
    var systemVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        versionLbl.text = "Version \(systemVersion ?? "")"
//        let Eng = {(action: UIAction) in
//            AppDefault.languages = "en"
//            LanguageManager.language =  AppDefault.languages
//            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
////            UITabBar.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
//            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
//            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
//            self.tabBarController?.selectedIndex = 0
//        }
//        
//        let Arabic = {(action: UIAction) in
//           
//            AppDefault.languages = "ar"
//            LanguageManager.language =  AppDefault.languages
//            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
////            UITabBar.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
//            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
//            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
//
//            self.tabBarController?.selectedIndex = 0
//        }
//        if LanguageManager.language == "ar" {
//            filterPullDownButtom.menu = UIMenu(children: [
//                UIAction(title:"عربي", state: .on, handler:
//                            Arabic),
//                UIAction(title: "English", handler: Eng),
//                
//            ])
//        }else {
//            filterPullDownButtom.menu = UIMenu(children: [
//                UIAction(title: "English", state: .on, handler:
//                            Eng),
//                UIAction(title: "عربي", handler: Arabic),
//                
//            ])
//        }

//        filterPullDownButtom.showsMenuAsPrimaryAction = true
//        if #available(iOS 15.0, *) {
//            filterPullDownButtom.changesSelectionAsPrimaryAction = true
//        } else {
//            // Fallback on earlier versions
//        }
        

//        LanguageManager.language = "en"
        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }
        else {
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        
           UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.LanguageRender()
        if(AppDefault.currentUser != nil){
            self.userName.text  = AppDefault.currentUser?.fullname
            self.userEmail.text = AppDefault.currentUser?.email
            self.walletBalance.text = "PKR " + "\(AppDefault.currentUser?.wallet?.balance ?? 0)"
        }
        wish()
        myOrders()
        getaddress()

    }


    func LanguageRender(){
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        profilelbl.text = "profile".pLocalized(lang: LanguageManager.language)
        logoutlbl.text = "logout".pLocalized(lang: LanguageManager.language)
        walletlbl.text = "wallet".pLocalized(lang: LanguageManager.language)
        myorderslbl.text = "myorders".pLocalized(lang: LanguageManager.language)
        addreessbooklbl.text = "addressbook".pLocalized(lang: LanguageManager.language)
        wishlistlbl.text = "wishlist".pLocalized(lang: LanguageManager.language)
        invitefriendslbl.text = "invitefriends".pLocalized(lang: LanguageManager.language)
        termandconditionslbl.text = "termsandconditions".pLocalized(lang: LanguageManager.language)
        faqslbl.text = "faqs".pLocalized(lang: LanguageManager.language)
        privacypolicylbl.text = "privacypolicy".pLocalized(lang: LanguageManager.language)
        contactuslbl.text = "contactus".pLocalized(lang: LanguageManager.language)
        languageLbl.text = "language".pLocalized(lang: LanguageManager.language)

           UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
            filterPullDownButtom.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    }
    
    private func getaddress(){
        APIServices.getaddress(completion: {[weak self] data in
            switch data{
            case .success(let res):
          print(res)
                self?.adressBook.text = "\(res.count)"
                
              
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else{
                    self?.view.makeToast(error)
                }
                
            }
        })
    }
     private func wish(){

       APIServices.wishlist(){[weak self] data in
           switch data{
           case .success(let res):
             print(res)
               self?.wishList.text = "\(res.products?.count ?? 0)"
               
          
           case .failure(let error):
               print(error)
           }
       }
   }
    private  func myOrders(){

        APIServices.myorder(limit:100,sortBy:"createdAt"){[weak self] data in
             switch data{
             case .success(let res):
               print(res)
                 self?.orderResponse = res.results ?? []
                 self?.orders.text = "\(res.results?.count ?? 0)"
              
             
             
             case .failure(let error):
                 print(error)
             }
         }
     }
    
    private func deleteAccount(userId:String,status:String){
        APIServices.deleteAccount(userId:userId, status: status){[weak self] data in
            switch data{
            case .success(let res):
              print(res)
                AppDefault.islogin = false
                AppDefault.accessToken = ""
                DispatchQueue.main.async {
//                    appDelegate.GotoDashBoard(ischecklogin: false)
                    self?.navigationController?.popToRootViewController(animated: true)

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        
        
        appDelegate.showCustomerLanguageAlertControllerHeight(title: "Select Language", heading: "", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Apply") {
            UIView.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
//            UITabBar.appearance().semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
            UITextField.appearance().textAlignment = LanguageManager.language == "ar" ? .right : .left
            NotificationCenter.default.post(name: Notification.Name("RefreshAllTabs"), object: nil)
            self.tabBarController?.selectedIndex = 0
        }
        
   
    }
    
    @IBAction func logoutbtn(_ sender: Any) {
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to logout?", heading: "Logout", note: "", miscid: "self.miscid", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Logout") { token, id in
            AppDefault.islogin = false
            AppDefault.accessToken = ""
          
            DashboardManager.shared.goToDashboard(ischecklogin: false)
            UIApplication.pTopViewController().tabBarController?.view.makeToast("Successfully Logout")
        }
//        appDelegate.showCustomerAlertControllerHeight(title: "Are you sure you want to logout?", heading: "Logout", btn1Title: "Cancel", btn1Callback: {
//             
//              }, btn2Title: "Logout") {
//                  AppDefault.islogin = false
//                  AppDefault.accessToken = ""
//                
//                  DashboardManager.shared.goToDashboard(ischecklogin: false)
//                  UIApplication.pTopViewController().tabBarController?.view.makeToast("Successfully Logout")
//
//
//              }
//        

    }
    @IBAction func EditUsernameBtnTapped(_ sender: Any) {
        let vc = PersonalDetailsViewController.getVC(.main)
        vc.fullName = userName.text
        vc.Email = userEmail.text
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func EditEmailBtnTapped(_ sender: Any) {
        let vc = PersonalDetailsViewController.getVC(.main)
        vc.fullName = userName.text
        vc.Email = userEmail.text
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func myOrderBtn(_ sender: Any) {
        let vc = Orders_VC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func AddressBtnTapped(_ sender: Any) {
        let vc = AddressViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func wishListButton(_ sender: Any) {
        let vc = wishlist_vc.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)

    }
    @IBAction func termConditionBtn(_ sender: Any) {
        AppDefault.iscomefaqs = false
        let vc = TermConditions.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)

    }
  
    @IBAction func contactUsBtn(_ sender: Any) {
        let vc = Contact_us.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func privacypolicyBtn(_ sender: Any) {
        let vc = Privacypolicy_VC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func inviteFreindBtn(_ sender: Any) {
        let vc = inviteFriends_Vc.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
 
     @IBAction func faqsBtn(_ sender: Any) {
         AppDefault.iscomefaqs = true
         let vc = TermConditions.getVC(.main)
         self.navigationController?.pushViewController(vc, animated: false)
     }
    
        @IBAction func walletBtn(_ sender: Any) {
            let vc = MyWallet_VC.getVC(.main)
            vc.walletPrice = walletBalance.text ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func deleteAccountBtnTapped(_ sender: Any) {
        
        appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Are you sure you want to delete Account?", heading: "Delete Account", note: "", miscid: "self.miscid", btn1Title: "Cancel", btn1Callback: {
            
        }, btn2Title: "Delete") { token, id in
            self.deleteAccount(userId: AppDefault.currentUser?.id ?? "", status: "inactive")
        }
        
//        appDelegate.showCustomerAlertControllerHeight(title: "Are you sure you want to delete Account?", heading: "Delete Account", btn1Title: "Cancel", btn1Callback: {
//             
//              }, btn2Title: "Delete") {
//                  self.deleteAccount(userId: AppDefault.currentUser?.id ?? "", status: "inactive")
//              }
    }
   


}
