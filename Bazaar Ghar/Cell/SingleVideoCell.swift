//
//  SingleVideoCell.swift
//  Bazaar Ghar
//
//  Created by Umair ALi on 27/09/2023.
//

import UIKit
import AVFoundation
import AVKit
import Presentr

class SingleVideoCell: UITableViewCell {
    @IBOutlet weak var likelbl: UILabel!
    @IBOutlet weak var likeview: UIView!
    @IBOutlet weak var shareview: UIView!
    @IBOutlet weak var exclamationview: UIView!
    @IBOutlet weak var volumeview: UIView!
    
    @IBOutlet weak var expandview: UIView!
    
    
    
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var saysomethingfield: UITextField!
    @IBOutlet weak var buybtn: UIButton!
    @IBOutlet weak var messagebtn: UIButton!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var sharebtn: UIButton!
    @IBOutlet weak var exclamationbtn: UIButton!
    @IBOutlet weak var volumebtn: UIButton!
    @IBOutlet weak var hiddenview: UIView!
 
    @IBOutlet weak var followbtn: UIButton!
    @IBOutlet weak var expandbtn: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var videoProductCollectionV: UICollectionView!
    @IBOutlet weak var videoPlayBtn: UIButton!
    @IBOutlet weak var hiddenviewheight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeigth: NSLayoutConstraint!
    @IBOutlet weak var dropDownBtn: UIButton!

    @IBOutlet weak var storeimg: UIImageView!
    
    @IBOutlet weak var viewslbl: UILabel!
    @IBOutlet weak var storeImgView: UIView!
    @IBOutlet weak var commentBtn: UIButton!


    let centerTransitioningDelegate = CenterTransitioningDelegate()
    var randomproductapiModel: [PChat] = []

    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false

    var observer: Any? = nil
    let interval = CMTime(seconds: 1.0, preferredTimescale: 10)
    var LiveStreamingResultsdataArray: LiveStreamingResults? = nil{
        didSet{
            let fileUrl = URL(string: LiveStreamingResultsdataArray?.streamingURL ?? "")
            self.videoPlayerItem = AVPlayerItem.init(url:fileUrl!)
    
            
            self.headerlbl.text = LiveStreamingResultsdataArray?.title
            self.storename.text = LiveStreamingResultsdataArray?.brandName
        }
    }
    var videoPlayerItem: AVPlayerItem? = nil {
          didSet {
              if let videoPlayerItem = videoPlayerItem {
//                  videoPlayerItem.preferredForwardBufferDuration = 4  // Buffer 10 seconds ahead for faster start
//                                  videoPlayerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
//                                  videoPlayerItem.preferredPeakBitRate = 500
//                  s for smoother playback
                  
                  avPlayer?.replaceCurrentItem(with: videoPlayerItem)
              }
          }
      }

    
    var getvidoebyproductIdsdata: [Product] = []
    var productIds = [String](){
        didSet {
            getvidoebyproductIds(productIds: productIds)
        }
    }
    
    weak var navigationController: UINavigationController?
    
    var isliked: Bool? {
        didSet{
            isliked ?? false ? likebtn.setBackgroundImage(UIImage(named: "like_fill" ), for: .normal) : likebtn.setBackgroundImage(UIImage(named: "likethumb" ), for: .normal)
        }
    }
    var likeId = ""
   
    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenviewheight.constant = 0
        self.setupMoviePlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(hideandshow), name: NSNotification.Name(rawValue: "showviews"), object: nil)

       }
    
    
    @objc func hideandshow(notification: Notification) {
         volumeview.isHidden = false
         volumebtn.isHidden = false
         exclamationview.isHidden = false
         exclamationbtn.isHidden = false
         expandbtn.isHidden = false
         shareview.isHidden = false
         sharebtn.isHidden = false
         likeview.isHidden = false
         likebtn.isHidden = false
         expandview.isHidden = false
         expandbtn.isHidden = false
         followbtn.isHidden = false
         storename.isHidden = false
         storeimg.isHidden = false
         headerlbl.isHidden = false
         hiddenview.isHidden = false
         buybtn.isHidden = false
         likelbl.isHidden = false
         storeImgView.isHidden = false
          commentBtn.isHidden = false

    }

    
       func setupMoviePlayer(){
          
           self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
           avPlayerLayer = AVPlayerLayer(player: avPlayer)
           avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
           avPlayer?.volume = 3
           avPlayer?.actionAtItemEnd = .none

           //        You need to have different variations
           //        according to the device so as the avplayer fits well
       
               avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height)
          
           self.backgroundColor = .clear
           self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)

           // This notification is fired when the video ends, you can handle it in the method.
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: avPlayer?.currentItem)
           //avPlayer?.addObserver(self, forKeyPath: timespec(), options: [.old, .new], context: nil)
       }
    
    func getvidoebyproductIds(productIds:[String]){
       APIServices.getvidoebyproductIds(productIds:productIds){[weak self] data in
           switch data{
           case .success(let res):
               self?.getvidoebyproductIdsdata = res
              self?.videoProductCollectionV.reloadData()
           case .failure(let error):
               print(error)
           }
       }
   }

       func stopPlayback(){
           self.avPlayer?.pause()
           removeObserver()
           paused = true
       }

       func startPlayback(){
//           self.addObserver()
           self.avPlayer?.play()
           paused = false
       }

       // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
           let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
       }
    
    
    func removeObserver() {
        if let observer = self.observer {
            avPlayer?.removeTimeObserver(observer)
            self.observer = nil
        }
    }
    
    func addObserver() {
        let intervel : CMTime = CMTimeMake(value: 10, timescale: 10)
        observer = avPlayer?.addPeriodicTimeObserver(forInterval: intervel, queue: DispatchQueue.main) { [weak self] time in

            guard let `self` = self,
                let playerItem = self.avPlayer?.currentItem else { return }

            let currentTime : Float64 = CMTimeGetSeconds(time)
            let totalDuration = CMTimeGetSeconds(playerItem.asset.duration)

            //this is the slider value update if you are using UISlider.
            let sliderValue = (currentTime/totalDuration)

            if currentTime >= totalDuration {
                if let observer = self.observer{
                    //removing time observer
                    self.avPlayer?.removeTimeObserver(observer)
                    self.observer = nil
                }
            }

            let playbackLikelyToKeepUp = self.avPlayer?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print(self.avPlayer?.rate)
                UIApplication.startActivityIndicator()
            } else {
                //stop the activity indicator
                UIApplication.stopActivityIndicator()
            }
        }
    }
    func toggleMute() {
        if let player = avPlayer {
            player.isMuted = !player.isMuted
            updateMuteButtonImage()
        }
    }
    func updateMuteButtonImage() {
        if let player = avPlayer {
            let image = player.isMuted ? UIImage(named: "muteIcon") : UIImage(named: "speakerOn")
            volumebtn.setImage(image, for: .normal)
        }
    }

    @IBAction func buybtnTapped(_ sender: UIButton) {
       
        if getvidoebyproductIdsdata.count == 0 {
            UIApplication.pTopViewController().view.makeToast("Showcase product data not found")
        }else {
            if hiddenview.isHidden == false {
                hiddenview.isHidden = true
                hiddenviewheight.constant = 0
            }else{
                hiddenview.isHidden = false
                hiddenviewheight.constant = 150

            }
        }
    }
    @IBAction func volumebtnTapped(_ sender: UIButton) {
        toggleMute()
    }
    @IBAction func dropDownBtnTapped(_ sender: UIButton) {
       
        if topViewHeigth.constant == 130 {
            topViewHeigth.constant = 35
            headerlbl.isHidden = true
            storename.isHidden = true
            dropDownBtn.setImage(UIImage(named: "dropdownselect"), for: .normal)

        }else {
            topViewHeigth.constant = 130
            headerlbl.isHidden = false
            storename.isHidden = false
            dropDownBtn.setImage(UIImage(named: "dropdownunselect"), for: .normal)

        }
    }
}
   
extension SingleVideoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getvidoebyproductIdsdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoProductCollectionViewCell", for: indexPath) as! videoProductCollectionViewCell
        let data = getvidoebyproductIdsdata[indexPath.row]
        
        cell.img.pLoadImage(url: data.mainImage ?? "")
        cell.price.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.price ?? 0)
        cell.productname.text = data.productName

        
        
        if data.onSale == true {
            cell.Salesprice.isHidden = false
            cell.price.isHidden = false
            cell.Salesprice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.salePrice ?? 0))
            cell.price.text = appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0)
            cell.productPriceLine.isHidden = false
            cell.price.textColor = UIColor.red
            cell.productPriceLine.backgroundColor = UIColor.red
        }else {
            cell.productPriceLine.isHidden = true
            cell.price.isHidden = true
            cell.Salesprice.attributedText = Utility().formattedText(text: appDelegate.currencylabel + Utility().formatNumberWithCommas(data.regularPrice ?? 0))
         }
        
        
        
//        if data.onSale == true {
//            cell.price.isHidden = false
//            cell.price.isHidden = false
//            cell.price.text = "NOW " + appDelegate.currencylabel + " \(data.salePrice ?? 0)"
//            cell.productPriceLine.isHidden = false
//            cell.price.textColor = UIColor.systemGray
//            cell.price.text = "WAS " + appDelegate.currencylabel + " \(data.price ?? 0)"
//        }else {
//            cell.Salesprice.isHidden = true
//            cell.productPriceLine.isHidden = true
//            cell.price.textColor = UIColor.black
//         }
        cell.buynow.tag = indexPath.row
        cell.buynow.addTarget(self, action: #selector(viewallitemtap(_:)), for: .touchUpInside)
            return cell
    }
    @objc func viewallitemtap(_ sender: UIButton) {
        let data = getvidoebyproductIdsdata[sender.tag]
        
        
        if (data.variants?.first?.id == nil) {
            let vc = CartPopupViewController.getVC(.main)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = centerTransitioningDelegate
            vc.nav = self.navigationController
            vc.products = data
            UIApplication.pTopViewController().present(vc, animated: true, completion: nil)
        }else {
            let vc = NewProductPageViewController.getVC(.sidemenu)
            vc.slugid = data.slug
            navigationController?.pushViewController(vc, animated: false)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.videoProductCollectionV.frame.width/1.2, height: self.videoProductCollectionV.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = getvidoebyproductIdsdata[indexPath.row]
//
//        let vc = ProductDetail_VC.getVC(.main)
//        vc.isGroupBuy = false
//        vc.slugid = data.slug
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

