import UIKit
class Shake_ViewController: UIViewController {
    @IBOutlet weak var shake_collect: UICollectionView!
    
    var images = ["1", "2", "3"]
    var labels = ["Shake It", "Shopping beyound boundaries", "Engagement and experience"]
    var descriptions = ["Shake your device to transform it into a live shopping experience", " Now shop authentic products from Pakistan, China, and KSA.", "Interact and enjoy the physical like experience to find the right product"]
    var currentIndex = 0
    var pdfImages: [String] = ["indicator_1", "indicator_2", "indicator_3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shake_collect.delegate = self
        shake_collect.dataSource = self
        self.tabBarController?.tabBar.isHidden = true
        if let layout = shake_collect.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 0 // Set spacing between items to zero
                    layout.minimumInteritemSpacing = 0 // Set spacing between items to zero
                }

                shake_collect.isPagingEnabled = true
                shake_collect.showsHorizontalScrollIndicator = false
        
        
    }
}
extension Shake_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shake_CollectionViewCell", for: indexPath) as! Shake_CollectionViewCell
        
        cell.bgimg.image = UIImage(named: images[indexPath.item])
        cell.lbl_first.text = labels[indexPath.item]
        cell.descriptiontxt.text = descriptions[indexPath.item]
        cell.nextbtn.tag = indexPath.row
        cell.nextbtn.addTarget(self, action: #selector(nextbtn(sender:)), for: .touchUpInside)
        cell.skipbtn.addTarget(self, action: #selector(skipbtn(sender:)), for: .touchUpInside)
        cell.indicatorimg.image = UIImage(named: (pdfImages[indexPath.item]))
        cell.shipview.isHidden = (indexPath.item == 2)

        if currentIndex == 2 {
            cell.shipview.isHidden = true
           } else {
               cell.shipview.isHidden = false
           }
        return cell
        
    }
    @objc func skipbtn(sender: UIButton) {
        appDelegate.GotoDashBoard(ischecklogin: false)


    }
    @objc func nextbtn(sender: UIButton) {
        // Increment the current index to move to the next item
        currentIndex += 1
       
        // If currentIndex reaches the end of the images array
        if currentIndex >= images.count {
            // Navigate to the dashboard if all items are viewed
            appDelegate.GotoDashBoard(ischecklogin: false)
            return
        }

        // Create the new IndexPath for the current item
        let indexPath = IndexPath(item: currentIndex, section: 0)

        // Scroll to the new item in the collection view
        shake_collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)

        // Reload the specific item to ensure the visual representation is updated
        shake_collect.reloadItems(at: [indexPath])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           // Get the index paths of visible items
           let visibleIndexPaths = shake_collect.indexPathsForVisibleItems
           
           // Check if there are visible items
           if let firstVisibleIndexPath = visibleIndexPaths.first {
               // Update currentIndex based on the first visible item's index path
               currentIndex = firstVisibleIndexPath.item
           }
       }
    }
    
    
   


