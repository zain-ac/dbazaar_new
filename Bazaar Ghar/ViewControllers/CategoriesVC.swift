//
//  CategoriesVC.swift
//  BAZAAR GHAR
//
//  Created by Umair ALi on 24/08/2023.
//

import UIKit
import AudioToolbox
import SocketIO


class CategoriesVC: UIViewController {
    @IBOutlet weak var Maincollectionview:UICollectionView!
    @IBOutlet weak var SubCategorycollectionview:UICollectionView!
    @IBOutlet weak var Varientscollectionview:UICollectionView!
    @IBOutlet weak var homeswitchbtn: UISwitch!

    @IBOutlet weak var searchProductslbs: UITextField!
    @IBOutlet weak var livelbl: UILabel!
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var emptyLbl:UILabel!

    
    var Mainview = [String]()
    var subview = [String]()
    var Varientsview = [String]()
    var MaincollectionIndex = 0
    var SubCategorycollectionviewIndex = 0
    var CategoriesResponsedata: [CategoriesResponse] = []
    var manager:SocketManager?
    var socket: SocketIOClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      
      
        
       
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(Swipeleft))
                        left.direction = .left
                        self.Varientscollectionview.addGestureRecognizer(left)
                        
                let right = UISwipeGestureRecognizer(target : self, action : #selector(Swiperight))
                        right.direction = .right
                        self.Varientscollectionview.addGestureRecognizer(right)
        
        homeswitchbtn.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

    }
    @IBAction func switchChanged(_ sender: UISwitch) {
           if sender.isOn {
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               let vc = Live_VC.getVC(.main)
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        homeswitchbtn.isOn = false
        if( AppDefault.CategoriesResponsedata?.count ?? 0 > 0 ){
           
            
            self.CategoriesResponsedata = AppDefault.CategoriesResponsedata ?? []
            
           
            
            self.Maincollectionview.reloadData()
            self.SubCategorycollectionview.reloadData()
            self.Varientscollectionview.reloadData()
            
            
            
        }else{
            self.categoriesApi(isbackground: false)
        }
        
        self.LanguageRender()

        if LanguageManager.language == "ar" {
            hederView.semanticContentAttribute = .forceLeftToRight
        }else {
            hederView.semanticContentAttribute = .forceLeftToRight
        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        
        self.Maincollectionview.delegate = self
        self.Maincollectionview.dataSource = self
        self.SubCategorycollectionview.delegate = self
        self.SubCategorycollectionview.dataSource = self
        self.Varientscollectionview.delegate = self
        self.Varientscollectionview.dataSource = self
     }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let vc = LIVE_videoNew.getVC(.main)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func LanguageRender(){
        searchProductslbs.placeholder = "searchproducts".pLocalized(lang: LanguageManager.language)
        livelbl.text = "live".pLocalized(lang: LanguageManager.language)
//        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    func scrollToIndex(index:Int) {
         let rect = self.SubCategorycollectionview.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
         self.SubCategorycollectionview.scrollRectToVisible(rect!, animated: true)
       
     }
    @objc func Swipeleft(){
        let cout = CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0
        if(self.SubCategorycollectionviewIndex == cout - 1){
       
           
        }else{
            SubCategorycollectionviewIndex += 1
            self.Maincollectionview.reloadData()
            self.SubCategorycollectionview.reloadData()
            self.Varientscollectionview.reloadData()
           
        }
           }
           
           @objc
           func Swiperight(){
               if( SubCategorycollectionviewIndex == 0){
             
                   
               }else{
                   SubCategorycollectionviewIndex -= 1 
                   self.Maincollectionview.reloadData()
                   self.SubCategorycollectionview.reloadData()
                   self.Varientscollectionview.reloadData()
               }
           }
    
 
    private func categoriesApi(isbackground:Bool) {
        APIServices.categories(isbackground:isbackground,completion: {[weak self] data in
            switch data {
            case .success(let res):
                
                self?.CategoriesResponsedata = res.Categoriesdata ?? []
                
                AppDefault.CategoriesResponsedata = res.Categoriesdata
                
                self?.Maincollectionview.reloadData()
                self?.SubCategorycollectionview.reloadData()
                self?.Varientscollectionview.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = Search_ViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func bazaarGharImgBtnTapped(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
    }
    
    
}
extension CategoriesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Maincollectionview {
            return CategoriesResponsedata.count
        }else if collectionView == SubCategorycollectionview {
            if(CategoriesResponsedata.count > 0)
            {
                return CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0
            } else {
                return 0
            }
           
        }else {
            if(CategoriesResponsedata.count > 0){
                if(CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0 > 0){
                    return CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?.count ?? 0
                }else{
                    return 0
                }
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == Maincollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
            let data = CategoriesResponsedata[indexPath.row]
            cell.imageView.pLoadImage(url: data.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.topCatLbl.text = data.lang?.ar?.name ?? ""
            }else{
                cell.topCatLbl.text = data.name ?? ""
            }
            if(self.MaincollectionIndex == indexPath.row){
                cell.bgView.backgroundColor = .white
            }else{
                cell.bgView.backgroundColor = .systemGray6
            }
            
            return cell
        }else if collectionView == SubCategorycollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCollectionView", for: indexPath) as! SubCategoriesCollectionView
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.row]
            if LanguageManager.language == "ar"{
                cell.subcollectionlabel.text = data?.lang?.ar?.name
            }else{
                cell.subcollectionlabel.text = data?.name
            }
            if(self.SubCategorycollectionviewIndex == indexPath.row){
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#2974f1")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderColor = UIColor.gray
                cell.subcollectionVie.borderWidth = 0
             
            }else{
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionVie.borderColor = UIColor.gray
                cell.subcollectionVie.borderWidth = 1

//                cell.subcollectionlabel.borderColor = UIColor.gray
                cell.subcollectionlabel.textColor = .black
            }
            self.scrollToIndex(index: self.SubCategorycollectionviewIndex)
            // Configure cell with data from array2
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientsCollectionView", for: indexPath) as! VarientsCollectionView
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row]
            cell.Varientscollectionimg.pLoadImage(url: data?.mainImage ?? "")
            if LanguageManager.language == "ar"{
                cell.Varientscollectionlabel.text = data?.lang?.ar?.name
            }else{
                cell.Varientscollectionlabel.text = data?.name
            }
            if CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?.count ?? 0 > 0 {
                emptyLbl.isHidden = true
            }else {
                emptyLbl.isHidden = false
            }
       
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == Maincollectionview {
            return CGSize(width: self.Maincollectionview.frame.width, height: self.Maincollectionview.frame.height/8)
            return CGSize(width: self.Maincollectionview.frame.width, height: self.Maincollectionview.frame.height/8)
        }else if collectionView == SubCategorycollectionview {
            let label = UILabel(frame: CGRect.zero)
                  if indexPath.row <= self.CategoriesResponsedata[MaincollectionIndex].subCategories?.count ?? 0 - 1 {
                      if LanguageManager.language == "ar" {
                          label.text =  self.CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.item].lang?.ar?.name
                      }else {
                          label.text =  self.CategoriesResponsedata[MaincollectionIndex].subCategories?[indexPath.item].name
                      }
                  }
                  
                  label.sizeToFit()
                  return CGSize(width: label.frame.width + 15, height: 45)
            
        }else {
            return CGSize(width: self.Varientscollectionview.frame.width/3-10, height: 135)
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == Maincollectionview {
            self.MaincollectionIndex = indexPath.item
            self.SubCategorycollectionviewIndex = 0
           
        }else if collectionView == SubCategorycollectionview {
            self.SubCategorycollectionviewIndex = indexPath.item
        }else {
  
            let data = CategoriesResponsedata[MaincollectionIndex].subCategories?[SubCategorycollectionviewIndex].subCategories?[indexPath.row]
            let vc = Category_ProductsVC.getVC(.main)
            vc.prductid = data?.id ?? ""
        
            vc.video_section = false
            vc.storeFlag = false
            vc.catNameTitle = data?.name ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
        self.Maincollectionview.reloadData()
        self.SubCategorycollectionview.reloadData()
        self.Varientscollectionview.reloadData()
    }
   

}

