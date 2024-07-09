//
//  CategoriesPopUpVC.swift
//  Bazaar Ghar
//
//  Created by Developer on 24/06/2024.
//

import UIKit

class CategoriesPopUpVC: UIViewController {
    var CategoriesResponsedata: [getAllCategoryResponse] = []
    @IBOutlet weak var topcell_1: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        topcell_1.delegate = self
        topcell_1.dataSource = self
 CategoriesResponsedata =  AppDefault.getAllCategoriesResponsedata ?? []
        topcell_1.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CategoriesPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return CategoriesResponsedata.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcategoriescell", for: indexPath) as! topcategoriescell
        let data = CategoriesResponsedata[indexPath.row]
        cell.imageView.pLoadImage(url: data.mainImage ?? "")
            
            
            if LanguageManager.language == "ar"{
                cell.topCatLbl.text = data.lang?.ar?.name
            }else{
                cell.topCatLbl.text = data.name
            }
            
            return cell
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
            return CGSize(width: self.topcell_1.frame.width/3.75-10, height: self.topcell_1.frame.height/2.1-5)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let data = CategoriesResponsedata[indexPath.row]

              let vc = Category_ProductsVC.getVC(.main)
        vc.prductid = data.id ?? ""
              vc.video_section = false
              vc.storeFlag = false
        vc.catNameTitle = data.name ?? ""
              self.navigationController?.pushViewController(vc, animated: false)
          
        
    }
    
}
