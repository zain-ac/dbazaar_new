//
//  NewProductPageViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 08/07/2024.
//

import UIKit
import FSPagerView

class NewProductPageViewController: UIViewController {
    @IBOutlet weak var deliveryTableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var headerBackgroudView: UIView!
    var items: [Item] = [
            Item(image: UIImage(named: "truck")!, title: "Receive by 29 Jun - 6 Jul",subtitle: "Get the order in 3 - 5 days"),
            Item(image: UIImage(named: "d 1")!, title: "Cash On Delivery",subtitle: "Cash on Delivery available"),
            Item(image: UIImage(named: "d 2")!, title: "Seven Days Return",subtitle: "Return your order in seven days"),
            Item(image: UIImage(named: "d 3")!, title: "Warranty Available",subtitle: "Get warranty on our products"),
            // Add more items as needed
        ]

    var bannerapidata: [Banner]? = [] {
        didSet{
            self.pagerView.reloadData()

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        bannerApi(isbackground: false)
        // Do any additional setup after loading the view.
    }
    private func bannerApi(isbackground:Bool){
        APIServices.banner(isbackground: isbackground, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(data)
                if(res.count > 0){
                    let banners =  res
                    
                   
                    for item in res{
                        let objext = item.id
                        if objext?.bannerName == "Mob Banner Home" {
                            self?.bannerapidata = (objext?.banners)!
                        }
                    }
                }
    
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
        )
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

extension NewProductPageViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return  bannerapidata?.count ?? 0
        
        
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let data = bannerapidata?[index]
        cell.imageView?.pLoadImage(url: data?.image ?? "")
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
        
        
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        //        if pagerView == self.pagerView {
        //            let currentIndex = pagerView.currentIndex
        //            pageControl.currentPage = currentIndex
        //        }else {
        //            let currentIndex = pagerView.currentIndex
        //            pageControl.currentPage = currentIndex
        //        }
        
    }
}
    
extension NewProductPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return items.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data  = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDellivevryTableViewCell", for: indexPath) as! ProductDetailsDellivevryTableViewCell
        cell.img.image = data.image
        cell.title.text = data.title
        cell.subtitle.text = data.subtitle
  
            return cell
           
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            return 67
        
    }
}
struct Item {
    let image: UIImage
    let title: String
    let subtitle: String
}
