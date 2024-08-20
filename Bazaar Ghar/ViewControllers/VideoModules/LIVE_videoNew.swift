//
//  LIVE_videoNew.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit

class LIVE_videoNew: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchFeild: UITextField!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var videocategorytableview: UITableView!
    
    @IBOutlet weak var categoryview: UIView!
    @IBOutlet weak var novideosview: UIView!
    @IBOutlet weak var catbtnview: UIView!
    @IBOutlet weak var nearByView: UIView!
    var LiveVideoData: [LiveStreamingResults] = []
    var LiveStreamingResultsdata: [LiveStreamingResults] = []
    var LiveStreamingResultsdatafilter: [LiveStreamingResults] = []

    var CategoriesResponsedata: [CategoriesResponse] = [] {
        didSet {
//            videocategorytableview.reloadData()
        }
    }
    var searchVideodata: [LiveStreamingResults] = []
    var searchVideodatafilter: [LiveStreamingResults] = []
    var indexPath : IndexPath?
    var cat:String?
    var id:String?
    var isLoadingData = false
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "Live_videoCell1TableViewCell", bundle: nil)
         videocategorytableview.register(nib, forCellReuseIdentifier: "Live_videoCell1TableViewCell")
        let nib2 = UINib(nibName: "Live_videoCell1TableViewCel2", bundle: nil)
         videocategorytableview.register(nib2, forCellReuseIdentifier: "Live_videoCell1TableViewCel2")
//        let nib2 = UINib(nibName: "Live_videoCell2TableViewCell", bundle: nil)
//               videocategorytableview.register(nib2, forCellReuseIdentifier: "Live_videoCell2TableViewCell")
        Utility().setGradientBackground(view: headerview, colors: [primaryColor, primaryColor, headerSecondaryColor])

        // Do any additional setup after loading the view.
        videocategorytableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchFeild.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.method(notification:)), name: Notification.Name("idpass"), object: nil)
        searchFeild.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           let currentText = textField.text ?? ""
        if currentText == "" {
            searchVideo(name: "title", value:  "", limit: 100, catId: [])
        }else {
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 100, catId: [])
        }
        
       }
    
    @objc func method(notification: Notification) {
        if let id = notification.userInfo?["id"] as? String {
            print(id)
            self.id = id
            LiveStreamingResultsdata.removeAll()
            searchVideodata.removeAll()
            catbtnview.backgroundColor = .oceanBlue
            nearByView.backgroundColor = UIColor(hex: "#5ED0FD")
            getStreamingVideos(limit:100,page:1,categories: [self.id ?? ""], city: "")

        }
        if let cat = notification.userInfo?["cat"] as? String {
            print(cat)
            self.cat = cat
        }
        if let catname = notification.userInfo?["catname"] as? String {
            headerlbl.text = catname
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        headerlbl.text = "Live Video"
        self.CategoriesResponsedata = AppDefault.CategoriesResponsedata ?? []
        getStreamingVideos(limit:100,page:1,categories: [], city: "")
        getLiveStream()
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
    
    private func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: city,completion: {[weak self] data in
            switch data{
            case .success(let res):
               //
                self?.isLoadingData = false

                self?.LiveStreamingResultsdata += res.results ?? []
                self?.videocategorytableview.reloadData()
                self?.count += 1
                if res.results?.count ?? 0 > 5 {
                    self?.novideosview.isHidden = true
                    
                }else {
                    self?.novideosview.isHidden = false
//                    self?.categoryview.isHidden = false
                }
            case .failure(let error):
                print(error)
//                self?.view.makeToast(error)
            }
        })
    }
    
    func loadMoreData() {
            guard !isLoadingData else { return }
            isLoadingData = true
            
            // Simulate an async data fetch
            DispatchQueue.global().async {
                // Fetch your additional data here
                let moreItems = ["Item 4", "Item 5", "Item 6"] // Example data
                
                // Simulate a network delay
                sleep(2)
                
                DispatchQueue.main.async {
                    if self.cat == "cat" {
                        self.getStreamingVideos(limit:100,page:self.count,categories: [self.id ?? ""], city: "")

                    }else {
                        self.getStreamingVideos(limit:100,page:self.count,categories: [], city: "")
                    }
                    self.isLoadingData = false
                }
            }
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
                
                if res.results.count > 5 {
                    self?.novideosview.isHidden = true
                    
                }else {
                    self?.novideosview.isHidden = false
//                    self?.categoryview.isHidden = false
                }
             //
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
               //
                
                self?.LiveVideoData = res
                if(self?.LiveVideoData.count != 0){
                    
                    AppDefault.socketId = self?.LiveVideoData[0].resultID ?? ""
                }
                self?.videocategorytableview.reloadData()
                
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    
    @IBAction func seachTap(_ sender: Any) {
        if(searchFeild.text == ""){
            searchVideo(name: "title", value:  "", limit: 100, catId: [])
        }
        else{
            searchVideo(name: "title", value: searchFeild.text ?? "", limit: 100, catId: [])
        }
    }
    
    
    @IBAction func categoriesTap(_ sender: Any) {
        let vc = CategoriesPopUpVC.getVC(.popups)
        vc.modalPresentationStyle = .overFullScreen
        vc.id = self.id
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func cartbutton(_ sender: Any) {
        let vc = CartViewController.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    @IBAction func nearByTap(_ sender: Any) {
        LiveStreamingResultsdata.removeAll()
        searchVideodata.removeAll()
        count = 0
        nearByView.backgroundColor = .oceanBlue
        catbtnview.backgroundColor = UIColor(hex: "#5ED0FD")
        self.id = nil
        self.getStreamingVideos(limit:100,page:self.count,categories: [], city: "islamabad")
    }
}
extension LIVE_videoNew:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFeild.text == "" {
            if(searchVideodata.isEmpty){
//                return Utility().combinedRoundDown(Double(LiveStreamingResultsdata.count / 5) - 1)
                return  LiveStreamingResultsdata.count / 5
            }else{
                return Utility().combinedRoundDown(Double(searchVideodata.count / 5) - 1)
            }
        }else {
//            return Utility().combinedRoundDown(Double(searchVideodata.count / 5) - 1)
            return searchVideodata.count / 5

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(searchVideodata.isEmpty){
//            let data = CategoriesResponsedata[indexPath.row]
    //        getStreamingVideos(limit:20,page:1,categories: [data.id ?? ""])
            self.indexPath = indexPath
            if indexPath.row % 2 == 0 {
                LiveStreamingResultsdatafilter.removeAll()

                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCell", for: indexPath) as! Live_videoCell1TableViewCell
//                if cat == "cat" {
//                    cell.id = self.id.
//                }else {
//                    cell.id = data.id
//                }
                
                let answer = (indexPath.row + 1) * 5
                let checkval = LiveStreamingResultsdata.count - answer
                
                if(checkval > 5){
                    for i in indexPath.row * 5...indexPath.row * 5 + 5 {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }else{
                    for i in indexPath.row * 5...indexPath.row * 5 + checkval {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }
                
                
                
                cell.btntap.tag = indexPath.row * 5
                cell.LiveStreamingResultsdata = LiveStreamingResultsdatafilter
                let inset: CGFloat = 10 // A
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.LiveStreamingResultsAlldata = LiveStreamingResultsdata
                if self.LiveVideoData.count  > 0 {
                    cell.LiveVideoData = self.LiveVideoData
                }
                return cell
            } else {
                LiveStreamingResultsdatafilter.removeAll()

                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCel2", for: indexPath) as! Live_videoCell1TableViewCel2
                let answer = (indexPath.row + 1) * 5
                let checkval = LiveStreamingResultsdata.count - answer
                
                if(checkval > 5){
                    for i in indexPath.row * 5...indexPath.row * 5 + 5 {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }else{
                    for i in indexPath.row * 5...indexPath.row * 5 + checkval {
                        LiveStreamingResultsdatafilter.append(LiveStreamingResultsdata[i])
                    }
                }
                cell.buttontap.tag = indexPath.row * 5
              
                cell.LiveStreamingResultsdata = LiveStreamingResultsdatafilter
                let inset: CGFloat = 10 // A
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.navigationController  = self.navigationController
                cell.LiveStreamingResultsAlldata = LiveStreamingResultsdata

                return cell
            }
        }else{
            let data = searchVideodata[indexPath.row]
    //       self.indexPath = indexPath
            if indexPath.row % 2 == 0 {
                searchVideodatafilter.removeAll()

                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCell", for: indexPath) as! Live_videoCell1TableViewCell
//                if cat == "cat" {
//                    cell.id = self.id.
//                }else {
//                    cell.id = data.id
//                }
                
                let answer = (indexPath.row + 1) * 5
                let checkval = searchVideodata.count - answer
                
                if(checkval > 5){
                    for i in indexPath.row * 5...indexPath.row * 5 + 5 {
                        searchVideodatafilter.append(searchVideodata[i])
                    }
                }else{
                    for i in indexPath.row * 5...indexPath.row * 5 + checkval {
                        searchVideodatafilter.append(searchVideodata[i])
                    }
                }
                
                
                cell.btntap.tag = indexPath.row * 5
                
                cell.LiveStreamingResultsdata = searchVideodatafilter
                let inset: CGFloat = 10 // A
                
                cell.navigationController  = self.navigationController
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.LiveStreamingResultsAlldata = searchVideodata
               

                return cell
            } else {
                searchVideodatafilter.removeAll()

                let cell = tableView.dequeueReusableCell(withIdentifier: "Live_videoCell1TableViewCel2", for: indexPath) as! Live_videoCell1TableViewCel2
                let answer = (indexPath.row + 1) * 5
                let checkval = searchVideodata.count - answer
                
                if(checkval > 5){
                    for i in indexPath.row * 5...indexPath.row * 5 + 5 {
                        searchVideodatafilter.append(searchVideodata[i])
                    }
                }else{
                    for i in indexPath.row * 5...indexPath.row * 5 + checkval {
                        searchVideodatafilter.append(searchVideodata[i])
                    }
                }
                
                cell.buttontap.tag = indexPath.row * 5

                cell.LiveStreamingResultsdata = searchVideodatafilter
                let inset: CGFloat = 10 // A
                cell.views.frame = cell.views.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
                cell.navigationController  = self.navigationController
                cell.LiveStreamingResultsAlldata = searchVideodata
              
                return cell
            }

        }
    }
   
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

