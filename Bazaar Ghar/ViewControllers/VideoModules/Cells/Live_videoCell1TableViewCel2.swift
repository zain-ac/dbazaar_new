//
//  Live_videoCell1TableViewCell.swift
//  Bazaar Ghar
//
//  Created by Developer on 14/06/2024.
//

import UIKit


class Live_videoCell1TableViewCel2: UITableViewCell {
    var page = 1
    var catId : String?
    @IBOutlet weak var imageofcell: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subttitle: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var buttontap: UIButton!
    @IBOutlet weak var videocategoryCollectionView: UICollectionView!
    weak var navigationController: UINavigationController?

    var LiveStreamingResultsdata: [LiveStreamingResults] = []{
        didSet{
            self.imageofcell.pLoadImage(url: LiveStreamingResultsdata.first?.thumbnail ?? "")
            self.title.text =  LiveStreamingResultsdata.first?.brandName ?? ""
            self.subttitle.text =  LiveStreamingResultsdata.first?.brandName ?? ""
            self.views.text =  "\(LiveStreamingResultsdata.first?.totalViews ?? 0)" + "views"
            self.videocategoryCollectionView.reloadData()
        }
    }
    var LiveStreamingResultsAlldata: [LiveStreamingResults] = []

    var id : String? {
        didSet{
//            getStreamingVideos(limit:20,page:1,categories: [id ?? ""])
        }
    }
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "Live_videoCell1", bundle: nil)
        videocategoryCollectionView.register(nib, forCellWithReuseIdentifier: "Live_videoCell1")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnTapped(_ sender: UIButton) {
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        vc.LiveStreamingResultsdata = self.LiveStreamingResultsAlldata
        vc.indexValue = sender.tag
        vc.page = self.page
        vc.catId = catId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//    private func getStreamingVideos(limit:Int,page:Int,categories: [String],city:String){
//        APIServices.getStreamingVideos(limit:limit,page:page,categories:categories,userId:"", city: city,completion: {[weak self] data in
//            switch data{
//            case .success(let res):
//               //
//        
//                self?.LiveStreamingResultsdata = res.results ?? []
//       
//
//            case .failure(let error):
//                print(error)
////                self?.view.makeToast(error)
//            }
//        })
//    }
    
}

extension Live_videoCell1TableViewCel2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LiveStreamingResultsdata.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = LiveStreamingResultsdata[indexPath.row + 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Live_videoCell1", for: indexPath) as! Live_videoCell1
        cell.productimg.pLoadImage(url: data.thumbnail ?? "")
        cell.videoimg.pLoadImage(url: data.thumbnail ?? "")
        cell.viewslbl.text = "\(data.totalViews ?? 0)"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.videocategoryCollectionView.frame.width/2.05, height: self.videocategoryCollectionView.frame.height/2.02)

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let data = buttontap.tag + 1 + indexPath.row
        let vc = New_SingleVideoview.getVC(.videoStoryBoard)
        vc.page = self.page
        vc.catId = self.catId
            vc.LiveStreamingResultsdata = self.LiveStreamingResultsAlldata
            vc.indexValue = data
            self.navigationController?.pushViewController(vc, animated: false)
       
//                let data = LiveStreamingResultsdata[indexPath.row]
//
//                let vc = SingleVideoView.getVC(.main)
//                vc.LiveStreamingResultsdata = self.LiveStreamingResultsdata
//                vc.indexValue = indexPath.row
//                self.navigationController?.pushViewController(vc, animated: false)
        }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.zero // No insets
     }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // No spacing between lines
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // No spacing between items
    }
}
