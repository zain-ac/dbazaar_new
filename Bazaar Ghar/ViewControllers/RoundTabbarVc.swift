//
//  TabBarViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 31/08/2023.
//

import UIKit

import WCCircularFloatingActionMenu
import SideMenu


class RoundTabbarVc: UITabBarController {
    var miscid = String()
    var ischecklogin = false
    
    private var customTabBar: CustomTabBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers?.forEach({
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
        })
        self.setupSideMenu()
        //        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        LanguageRander()
        
        if(ischecklogin){
            DispatchQueue.main.async {
                self.ischecklogin = false
                let vc = PopupLoginVc.getVC(.main)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if(miscid != ""){
            DispatchQueue.main.async {
                if self.miscid == "cancel" {
                    appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
                        
                    }, btn2Title: "Ok") { token, id in
                        
                    }
                }else {
                    appDelegate.ChineseShowCustomerAlertControllerHeight(title: "The seller has accepted your call request.", heading: "Request Call", note: "", miscid: self.miscid, btn1Title: "Not now", btn1Callback: {
                        
                    }, btn2Title: "Accept") { token, id in
                        appDelegate.videotoken = token
                        appDelegate.videoid = id
                        
                        NotificationCenter.default.post(name: Notification.Name("videocallid"), object: nil)
                    }
                }
                
            }
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("isback"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification3(notification:)), name: Notification.Name("RefreshAllTabs"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification2(notification:)), name: Notification.Name("googleauth"), object: nil)
        
        // Create a floating action menu
        
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        
        // Round the corners of the tab bar
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: self.tabBar.bounds.minY , width: self.tabBar.bounds.width - 20, height: self.tabBar.bounds.height + 10), cornerRadius: 20).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        self.tabBar.itemWidth = 38.0
        self.tabBar.itemPositioning = .centered
        
        // Hide label and image for item at index 2 (middle button)
        if let items = self.tabBar.items, items.count > 2 {
            let middleItem = items[2]
            middleItem.title = nil
            middleItem.image = nil
        }
        
        self.tabBar.tintColor = .blue
        self.tabBar.unselectedItemTintColor = .gray
        
        
    }
    private func setupSideMenu() {
        // Create the side menu
        let vc = MenuVCList.getVC(.sidemenu)
        let sideMenu = SideMenuNavigationController(rootViewController: vc)
        sideMenu.presentationStyle = .menuSlideIn
        // Set up properties
        sideMenu.leftSide = false // Set to false if you want it on the right side
        sideMenu.menuWidth = UIScreen.main.bounds.width * 0.7
        sideMenu.presentationStyle.backgroundColor = .clear
        sideMenu.presentationStyle.onTopShadowOpacity = 0.0
        sideMenu.presentationStyle.onTopShadowColor = .clear
        sideMenu.presentationStyle.onTopShadowColor = UIColor.black.withAlphaComponent(0.5)
        //        sideMenu.presentationStyle.onTopShadowOffset = 0.2
        sideMenu.presentationStyle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sideMenu.presentationStyle.presentingEndAlpha = 1.0
        //        sideMenu.presentationStyle.onTopShadowOpacity = 0.0
        //           sideMenu.presentationStyle.onTopShadowColor = .clear
        sideMenu.statusBarEndAlpha  = 0.0
        sideMenu.view.backgroundColor = .white
        sideMenu.presentationStyle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        // Add gesture to open side menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        
        // Optionally, add gesture recognizer to a button in your tab bar
        
    }
    
    @objc private func openMenu() {
        DispatchQueue.main.async {
            self.selectedIndex = 0
        }
        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("df")
    }
    func LanguageRander() {
        tabBar.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
        tabBar.items?[0].title = "home".pLocalized(lang: LanguageManager.language)
        tabBar.items?[1].title = "offers".pLocalized(lang: LanguageManager.language)
        //                tabBar.items?[2].title = "cart".pLocalized(lang: LanguageManager.language)
        tabBar.items?[3].title = "profile".pLocalized(lang: LanguageManager.language)
        tabBar.items?[4].title = "Menu".pLocalized(lang: LanguageManager.language)
  

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
    }
    @objc func methodOfReceivedNotification3(notification: Notification) {
        LanguageRander()
    }
    @objc func methodOfReceivedNotification2(notification: Notification) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        vc.verifyid = appDelegate.verifyid
        
        vc.mobileNumber = appDelegate.phoneno
        self.present(vc, animated: true)
     
    }
    
    func showSideMenu() {
            // Add your side menu presentation logic here
            let vc = MenuVCList.getVC(.sidemenu)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
      override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
          if item.title == "Profile" || item.title == "Inbox" {
              if AppDefault.islogin {
                  // User is logged in
              } else {
                  DispatchQueue.main.async {
                      self.selectedIndex = 0
                  }
                  let vc = PopupLoginVc.getVC(.main)
                  vc.modalPresentationStyle = .overFullScreen
                  self.present(vc, animated: true, completion: nil)
              }
              print("Login")
          }else if(item.title == "Menu"){
              
              self.openMenu()
          }
      }
}



class CustomTabBar: UITabBar, WCCircularFloatingActionMenuDataSource, WCCircularFloatingActionMenuDelegate {
    func floatingActionMenu(menu: WCCircularFloatingActionMenu, buttonForItem item: Int) -> UIButton {
        return sampleButtons[item]
    }
    
    func numberOfItemsForFloatingActionMenu(menu: WCCircularFloatingActionMenu) -> Int {
        return sampleButtons.count
    }
    
    func floatingActionMenu(menu: WCCircularFloatingActionMenu, didSelectItem item: Int) {
        print("Selected item index \(item)")
        let buttonImages = ["china", "saudi", "pakistan-image"]
        let data = buttonImages[item]


        let image = UIImage(named: data)?.withRenderingMode(.alwaysOriginal)
        middleButton.setImage(image, for: .normal)
        if item == 0 {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "Shop China"
            vc.color = "#FFCDC9"
            vc.shopImg = "shop_china"
            vc.shoptxtColor = "#DC2A1B"
            vc.catBGColor = "#FFE5E2"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
        }else if item == 1 {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "Shop Saudi"
            vc.color = "#DEFFF1"
            vc.shopImg = "shop_saudi"
            vc.shoptxtColor = "#028E53"
            vc.catBGColor = "#EDFFF8"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
        } else {
            let vc = ShopChina_VC.getVC(.main)
            vc.shop = "Shop Pakistan"
            vc.color = "#F7FFF2"
            vc.shopImg = "shop_pak"
            vc.catBGColor = "#F3FDE7"
            UIApplication.pTopViewController().navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    
    let sampleButtons:[UIButton] = {
          var sampleButtons = [UIButton]()
        let buttonImages = ["china", "saudi", "pakistan-image"]

          let sampleSize:CGFloat = 50
          let sampleCount = 3
          for i in 0..<sampleCount {
              let frame = CGRectMake(0, 0, sampleSize, sampleSize)
              let button = UIButton(frame: frame)
              if i < buttonImages.count {
                             let image = UIImage(named: buttonImages[i])
                             button.setImage(image, for: .normal)
                         }
              button.cornerRadius = 25
//              button.setTitle("FloatButton", for: .normal)
              button.backgroundColor = UIColor.white
              
//              button.setImage(UIImage(named: "pakistan-image"), for: .normal)
              sampleButtons.append(button)
          }
          return sampleButtons
      }()
     var middleButton = WCCircularFloatingActionMenu()
    var selectedIndex = Int()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMiddleButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationGlobe(notification:)), name: Notification.Name("globe"), object: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMiddleButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationGlobe(notification:)), name: Notification.Name("globe"), object: nil)
        
        
    }

    private func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 58, height: 58)
        middleButton.backgroundColor = .white
        middleButton.layer.cornerRadius = 29
        middleButton.layer.masksToBounds = true

        let image = UIImage(named: "World_Button")?.withRenderingMode(.alwaysOriginal)
        middleButton.setImage(image, for: .normal)
        middleButton.imageView?.contentMode = .scaleAspectFill
        middleButton.imageEdgeInsets = UIEdgeInsets(top: -25, left: -25, bottom: -25, right: -25)

//        middleButton.tintColor = .white
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 1, height: 2) // Change as needed
        middleButton.layer.shadowOpacity = 4// Change as needed
        middleButton.layer.shadowRadius = 0.5 // Change as needed
        // Adjust the middle button position
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
//        middleButton.imageView?.image  = UIImage(named: "pk")
        
     
        
//        middleButton = WCCircularFloatingActionMenu(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height - 80, width: 60, height: 60))

               // Set the properties
               middleButton.dataSource = self
               middleButton.delegate = self
//               middleButton.rotationStartAngleDegrees = 20
//               middleButton.rotationEndAngleDegrees = 20
               middleButton.startAngleDegrees = 220
               middleButton.endAngleDegrees = 320
               middleButton.radius = 100  // Set the desired radius for the menu item
        self.addSubview(middleButton)
    }
    @objc func methodOfReceivedNotificationGlobe(notification: Notification) {
        if let img = notification.userInfo?["img"] as? String {
            let image = UIImage(named: img)?.withRenderingMode(.alwaysOriginal)
            middleButton.setImage(image, for: .normal)
        }
  
    }

    @objc private func middleButtonAction() {
        self.selectedIndex = 2 // Middle tab
        
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }

        let from = point
        let to = middleButton.center

        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= middleButton.bounds.width / 2 ? middleButton : super.hitTest(point, with: event)
    }
    
}

