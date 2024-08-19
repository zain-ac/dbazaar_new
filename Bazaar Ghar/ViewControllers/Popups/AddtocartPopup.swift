//
//  AddtocartPopup.swift
//  Bazaar Ghar
//
//  Created by Zany on 05/07/2024.
//

import UIKit

class AddtocartPopup: UIViewController {
    
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!


    var img:String?
    var titleText:String?
    var messageText:String?
    var leftBtnText:String?
    var rightBtnText:String?

    var iscomefor:String?
    var prductid = String()
    var nav:UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Image.image = UIImage(named: img ?? "")
        titleLbl.text = titleText ?? ""
        messageLbl.text = messageText
        leftBtn.setTitle(leftBtnText, for: .normal)
        rightBtn.setTitle(rightBtnText, for: .normal)
    }
    
    private func chinesebell(sellerId:String,brandName:String,description:String){
        APIServices.chinesebell(sellerId: sellerId, brandName: brandName, description: description){[weak self] data in
            switch data{
            case .success(_): break
             //
            case .failure(let error):
                print(error)
                if(error == "Please authenticate" && AppDefault.islogin){
                    appDelegate.refreshToken(refreshToken: AppDefault.refreshToken)
                }else if(error == "Please authenticate" && !AppDefault.islogin) {
                    let vc = PopupLoginVc.getVC(.popups)
                  vc.modalPresentationStyle = .overFullScreen
                  self?.present(vc, animated: true, completion: nil)
                }else{
                    self?.view.makeToast(error)
                }
            }
        }
    }
    

    @IBAction func rightBtnTapped(_ sender: Any) {
        if iscomefor == "video" {
            self.chinesebell(sellerId:self.prductid , brandName: AppDefault.brandname, description: "sellerDescription")
        } else if iscomefor == "cart" {
            let vc = CartViewController.getVC(.main)
            self.nav?.pushViewController(vc, animated: false)
        }
//        let vc = CartViewController
//            .getVC(.main)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func leftBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
   

}
