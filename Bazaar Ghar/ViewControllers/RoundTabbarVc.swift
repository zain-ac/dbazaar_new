//
//  TabBarViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 31/08/2023.
//

import UIKit

import WCCircularFloatingActionMenu


class RoundTabbarVc: UITabBarController {
    var miscid = String()
    var ischecklogin = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers?.forEach({
                  $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
              })
        
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
        layer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: self.tabBar.bounds.minY + 5, width: self.tabBar.bounds.width - 20, height: self.tabBar.bounds.height + 10), cornerRadius: 30).cgPath
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
    func LanguageRander() {
        tabBar.semanticContentAttribute = LanguageManager.language == "ar" ? .forceRightToLeft : .forceLeftToRight
                tabBar.items?[0].title = "home".pLocalized(lang: LanguageManager.language)
                tabBar.items?[1].title = "offers".pLocalized(lang: LanguageManager.language)
//                tabBar.items?[2].title = "cart".pLocalized(lang: LanguageManager.language)
                tabBar.items?[3].title = "profile".pLocalized(lang: LanguageManager.language)
                tabBar.items?[4].title = "profile".pLocalized(lang: LanguageManager.language)
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
    private var middleButton = WCCircularFloatingActionMenu()
    var selectedIndex = Int()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMiddleButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMiddleButton()
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

