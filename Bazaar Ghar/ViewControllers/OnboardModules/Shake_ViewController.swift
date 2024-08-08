//
//  Shake_ViewController.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 25/07/2024.
//

import UIKit

class Shake_ViewController: UIViewController {
    @IBOutlet weak var shake_collect: UICollectionView!
    var images = ["1", "2", "3"]
       var labels = ["Shake It", "Shopping beyound boundaries", "Engagement and experience"]
       var descriptions = ["Shake your device to instantly transform it into a live video shopping portal bringing the live video shopping portal.", "Shake your device to instantly transform it into a live video shopping portal bringing the live video shopping portal.", "Shake your device to instantly transform it into a live video shopping portal bringing the live video shopping portal."]
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        shake_collect.delegate = self
        shake_collect.dataSource = self
      

        // Do any additional setup after loading the view.
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
        cell.updateColors(forIndex: indexPath.item)

        return cell
        
    }
    @objc func nextbtn(sender: UIButton) {
           currentIndex += 1
           
        
        if(currentIndex == images.count){
            appDelegate.GotoDashBoard(ischecklogin: false)
        }
        
        
           if currentIndex >= images.count {
               currentIndex = 0
           }
           
           let indexPath = IndexPath(item: currentIndex, section: 0)
           
           // Scroll to the new item
           shake_collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
           
           // Reload the specific item to update its color
           shake_collect.reloadItems(at: [indexPath])
           
           // Optionally, if you want to ensure the cell is visible
           if let cell = shake_collect.cellForItem(at: indexPath) as? Shake_CollectionViewCell {
               cell.updateColors(forIndex: currentIndex)
           }
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    
}

