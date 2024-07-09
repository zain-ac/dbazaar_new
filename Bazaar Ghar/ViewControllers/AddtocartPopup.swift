//
//  AddtocartPopup.swift
//  Bazaar Ghar
//
//  Created by Zany on 05/07/2024.
//

import UIKit

class AddtocartPopup: UIViewController {
    @IBOutlet weak var productimg: UIImageView!
    
    @IBOutlet weak var gotobtntxt: UIButton!
    @IBOutlet weak var continuebtntxt: UIButton!
    @IBOutlet weak var successfullyaddedtxt: UILabel!
    @IBOutlet weak var addtotxt: UILabel!
    
    var  img = String()
    var label = String()
    var  descriptiontxt = String()
    var cancelbtn = String()
    var continuebtn = String()

    
    
    
    
    override func viewDidLoad( ) {
        super.viewDidLoad()
        productimg.image = UIImage(named: img)
        addtotxt.text = label
        successfullyaddedtxt.text = descriptiontxt
        continuebtntxt.setTitle(continuebtn, for: .normal)
        gotobtntxt.setTitle(cancelbtn, for: .normal)
        
    }
    

    @IBAction func GotoCartBtn(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func continueShopping(_ sender: Any) {
        self.dismiss(animated: true)
        
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
