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
    var productModel : ProductCategoriesDetailsResponse?
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
    
    var tblCount:Int?
    var array : [Int] = []

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
        
        
        
        
//        if(productModel?.selectedAttributes?.contains(where: {$0.value == data}){
//            cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
//            cell.subcollectionlabel.textColor = .white
//            cell.subcollectionVie.borderWidth = 0
//
//        }else{
//            cell.subcollectionVie.backgroundColor? = .white
//            cell.subcollectionlabel.textColor = .gray
//            cell.subcollectionVie.borderWidth = 1
//            cell.subcollectionVie.borderColor = UIColor.gray
//        }
//
        if collectionView.tag == 0 {
            if AppDefault.attribute1 == data {
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderWidth = 0

            }else {
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionlabel.textColor = .gray
                cell.subcollectionVie.borderWidth = 1
                cell.subcollectionVie.borderColor = UIColor.gray
            }
        } else if collectionView.tag == 1 {
            if AppDefault.attribute2 == data {
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderWidth = 0

            }else {
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionlabel.textColor = .gray
                cell.subcollectionVie.borderWidth = 1
                cell.subcollectionVie.borderColor = UIColor.gray
            }
        }  else if collectionView.tag == 2 {
            if AppDefault.attribute3 == data {
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderWidth = 0

            }else {
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionlabel.textColor = .gray
                cell.subcollectionVie.borderWidth = 1
                cell.subcollectionVie.borderColor = UIColor.gray
            }
        } else  {
            if AppDefault.attribute4 == data {
                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
                cell.subcollectionlabel.textColor = .white
                cell.subcollectionVie.borderWidth = 0

            }else {
                cell.subcollectionVie.backgroundColor? = .white
                cell.subcollectionlabel.textColor = .gray
                cell.subcollectionVie.borderWidth = 1
                cell.subcollectionVie.borderColor = UIColor.gray
            }
        }
        
//        print(self.SubCategorycollectionviewIndex)
//        
//            if(self.SubCategorycollectionviewIndex == indexPath.row){
//                cell.subcollectionVie.backgroundColor =  Utilities.hexStringToUIColor(hex: "#fd4f0d")
//                cell.subcollectionlabel.textColor = .white
//                cell.subcollectionVie.borderWidth = 0
//
//             
//            }else{
//                cell.subcollectionVie.backgroundColor? = .white
//                cell.subcollectionlabel.textColor = .gray
//                cell.subcollectionVie.borderWidth = 1
//                cell.subcollectionVie.borderColor = UIColor.gray
//            }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = collectionView.tag // Use collection view's tag to identify which row it belongs to
        saveAndAppendToArray(newElement: row)
        let savedArray = UserDefaults.standard.array(forKey: "myNumbersArray") as? [Int] ?? [Int]()

        let uniqueNumbers = savedArray.enumerated().filter { index, element in
            savedArray.firstIndex(of: element) == index
        }.map { $0.element }
   
        print("Saved Array: \(uniqueNumbers)")
  if row == 0 {
    let data = self.productcategoriesdetailsdata?[0].values
     let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
     AppDefault.attribute1 = trimmedString

  }else if row == 1{
      let data = self.productcategoriesdetailsdata?[1].values
      let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
      AppDefault.attribute2 = trimmedString
  }else if row == 2{
      let data = self.productcategoriesdetailsdata?[2].values
      let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
      AppDefault.attribute3 = trimmedString
  } else {
      let data = self.productcategoriesdetailsdata?[3].values
      let trimmedString = data?[indexPath.row].trimmingCharacters(in: .whitespaces)
      AppDefault.attribute4 = trimmedString
  }
        if uniqueNumbers.count ==  tblCount {
            print("sucess")
                    if self.productcategoriesdetailsdata?.count  ?? 0 == 1 {
                        for i in self.productcategoriesdetailsvariantdata ?? [] {
                            if  AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? "" {
                                print(i.slug ?? "")
                                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","iselectd": "true","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                            }
                        }
                    }else if self.productcategoriesdetailsdata?.count ?? 0 == 2 {
                        for i in self.productcategoriesdetailsvariantdata ?? [] {
                            if AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? ""  && AppDefault.attribute2 ?? "" ==  i.selectedAttributes?[1].value ?? "" {
                                print(i.slug ?? "")
                                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","iselectd": "true","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                            }
                        }
                    }else if self.productcategoriesdetailsdata?.count ?? 0 == 3{
                        for i in self.productcategoriesdetailsvariantdata ?? [] {
                            if AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? ""  && AppDefault.attribute2 ?? "" ==  i.selectedAttributes?[1].value ?? ""  && AppDefault.attribute3 ?? "" == i.selectedAttributes?[2].value ?? ""{
                                print(i.slug ?? "")
                                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","iselectd": "true","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                            }
                        }
                    } else {
                        for i in self.productcategoriesdetailsvariantdata ?? [] {
                            if AppDefault.attribute1 ?? "" == i.selectedAttributes?[0].value ?? ""  && AppDefault.attribute2 ?? "" ==  i.selectedAttributes?[1].value ?? ""  && AppDefault.attribute3 ?? "" == i.selectedAttributes?[2].value ?? "" && AppDefault.attribute4 ?? "" == i.selectedAttributes?[3].value ?? ""{
                                print(i.slug ?? "")
                                let imageDataDict:[String: String] = ["variantSlug": i.slug ?? "","iselectd": "true","SubCategorycollectionviewIndex": "\(indexPath.row)"]
                                NotificationCenter.default.post(name: Notification.Name("variantSlug"), object: nil,userInfo: imageDataDict)
                            }
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
    func saveAndAppendToArray(newElement: Int) {
        let defaults = UserDefaults.standard
        let key = "myNumbersArray"
        
        // Retrieve the current array from UserDefaults, or create an empty one if it doesn't exist
        var currentArray = defaults.array(forKey: key) as? [Int] ?? [Int]()
        
        // Append the new element to the array
        currentArray.append(newElement)
        
        // Save the updated array back to UserDefaults
        defaults.set(currentArray, forKey: key)
        
        print("Updated Array: \(currentArray)")
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
