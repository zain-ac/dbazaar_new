//
//  ProductDetailVarientTableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 30/08/2023.
//

import UIKit

class ProductDetailVarientTableViewCell: UITableViewCell {

    @IBOutlet weak var attributesLbl: UILabel!
    
    @IBOutlet weak var attributesCollectionV: UICollectionView!

    var productcategoriesdetailsdata : [Attributeobj]?{
        didSet{
            attributesCollectionV.reloadData()
        }
    }

    var productcategoriesdetailsvariantdata : [Variant]?{
        didSet{
            attributesCollectionV.reloadData()
        }
    }


    var SubCategorycollectionviewIndex : Int? = nil
    
    var index = Int()
    var totalIndex = Int()
    var totalindex = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProductDetailVarientTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productcategoriesdetailsdata?[index].values?.count ?? 0
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCollectionView", for: indexPath) as! SubCategoriesCollectionView
        let data =  self.productcategoriesdetailsdata?[index].values?[indexPath.row]
        
         cell.subcollectionlabel.text = data
//        cell.subcollectionlabel.text = data?[index].value
            if(self.SubCategorycollectionviewIndex == indexPath.row){
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderWidth = 0

             
            }else{
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionlabel.textColor = .gray
                cell.subcollectionVie.borderWidth = 1
                cell.subcollectionVie.borderColor = UIColor.gray
            }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

         if index == 0 {
            let data = self.productcategoriesdetailsdata?[0].values
             let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
             AppDefault.attribute1 = trimmedString

          }else if index == 1{
              let data = self.productcategoriesdetailsdata?[1].values
              let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
              AppDefault.attribute2 = trimmedString
          }else {
              let data = self.productcategoriesdetailsdata?[2].values
              let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
              AppDefault.attribute3 = trimmedString
          }

        
        if self.productcategoriesdetailsdata?.count  ?? 0 == 1 {
            for i in self.productcategoriesdetailsvariantdata ?? [] {
                if  AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? "" {
                    print(i.slug ?? "")
                    let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                    NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                }
            }
        }else if self.productcategoriesdetailsdata?.count ?? 0 == 2 {
            for i in self.productcategoriesdetailsvariantdata ?? [] {
                if AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? ""  && AppDefault.attribute2 ?? "" ==  i.selectedAttributes?[1].value ?? "" {
                    print(i.slug ?? "")
                    let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                    NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                }
            }
        }else {
            for i in self.productcategoriesdetailsvariantdata ?? [] {
                if AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? ""  && AppDefault.attribute2 ?? "" ==  i.selectedAttributes?[1].value ?? ""  && AppDefault.attribute3 ?? "" == i.selectedAttributes?[2].value ?? ""{
                    print(i.slug ?? "")
                    let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                    NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                }
            }
        }

        SubCategorycollectionviewIndex = indexPath.row

        attributesCollectionV.reloadData()

//        let data = self.productcategoriesdetailsdata
//        SubCategorycollectionviewIndex = indexPath.row
//        for i in self.productcategoriesdetailsvariantdata ?? [] {
//            for f in data?[0].values ?? []{
//                if i.selectedAttributes?[0].value  ==  f {
//                    print(i.slug ?? "")
//                    let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
//                    NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
//                }
//            }
//
//
//        }
//
//        if data?.count == 1 {
//            if data?[0].values?[indexPath.row] == i.selectedAttributes?[0].value  {
//                print(i.slug ?? "")
//                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
//                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
//            }
//        }else if data?.count == 2 {
//            if data?[0].values?[indexPath.row] == i.selectedAttributes?[0].value && data?[1].values?[indexPath.row] == i.selectedAttributes?[1].value {
//                print(i.slug ?? "")
//                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
//                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
//            }
//        }else if data?.count == 3 {
//            if data?[0].values?[indexPath.row] == i.selectedAttributes?[0].value && data?[1].values?[indexPath.row] == i.selectedAttributes?[1].value && data?[2].values?[indexPath.row] == i.selectedAttributes?[2].value{
//                print(i.slug ?? "")
//                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
//                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
//            }
//        }
        
        
        
        
//        let data = self.productcategoriesdetailsvariantdata?[indexPath.row]
//        AppDefault.variantSlug = data?.slug ?? ""
//        let index = indexPath.row
//        SubCategorycollectionviewIndex = index
//        let imageDataDict:[String: String] = ["variantSlug": data?.slug ?? "","SubCategorycollectionviewIndex": "\(indexPath.row)"]
//        NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        let data =  self.productcategoriesdetailsdata?[index].values?[indexPath.row]
        
        if indexPath.row <= self.productcategoriesdetailsdata?[index].values?.count ?? 0 - 1 {
                  label.text = data
              }
              
              label.sizeToFit()
              return CGSize(width: label.frame.width + 20, height: 35)
    }
    
}
