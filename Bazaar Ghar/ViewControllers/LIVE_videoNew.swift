//
//  LIVE_videoNew.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit

class LIVE_videoNew: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchFeild: UITextField!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var videocategorytableview: UITableView!
    var LiveVideoData: [LiveVideoResponse] = []
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var CategoriesResponsedata: [CategoriesResponse] = [] {
        didSet {
            videocategorytableview.reloadData()
        }
    }
    var searchVideodata: [LiveStreamingResults] = []
    var indexPath : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "Live_videoCell1TableViewCell", bundle: nil)
         videocategorytableview.register(nib, forCellReuseIdentifier: "Live_videoCell1TableViewCell")
        let nib2 = UINib(nibName: "Live_videoCell1TableViewCel2", bundle: nil)
         videocategorytableview.register(nib2, forCellReuseIdentifier: "Live_videoCell1TableViewCel2")
//        let nib2 = UINib(nibName: "Live_videoCell2TableViewCell", bundle: nil)
//               videocategorytableview.register(nib2, forCellReuseIdentifier: "Live_videoCell2TableViewCell")
        Utility().setGradientBackground(view: headerview, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        // Do any additional setup after loading the view.
        videocategorytableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchFeild.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CategoriesResponsedata = AppDefault.CategoriesResponsedata ?? []
        getLiveStream()
//        getStreamingVideos(limit:20,page:1,categories: [])
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Combine the current text with the new replacement string
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        
//        // Trigger the search function
//        searchVideo(name: "searchName", value: updatedText, limit: 10, catId: ["category1", "category2"])
//        
//        return true
//    }
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String]){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"",completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
        
                self?.LiveStreamingResultsdata = res.results ?? []
       

            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    
    
    
    private func searchVideo(name:String,value:String,limit:Int,catId:[String]){
        APIServices.searchVideo(name:name,value:value,limit:limit,catId: catId){[weak self] data in
            switch data{
            case .success(let res):
//                if res.results.count > 0 {
//                    self?.notFound.isHidden = true
//                }else {
//                    self?.notFound.isHidden = false
//                }
                self?.searchVideodata = res.results
              print(res)
                self?.videocategorytableview.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func getLiveStream(){
        APIServices.getLiveStream(completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)

                self?.LiveVideoData = res
                
              
                self?.videocategorytableview.reloadData()
                
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    
    @IBAction func seachTap(_ sender: Any) {
        if(searchFeild.text == ""){
            searchVideo(name: "title", value:  "", limit: 20, catId: [])        }
        else{
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 20, catId: [])
        }
    }
    
    
    @IBAction func categoriesTap(_ sender: Any) {
        let vc = CategoriesPopUpVC.getVC(.main)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func cartbutton(_ sender: Any) {
        let vc = Search_ViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    @IBAction func nearByTap(_ sender: Any) {
    }
}
extension LIVE_videoNew:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchVideodata.isEmpty){
            return CategoriesResponsedata.count
        }else{
            return searchVideodata.count / 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(searchVideodata.isEmpty){
            let data = CategoriesResponsedata[indexPath.row]
    //        getStreamingVideos(limit:20,page:1,categories: [data.id ?? ""])
            self.indexPath = indexPath
            if indexPath.row % 2 == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCell", for: indexPath) as! Live_videoCell1TableViewCell
                cell.id = data.id
                let inset: CGFloat = 10 // A
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCel2", for: indexPath) as! Live_videoCell1TableViewCel2
                cell.id = data.id
              
                let inset: CGFloat = 10 // A
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.navigationController  = self.navigationController
                return cell
            }
        }else{
            let data = searchVideodata[indexPath.row]
    //        getStreamingVideos(limit:20,page:1,categories: [data.id ?? ""])
            self.indexPath = indexPath
            if indexPath.row % 2 == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCell", for: indexPath) as! Live_videoCell1TableViewCell
//                cell.id = data.id
                let inset: CGFloat = 10 // A
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCel2", for: indexPath) as! Live_videoCell1TableViewCel2
                cell.id = data.id
              
                let inset: CGFloat = 10 // A
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.navigationController  = self.navigationController
                return cell
            }
        }
       
        
       
       

    }
   
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
