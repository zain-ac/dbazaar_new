//
//  NewProductPageViewController.swift
//  Bazaar Ghar
//
//  Created by Zany on 08/07/2024.
//

import UIKit
import FSPagerView

class NewProductPageViewController: UIViewController {
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var headerBackgroudView: UIView!

    var bannerapidata: [Banner]? = [] {
        didSet{
            self.pagerView.reloadData()

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedText11 =  Utility().attributedStringWithColoredStrings(appDelegate.currencylabel, firstTextColor: UIColor.black, Utility().formatNumberWithCommas(220 ?? 0), secondTextColor:  UIColor(hexString: "#06B7FD"))
       
        discountPrice.text =    appDelegate.currencylabel + Utility().formatNumberWithCommas(120 ?? 0)
      
        productPrice.attributedText =   attributedText11
      
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
    
