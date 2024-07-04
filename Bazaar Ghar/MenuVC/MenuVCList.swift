//
//  ProMenuList.swift
//  AgorzCustomer
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


class MenuVCList: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    var isSelected  =  ""

    @IBOutlet var menuview: UIView!
    
  
    var data = [String]()
    var imagedata = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        isSelected  = "Home"
        self.menuview.backgroundColor = UIColor.white
        name.text = UserDefaults.standard.string(forKey: "driver_name")
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSSideMenu), name: NSNotification.Name(rawValue: "sidemenuReload"), object: nil)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        SetupAppColor()
        self.CreateMenuitemList()
    
    }
    @objc func reloadSSideMenu(notification: Notification) {


    }
    func SetupAppColor(){
        
    }
//    @IBAction func btnMenu_click(_ sender: Any) {
//        self.sideMenuController?.toggle()
//    }
    func CreateMenuitemList() {

          imagedata = ["home","current trips","next day trips","logout"]
//          data = ["Home","Current Trips","Next Day Trips","Logout"]

        
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func funLogout() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        //self.appDelegate.MovetoNext()
//        let parameters = [ "email": kDriver?.email,"password":kDriver?.password]
//        print(parameters)
//        APIs.postAPI(apiName: .logout, parameters: parameters as [String : Any], viewController: self, completion: {
//            jsonResponse, success, errorMessage in
//            print(jsonResponse as Any)
//            if success {
//                UserDefaults.standard.set(false, forKey: "isLogin")
//
//             
//            }
//            else {
//                self.showAlert(message: errorMessage)
//            }
//        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDefault.getAllCategoriesResponsedata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SideMenuCell
        cell.selectionStyle = .none
        let dict  = AppDefault.getAllCategoriesResponsedata?[indexPath.row]
        cell.lab.text = dict?.name
        cell.imagelbl.pLoadImage(url: dict?.mainImage ?? "" )
        
        cell.imagelbl.tintColor = .gray
        cell.lab.textColor  =  .black
        
        if cell.lab.text == isSelected{
//            cell.imagelbl.tintColor = hexStringToUIColor(hex: "1cacc1")
//            cell.lab.textColor  =  hexStringToUIColor(hex: "1cacc1")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let dict = AppDefault.CategoriesResponsedata?[indexPath.row]
        
        
        //        if (dict == "Home"){
        //            isSelected = "Home"
        //            let myViewController = KMAINstoryBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        //            sideMenuController?.embed(centerViewController: myViewController!)
        //        }
        //        else if(dict == "Current Trips"){
        //            isSelected = "Current Trips"
        //            let myViewController = KMAINstoryBoard.instantiateViewController(withIdentifier: "CurrentTripVC") as? CurrentTripVC
        //            sideMenuController?.embed(centerViewController: myViewController!)
        //        }
        //        else if(dict == "My Weekly Availabilty"){
        //            isSelected = "My Weekly Availabilty"
        //            let myViewController = KMAINstoryBoard.instantiateViewController(withIdentifier: "MyWeeklyAvailabilityVC") as? MyWeeklyAvailabilityVC
        //            sideMenuController?.embed(centerViewController: myViewController!)
        //        }
        //        else if(dict == "Next Day Trips"){
        //            isSelected = "Next Day Trips"
        //            let myViewController = KMAINstoryBoard.instantiateViewController(withIdentifier: "NextDayTripsVC") as? NextDayTripsVC
        //            sideMenuController?.embed(centerViewController: myViewController!)
        //        }
        //        else if(dict == "Logout"){
        //            let alert = UIAlertController(title: "Alert!", message: "Are You Sure to Logout?", preferredStyle: .alert)
        //
        //                 let ok = UIAlertAction(title: "Confirm", style: .default, handler: { action in
        //                     UserDefaults.standard.set("", forKey: "VehicleTitl")
        //                     UserDefaults.standard.set(false, forKey: "isLogin")
        //                     self.funLogout()
        //                 })
        //                 alert.addAction(ok)
        //                 let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        //                 })
        //                 alert.addAction(cancel)
        //                 DispatchQueue.main.async(execute: {
        //                    self.present(alert, animated: true)
        //            })
        //        }
        //        tableview.reloadData()
        //    }
        //
        
    }
 }
