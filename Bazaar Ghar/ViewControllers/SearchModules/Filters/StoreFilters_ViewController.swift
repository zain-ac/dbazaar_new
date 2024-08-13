//
//  StoreFilters_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 13/07/2024.
//

import UIKit
import RangeSeekSlider
protocol StoreFilters_ViewControllerDelegate: AnyObject {
    func StoreFilters_ViewControllerDidFinish(_ controller: StoreFilters_ViewController, withData data: [TypeSenseResult])
}

class StoreFilters_ViewController: UIViewController {
    
    @IBOutlet weak var categoriestbl: UITableView!
    @IBOutlet weak var store_collect: UICollectionView!
    @IBOutlet weak var size_collect: UICollectionView!
    @IBOutlet weak var FilterColletion: UICollectionView!
    @IBOutlet weak var heightFilter: NSLayoutConstraint!
    @IBOutlet weak var heightCategory: NSLayoutConstraint!
    @IBOutlet weak var heightStore: NSLayoutConstraint!
    @IBOutlet weak var heightrating: NSLayoutConstraint!
    @IBOutlet weak var heightsize: NSLayoutConstraint!
    @IBOutlet weak var heightcolor: NSLayoutConstraint!
    @IBOutlet weak var colors_tbl: UITableView!
    @IBOutlet fileprivate weak var rangeSlider: RangeSeekSlider!
    var selectedIndex: Int?
    var sizeIndex: Int?
    var ratingndex: Int?
    var colorIndex: Int?

    @IBOutlet weak var rating_collect: UICollectionView!
    var  facetCounts: [TypeSenseFacetCount] = []

    var SelectedCat0Model:  TypeSenseCount? = nil
    var SelectedStoreModel:  TypeSenseCount? = nil
    var SelectedsizeeModel:  TypeSenseCount? = nil
    var SelectedColorModel:  TypeSenseCount? = nil
    var SelectedratingModel:  TypeSenseCount? = nil
    var DisplayCat0Model:  TypeSenseFacetCount? = nil
    var Cat0Model:  TypeSenseFacetCount? = nil
    var Cat1Model:  TypeSenseFacetCount? = nil
    var Cat2Model:  TypeSenseFacetCount? = nil
    var StoreModel:  TypeSenseFacetCount? = nil
    var ColorModel:  TypeSenseFacetCount? = nil
    var priceModel:  TypeSenseFacetCount? = nil
    var sizeModel:  TypeSenseFacetCount? = nil
    var RatingmOdel:  TypeSenseFacetCount? = nil
    var StyleModel:  TypeSenseFacetCount? = nil
    var FiltermodelArray:  [TypeSenseCount] = []
    {
        didSet {
        
        
        if(FiltermodelArray.count > 0){
            self.heightFilter.constant = 60
        }else{
            self.heightFilter.constant = 0
        }
        
        
        
        
        if(Cat0Model?.counts?.count != 0){
            self.heightCategory.constant = 158
        }else{
            self.heightCategory.constant = 0
        }
        if(StoreModel?.counts?.count != 0 ){
            self.heightStore.constant = 65
        }else{
            self.heightStore.constant = 0
        }
        if(ColorModel?.counts?.count != 0){
            self.heightcolor.constant = 160
        }else{
            self.heightcolor.constant = 0
        }
         if(sizeModel?.counts?.count != 0){
            self.heightsize.constant = 65
        }else{
            self.heightsize.constant = 0
        }
        if(RatingmOdel?.counts?.count != 0){
            self.heightrating.constant = 65
        }else{
            self.heightrating.constant = 0
        }
        
        AppDefault.facetFilterArray = FiltermodelArray
      
         self.FilterColletion.reloadData()
    }
        
    }
    
    var selectedColor:  [String] = []
    var selectedSizes:  [String] = []
    var selectedRating:  [Int] = []
    var allfacetfilter : String = ""
    var priceFilter : [String] = []
    var categoryString : [String] = []
    var selectedStores: [String] = []

    var  lastquery = String()
    weak var delegate: StoreFilters_ViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rangeSlider.minValue =  CGFloat(self.priceModel?.stats?.min ?? 0.0)
        self.rangeSlider.maxValue =  CGFloat(self.priceModel?.stats?.max ?? 0.0)
        self.rangeSlider.colorBetweenHandles = .blue
        self.rangeSlider.handleColor = .white
        self.rangeSlider.handleBorderColor = .blue
        self.rangeSlider.handleBorderWidth = 1
          if(FiltermodelArray.count > 0){
            self.heightFilter.constant = 60
        }else{
            self.heightFilter.constant = 0
        }
    
        
        self.FiltermodelArray  = AppDefault.facetFilterArray ?? []
        
        FilterColletion.reloadData()
        

        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        categoriestbl.delegate = self
        categoriestbl.dataSource = self
        size_collect.dataSource = self
        size_collect.delegate = self
        store_collect.delegate = self
        store_collect.dataSource = self
        colors_tbl.delegate = self
        colors_tbl.dataSource = self
        rating_collect.delegate = self
        rating_collect.dataSource = self
        FilterColletion.delegate = self
        FilterColletion.dataSource = self
//        productcategoriesApi(val: "", str: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style")
      
    }

   
    @objc func SelectCategorerybtn(_ sender: UIButton) {
        var data = DisplayCat0Model?.counts?[sender.tag]
        data?.isselected = true
        data?.isquery = DisplayCat0Model?.fieldName
        self.SelectedCat0Model = data
        
        if(FiltermodelArray.contains(where: { return $0.isquery == DisplayCat0Model?.fieldName}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == DisplayCat0Model?.fieldName})
            self.FiltermodelArray.append(self.SelectedCat0Model!)
        }else{
            self.FiltermodelArray.append(self.SelectedCat0Model!)
        }
        Cat0Model?.counts?[sender.tag]?.isselected = true
        
        self.categoriestbl.reloadData()
        
        
    }
   
    private func FetchData(val:String, txt: String,facet_by:String,isclick:Bool){
        allfacetfilter = ""
     
        
        if(self.SelectedCat0Model != nil){
            if(SelectedCat0Model?.isquery == "lvl0"){
                if(allfacetfilter == ""){
                    allfacetfilter  = "lvl0:=[\(self.SelectedCat0Model?.value ?? "")]"
                }else{
                    allfacetfilter  += "&&lvl0:=[\(self.SelectedCat0Model?.value ?? "")]"
                }
            }
            if(SelectedCat0Model?.isquery == "lvl1"){
                if(allfacetfilter == ""){
                    allfacetfilter  = "lvl1:=[\(self.SelectedCat0Model?.value ?? "")]"
                }else{
                    allfacetfilter  += "&&lvl1:=[\(self.SelectedCat0Model?.value ?? "")]"
                }
            }
            if(SelectedCat0Model?.isquery == "lvl2"){
                if(allfacetfilter == ""){
                    allfacetfilter  = "lvl2:=[\(self.SelectedCat0Model?.value ?? "")]"
                }else{
                    allfacetfilter  += "&&lvl2:=[\(self.SelectedCat0Model?.value ?? "")]"
                }
            }
            
            
        }
        if(self.SelectedratingModel != nil){
            
            if(allfacetfilter == ""){
                allfacetfilter  = "averageRating:=[\(self.SelectedratingModel?.value ?? "")]"
            }else{
                allfacetfilter  += "&&averageRating:=[\(self.SelectedratingModel?.value ?? "")]"
            }
            
          
        }
        if(SelectedColorModel != nil){
            
            if(allfacetfilter == ""){
                allfacetfilter  =  "color:=[\(self.SelectedColorModel?.value ?? "")]"
            }else{
                allfacetfilter  +=  "&&color:=[\(self.SelectedColorModel?.value ?? "")]"
            }
          
        }
        if(SelectedStoreModel != nil){
            
            if(allfacetfilter == ""){
                allfacetfilter  =  "brandName:=[\(self.SelectedStoreModel?.value ?? "")]"
            }else{
                allfacetfilter  +=  "&&brandName:=[\(self.SelectedStoreModel?.value ?? "")]"
            }
          
          
        }
        if(SelectedsizeeModel != nil){
            
            if(allfacetfilter == ""){
                allfacetfilter  =   "size:=[\(self.SelectedsizeeModel?.value ?? "")]"
            }else{
                allfacetfilter  +=   "&&size:=[\(self.SelectedsizeeModel?.value ?? "")]"
            }
            
         
        }

        if(rangeSlider.selectedMinValue == priceModel?.stats?.min && rangeSlider.selectedMaxValue == priceModel?.stats?.max){
            
        } else {
        
            
//            if(allfacetfilter == ""){
//                allfacetfilter  =   "price:=[\(Int(rangeSlider.selectedMinValue))..\(Int(rangeSlider.selectedMaxValue))]"
//            }else{
//                allfacetfilter  +=   "&&price:=[\(Int(rangeSlider.selectedMinValue))..\(Int(rangeSlider.selectedMaxValue))]"
//            }
            

        }
    
       // allfacetfilter.append("productType:=[main]")
         
      
        print(allfacetfilter)
        facetCounts.removeAll()
        self.Cat0Model = nil
            self.Cat1Model = nil
            self.Cat2Model = nil
            self.ColorModel = nil
            self.StoreModel = nil
            self.RatingmOdel = nil
            self.priceModel = nil
            self.sizeModel = nil
            self.StyleModel = nil
         APIServices.typeSenseApi(val: allfacetfilter, txt : txt ,facet_by:facet_by,completion: {[weak self] data in
            switch data{
            case .success(let res):
                AppDefault.facetFilters = res
               
                
               
//                for r in res {
//
//                    for z in r.facetCounts ?? [] {
//                        self?.facetCounts.append(z!)
//                    }
//                }
                
                
                for item in res.first?.facetCounts ?? []{
                    if(item?.fieldName == "lvl0"){
                     
                        
                        
                        self?.Cat0Model = item
                    }
                    if(item?.fieldName == "lvl1"){
                        self?.Cat1Model = item
                    }
                    if(item?.fieldName == "lvl2"){
                        self?.Cat2Model = item
                    }
                    if(item?.fieldName == "color"){
                        self?.ColorModel = item
                    }
                    if(item?.fieldName == "brandName"){
                        self?.StoreModel = item
                    }
                    if(item?.fieldName == "averageRating"){
                        self?.RatingmOdel = item
                    }
                    if(item?.fieldName == "price"){
                        self?.priceModel = item
                    }
                     if(item?.fieldName == "size"){
                        self?.sizeModel = item
                    }
                    if(item?.fieldName == "style"){
                       self?.StyleModel = item
                   }
                }
                
                
                if(self?.Cat0Model?.counts?.count == 1 && self?.Cat0Model?.counts?.count != 0 && self?.Cat0Model?.counts?.first??.value == self?.SelectedCat0Model?.value){
                
                    self?.DisplayCat0Model = self?.Cat1Model
                    
                    
                    
                    
                }else{
                    self?.DisplayCat0Model = self?.Cat0Model
                }
                
                if(self?.Cat1Model?.counts?.count == 1 && self?.Cat1Model?.counts?.count != 0 && self?.Cat1Model?.counts?.first??.value == self?.SelectedCat0Model?.value){
                
                    self?.DisplayCat0Model = self?.Cat2Model
                    
                    
                }else{
                    if(self?.Cat0Model?.counts?.count == 0){
                        self?.DisplayCat0Model = self?.Cat1Model
                    }
                    
                }
                
                
                
                
                
                if(self?.DisplayCat0Model?.counts?.count != 0){
                    self?.heightCategory.constant = 168
                }else{
                    self?.heightCategory.constant = 0
                }
                if(self?.StoreModel?.counts?.count != 0 ){
                    self?.heightStore.constant = 65
                }else{
                    self?.heightStore.constant = 0
                }
                if(self?.ColorModel?.counts?.count != 0){
                    self?.heightcolor.constant = 170
                }else{
                    self?.heightcolor.constant = 0
                }
                if(self?.sizeModel?.counts?.count != 0){
                     self?.heightsize.constant = 65
                }else{
                    self?.heightsize.constant = 0
                }
                if(self?.RatingmOdel?.counts?.count != 0){
                    self?.heightrating.constant = 75
                }else{
                    self?.heightrating.constant = 0
                }
                self?.rangeSlider.minValue =  CGFloat(self?.priceModel?.stats?.min ?? 0.0)
//                self?.rangeSlider.selectedMinValue =  CGFloat(self?.priceModel?.stats?.min ?? 0.0)
//                self?.rangeSlider.selectedMaxValue =  CGFloat(self?.priceModel?.stats?.max ?? 0.0)
                self?.rangeSlider.maxValue =  CGFloat(self?.priceModel?.stats?.max ?? 0.0)
//
                
                self?.colors_tbl.reloadData()
                self?.categoriestbl.reloadData()
                self?.store_collect.reloadData()
                self?.rating_collect.reloadData()
                self?.size_collect.reloadData()
                if(isclick){
                    self?.dismiss(animated: true, completion: {
                        self?.delegate?.StoreFilters_ViewControllerDidFinish(self!, withData: res)
                    })
                }
               
             
               
                print(res)
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }
    
    
    
    
    @IBAction func filterButton(_ sender: UIButton) {
        if(SelectedCat0Model?.isquery == "lvl0"){
            self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: true)

        }
        if(SelectedCat0Model?.isquery == "lvl1"){
            self.FetchData(val: "", txt: "*",facet_by: "lvl1,lvl2,color,brandName,averageRating,price,size,style", isclick: true)

        }
       
      
    }
    @IBAction func clearFilter(_ sender: UIButton) {
       
        FiltermodelArray.removeAll()
        self.FetchData(val: "", txt: "*",facet_by: "lvl0,color,brandName,averageRating,price,size,style", isclick: true)
      }
    
}
extension StoreFilters_ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriestbl {
           
                return DisplayCat0Model?.counts?.count ?? 0
           
            
            
        }else{
            if(ColorModel != nil){
                return ColorModel?.counts?.count ?? 0
            }else{
                return 0
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoriestbl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFilterscategory_TableViewCell", for: indexPath) as! StoreFilterscategory_TableViewCell
            let data = DisplayCat0Model?.counts?[indexPath.row]
          
            cell.lbl.text =  data?.highlighted
            cell.countlbl.text  = String(describing: data?.count ?? 0)
            cell.img.tag = indexPath.row
            
            cell.img.addTarget(self, action: #selector(SelectCategorerybtn(_:)), for: .touchUpInside)
            if(self.FiltermodelArray.contains(where: {$0.value == data?.value})){
                cell.img.isSelected = true
            }else{
                cell.img.isSelected = false
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFiltersColors_TableViewCell", for: indexPath) as! StoreFiltersColors_TableViewCell
            let data = ColorModel?.counts?[indexPath.row]
            cell.colorBtnTap.tag = indexPath.row
            if(self.SelectedColorModel?.value == data?.value){
                cell.colorBtnTap.isSelected = true
            }else{
                cell.colorBtnTap.isSelected = false
            }
            cell.colorBtnTap.addTarget(self, action: #selector(colorButtonTap(_:)), for: .touchUpInside)
            cell.lbl.text = data?.highlighted
            cell.countlabel.text = String(describing: data?.count ?? 0)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == categoriestbl {
            let data = DisplayCat0Model?.counts?[indexPath.row]
            categoryString.append(data?.value ?? "")
        }else{
            let data = ColorModel?.counts?[indexPath.row]
            selectedColor.append(data?.value ?? "")
//            lastquery =  "color:=\(selectedColor)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
           
           
           
           
        }
    }
    
   
    
}
extension StoreFilters_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == store_collect {
            if(StoreModel != nil){
                return StoreModel?.counts?.count ?? 0
            }else{
                return 0
            }
              
            
         
        } else if collectionView == size_collect {
            if(sizeModel != nil){
                return sizeModel?.counts?.count ?? 0
            }else{
                return 0
            }
         
        } else if(collectionView == rating_collect){
            if(RatingmOdel != nil){
                return RatingmOdel?.counts?.count ?? 0
            }else{
                return 0
            }
        } else if(collectionView == FilterColletion){
          
            return FiltermodelArray.count ?? 0
          
        }
        else{
            return 0
        }
        

    }
    @objc func buttonTapped(_ sender: UIButton) {
        var data = StoreModel?.counts?[sender.tag]
        data?.isselected = true
        data?.isquery = "brandName"
        SelectedStoreModel = data
        StoreModel?.counts?[sender.tag]?.isselected = true
        sender.isSelected = !sender.isSelected
        
        
        if(FiltermodelArray.contains(where: { return $0.isquery == "brandName"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "brandName"})
            self.FiltermodelArray.append(self.SelectedStoreModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedStoreModel!)
        }
        
        
        
        selectedIndex = sender.tag
        store_collect.reloadData()
        
        
        // Notify the view controller that the button was tapped
    }
    
    @objc func sizeCollection(_ sender: UIButton) {
        var data = sizeModel?.counts?[sender.tag]
        sender.isSelected = !sender.isSelected
        data?.isquery = "size"
        data?.isselected = true
        SelectedsizeeModel = data
        StoreModel?.counts?[sender.tag]?.isselected = true
        sizeIndex = sender.tag
        
        
        if(FiltermodelArray.contains(where: { return $0.isquery == "size"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "size"})
            self.FiltermodelArray.append(self.SelectedsizeeModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedsizeeModel!)
        }
        
        size_collect.reloadData()
        
        
        // Notify the view controller that the button was tapped
        
    }
    @objc func colorButtonTap(_ sender: UIButton) {
        var data = ColorModel?.counts?[sender.tag]
      
        data?.isquery = "color"
        data?.isselected = true
        
        SelectedColorModel = data
        ColorModel?.counts?[sender.tag]?.isselected = true
        if(FiltermodelArray.contains(where: { return $0.isquery == "color"}) == true) {
            FiltermodelArray.removeAll(where: { return $0.isquery == "color"})
            self.FiltermodelArray.append(self.SelectedColorModel!)
        }else{
            self.FiltermodelArray.append(self.SelectedColorModel!)
        }
        colors_tbl.reloadData()
        
        
        // Notify the view controller that the button was tapped
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == store_collect {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersStore_CollectionViewCell", for: indexPath) as! StoreFiltersStore_CollectionViewCell
            let data = StoreModel?.counts?[indexPath.row]
            cell.storeBtn.setTitle(data?.highlighted ?? "" + "\(data?.highlighted?.count ?? 0)", for: .normal)
            cell.storeBtn.tag = indexPath.row
            cell.storeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            cell.storeBtn.titleLabel?.font = UIFont(name: "Poppins", size: CGFloat(10))
            
            if indexPath.item == selectedIndex {
                       cell.storeview.backgroundColor = UIColor(hex: "#06B7FD")
                       cell.storeBtn.backgroundColor = UIColor(hex: "#06B7FD")
                       cell.storeview.cornerRadius = 4
                       cell.storeBtn.cornerRadius  = 4
                cell.storeBtn.tintColor = .white
                   
                
                   } else {
                       cell.storeBtn.tintColor = UIColor(hex: "#909090")
                       cell.storeview.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.storeBtn.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.storeview.cornerRadius = 4
                       cell.storeBtn.cornerRadius  = 4
                 
                   }
            
            cell.lbl.text  = data?.highlighted ?? "" + "\(data?.highlighted?.count ?? 0)"
            
            return cell
            
        }else if collectionView == FilterColletion {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersStore_CollectionViewCell", for: indexPath) as! StoreFiltersStore_CollectionViewCell
            let data = FiltermodelArray[indexPath.row]
         
            
            cell.lbl.text  = data.highlighted ?? ""
            
            return cell
            
        }
        else if collectionView == size_collect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Size_CollectionViewCell", for: indexPath) as! Size_CollectionViewCell
            let data = sizeModel?.counts?[indexPath.row]
            
            cell.sizeButton.setTitle(data?.highlighted ?? "" + "\(data?.highlighted?.count ?? 0)", for: .normal)
            cell.sizeButton.tag = indexPath.row
            cell.sizeButton.addTarget(self, action: #selector(sizeCollection(_:)), for: .touchUpInside)
            cell.sizeButton.titleLabel?.font = UIFont(name: "Poppins", size: CGFloat(10))
            if indexPath.item == sizeIndex {
                       cell.storeview.backgroundColor = UIColor(hex: "#06B7FD")
                       cell.sizeButton.backgroundColor = UIColor(hex: "#06B7FD")
                       cell.storeview.cornerRadius = 4
                       cell.sizeButton.cornerRadius  = 4
                cell.sizeButton.tintColor = .white
            } else {
                cell.sizeButton.tintColor = UIColor(hex: "#909090")
                cell.storeview.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.sizeButton.backgroundColor = UIColor(hex: "#F1F2F1")
                cell.storeview.cornerRadius = 4
                cell.sizeButton.cornerRadius  = 4
            }
            cell.lbl.text  = data?.highlighted ?? "" + "\(data?.count ?? 0)"
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreFiltersrating_CollectionViewCell", for: indexPath) as! StoreFiltersrating_CollectionViewCell
            let data = RatingmOdel?.counts?[indexPath.row]
           
            cell.lbl.text = data?.highlighted ?? ""
            if indexPath.item == ratingndex {
                       cell.ratingview.backgroundColor = UIColor(hex: "#06B7FD")
                cell.lbl.textColor = .white
                       cell.ratingview.cornerRadius = 4
                                   
                   } else {
                       cell.ratingview.backgroundColor = UIColor(hex: "#F1F2F1")
                       cell.ratingview.cornerRadius = 4
                 
                   }
            return cell

        }
        
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == store_collect{
           
            let data = StoreModel?.counts?[indexPath.row]
        
          
            selectedStores.append(data?.value ?? "")
            
            lastquery =  "brandName:=\(selectedStores)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
           
           
           
           
        
        }else   if collectionView == FilterColletion{
            
            let data = FiltermodelArray[indexPath.row]
            
            FiltermodelArray.removeAll(where: { return $0.isquery == data.isquery})
            
            if(data.isquery == "lvl0"){
                self.SelectedCat0Model = nil
            }
            if(data.isquery == "lvl1"){
                self.SelectedCat0Model = nil
            }
            if(data.isquery == "lvl2"){
                self.SelectedCat0Model = nil
            }
            if(data.isquery == "color"){
                self.SelectedColorModel = nil
            }
            if(data.isquery == "brandName"){
                self.SelectedStoreModel = nil
            }
            if(data.isquery == "averageRating"){
                self.SelectedratingModel = nil
            }
            if(data.isquery == "size"){
                self.SelectedsizeeModel = nil
            }
            
            
                self.FetchData(val: "", txt: "*",facet_by: "lvl0,lvl1,color,brandName,averageRating,price,size,style", isclick: false)

            
        
            
           
        
        }
        else if(collectionView == size_collect){
            let data = sizeModel?.counts?[indexPath.row]
          
            selectedSizes.append(data?.value ?? "")
            
            lastquery =  "size:=\(selectedSizes)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
           
           
           
          
            

        }else if(collectionView == rating_collect){
            var data = RatingmOdel?.counts?[indexPath.row]
            selectedRating.append(Int(data?.value ?? "") ?? 0)
            ratingndex = indexPath.row
            lastquery =  "averageRating:=\(selectedRating)"
//            lastquery =   "brandName:=[\(data?.value ?? "")]"
            data?.isselected = true
            data?.isquery = "averageRating"
           
            self.SelectedratingModel = data
            
            
            if(FiltermodelArray.contains(where: { return $0.isquery == "averageRating"}) == true) {
                FiltermodelArray.removeAll(where: { return $0.isquery == "averageRating"})
                self.FiltermodelArray.append(self.SelectedratingModel!)
            }else{
                self.FiltermodelArray.append(self.SelectedratingModel!)
            }
            
          
            rating_collect.reloadData()
        }else{
            
        }
    }
 
    
}
