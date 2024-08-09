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

    @IBOutlet weak var backButton: UIView!
    @IBOutlet var menuview: UIView!
    var isShowingSubcategories = false
    var selectedSubcategories: [DatumSubCategory] = []
  
    var data = [String]()
    var imagedata = [String]()
    var categoryStates: [CategoryState] = []

    
    
    
    
    
    // new
    var currentLevel: Int = 0
    var currentCategories: [Any] = []
    // new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = true
        isSelected  = "Home"
        self.menuview.backgroundColor = UIColor.white
        let fullText = "Top Categories"
                let topText = "Top"
                let categoriesText = "Categories"
                
                let attributedString = NSMutableAttributedString(string: fullText)
                
                let topTextRange = (fullText as NSString).range(of: topText)
                let categoriesTextRange = (fullText as NSString).range(of: categoriesText)
                
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: topTextRange)
                attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#2D8CF8"), range: categoriesTextRange)
                
                name.attributedText = attributedString
        name.text = "topcategories".pLocalized(lang: LanguageManager.language)

        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSSideMenu), name: NSNotification.Name(rawValue: "sidemenuReload"), object: nil)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        SetupAppColor()
        self.CreateMenuitemList()
        loadInitialData()
        
    }
    func loadInitialData() {
        if let categories = AppDefault.getAllCategoriesResponsedata {
            currentCategories = categories
            currentLevel = 0
            tableview.reloadData()
            backButton.isHidden = true
           
        }
    }
    override func dismissViewController(_ sender: UIButton) {
        if isShowingSubcategories {
               isShowingSubcategories = false
            categoryStates.removeAll()

            tableview.reloadData()
           }
    }
    @objc func reloadSSideMenu(notification: Notification) {


    }
    func SetupAppColor(){
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        if(currentLevel == 1){
            backButton.isHidden = true
        }
        guard !categoryStates.isEmpty else { return }
           let previousState = categoryStates.removeLast()
           currentCategories = previousState.categories
           currentLevel = previousState.level
           tableview.reloadData()
           
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
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategories.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SideMenuCell
//        cell.selectionStyle = .none
//        let dict  = AppDefault.getAllCategoriesResponsedata?[indexPath.row]
//        cell.lab.text = dict?.name
//        cell.imagelbl.pLoadImage(url: dict?.mainImage ?? "" )
//        
//        cell.imagelbl.tintColor = .gray
//        cell.lab.textColor  =  .black
//        
//        if cell.lab.text == isSelected{
//
//        }
        cell.selectionStyle = .none
            
            if currentLevel == 0 {
                let category = currentCategories[indexPath.row] as? getAllCategoryResponse
                if LanguageManager.language == "ar"{
                    cell.lab.text = category?.lang?.ar?.name
                }else{
                    cell.lab.text = category?.name
                }
                cell.imagelbl.pLoadImage(url: category?.mainImage ?? "")
                
            } else if currentLevel == 1 {
                let subCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if LanguageManager.language == "ar"{
                    cell.lab.text = subCategory?.lang?.ar?.name
                }else{
                    cell.lab.text = subCategory?.name
                }
                cell.imagelbl.pLoadImage(url: subCategory?.mainImage ?? "")
            } else if currentLevel == 2 {
                let subSubCategory = currentCategories[indexPath.row] as? PurppleSubCategory
                if LanguageManager.language == "ar"{
                    cell.lab.text = subSubCategory?.lang?.ar?.name
                }else{
                    cell.lab.text = subSubCategory?.name
                }
                cell.imagelbl.pLoadImage(url: subSubCategory?.mainImage ?? "")
            } else if currentLevel == 3 {
                let subSubSubCategory = currentCategories[indexPath.row] as! FlufffySubCategory
                cell.lab.text = subSubSubCategory.name
                cell.imagelbl.pLoadImage(url: subSubSubCategory.mainImage ?? "")
            }
            
            cell.imagelbl.tintColor = .gray
            cell.lab.textColor = .black
            
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       

        categoryStates.append(CategoryState(categories: currentCategories, level: currentLevel))
       

        if currentLevel == 0 {
                let selectedCategory = currentCategories[indexPath.row] as? getAllCategoryResponse
            if let subCategories = selectedCategory?.subCategories, !subCategories.isEmpty {
                    currentCategories = subCategories
                    currentLevel = 1
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            } else if currentLevel == 1 {
                let selectedSubCategory = currentCategories[indexPath.row] as? DatumSubCategory
                if let subSubCategories = selectedSubCategory?.subCategories, !subSubCategories.isEmpty {
                    currentCategories = subSubCategories
                    currentLevel = 2
                    tableView.reloadData()
                } else {
                  
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
//                    self.view.makeToast("Subcategories are empty")
                }
            } else if currentLevel == 2 {
                let selectedSubSubCategory = currentCategories[indexPath.row] as? PurppleSubCategory
                if let subSubSubCategories = selectedSubSubCategory?.subCategories, !subSubSubCategories.isEmpty {
                    currentCategories = subSubSubCategories
                    currentLevel = 3
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            } else if currentLevel == 3 {
                let selectedSubSubSubCategory = currentCategories[indexPath.row] as? FlufffySubCategory
                if let subSubSubSubCategories = selectedSubSubSubCategory?.subCategories, !subSubSubSubCategories.isEmpty {
                    currentCategories = subSubSubSubCategories
                    currentLevel = 4
                    tableView.reloadData()
                } else {
                    let vc = Category_ProductsVC.getVC(.productStoryBoard)
                    vc.prductid = selectedSubSubSubCategory?.id ?? ""
                    vc.video_section = false
                    vc.storeFlag = false
                    vc.catNameTitle = selectedSubSubSubCategory?.name ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                    categoryStates.removeAll()
                }
            }
        if categoryStates.isEmpty {
            self.backButton.isHidden = true // Hide back button when no more previous states
        }else{
            self.backButton.isHidden = false
        }
    }
 }


struct CategoryState {
    let categories: [Any]
    let level: Int
}
